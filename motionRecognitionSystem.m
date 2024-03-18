function motionRecognitionSystem(inputSource)
    % Check if the input is for webcam usage
    if strcmp(inputSource, "webcam")
        % Process video from webcam
        try
            cam = webcam; % Requires the Webcam Support Package
            disp('Press CTRL+C to stop webcam capture.');
            while true
                frame = snapshot(cam);
                processImage(frame);
                pause(0.1); % Adjust based on your needs
            end
        catch ME
            error('Webcam error: %s', ME.message);
        end
    else
        % Process a single image from file
        try
            image = imread(inputSource);
            processImage(image);
        catch ME
            error('Error reading image. Ensure the file path is correct. Error: %s', ME.message);
        end
    end
end

function processImage(image)
    preprocessedImage = preprocessImage(image);
    enhancedImage = enhanceImage(preprocessedImage);
    [binaryMask, detectedObjects] = segmentImage(enhancedImage);
    features = extractFeatures(detectedObjects, binaryMask);
    % Here, you could add your motion recognition logic using 'features'
    % For demonstration, we'll just display the number of detected objects
    disp(['Detected Objects: ', num2str(length(detectedObjects))]);
end

function preprocessedImage = preprocessImage(image)
    if size(image, 3) == 3
        image = rgb2gray(image);
    end
    preprocessedImage = imresize(image, [256 256]);
end

function enhancedImage = enhanceImage(image)
    filteredImage = medfilt2(image);
    enhancedImage = histeq(filteredImage);
end

function [binaryMask, detectedObjects] = segmentImage(image)
    threshold = graythresh(image);
    binaryMask = imbinarize(image, threshold);
    detectedObjects = regionprops(binaryMask, 'BoundingBox', 'Area');
end

function features = extractFeatures(detectedObjects, image)
    numObjects = length(detectedObjects);
    features = zeros(numObjects, 3); % Example features vector
    for i = 1:numObjects
        obj = detectedObjects(i);
        area = obj.Area;
        centroid = obj.Centroid;
        perimeterImage = bwperim(imbinarize(imcrop(image, obj.BoundingBox)), 8);
        perimeterLength = sum(perimeterImage(:));
        features(i, :) = [area, centroid(1), perimeterLength]; % Example feature set
    end
end
