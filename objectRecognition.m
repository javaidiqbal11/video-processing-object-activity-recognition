function objectRecognition(inputType)
% Object Recognition Function
% inputType: 'image', 'video', or 'webcam'

switch inputType
    case 'image'
        processImage();
    case 'video'
        processVideo();
    case 'webcam'
        processWebcam();
    otherwise
        error('Unsupported input type');
end

end

function processImage()
% Process a single image
img = imread('image.jpg'); % Load your image here
imgProcessed = preprocessAndEnhance(img);
objectsDetected = detectObjects(imgProcessed);
imgHighlighted = extractAndDisplayFeatures(img, objectsDetected);
imshow(imgHighlighted); % Display the image with highlighted objects
title('Detected Objects');
end

function processVideo()
% Process a video file
v = VideoReader('1.mp4'); % Load your video here
videoPlayer = vision.VideoPlayer; % Create a video player object

while hasFrame(v)
    frame = readFrame(v);
    imgProcessed = preprocessAndEnhance(frame);
    objectsDetected = detectObjects(imgProcessed);
    frameHighlighted = extractAndDisplayFeatures(frame, objectsDetected);
    step(videoPlayer, frameHighlighted); % Display the frame with highlighted objects
end

release(videoPlayer); % Release the video player
end

function processWebcam()
% Process input from a webcam
cam = webcam; % Connect to the webcam
videoPlayer = vision.VideoPlayer; % Create a video player object

for idx = 1:100 % Adjust the number of frames to capture
    frame = snapshot(cam);
    imgProcessed = preprocessAndEnhance(frame);
    objectsDetected = detectObjects(imgProcessed);
    frameHighlighted = extractAndDisplayFeatures(frame, objectsDetected);
    step(videoPlayer, frameHighlighted); % Display the frame with highlighted objects
    pause(0.1); % Adjust the capture interval
end

clear('cam'); % Release the webcam
release(videoPlayer); % Release the video player
end

function output = preprocessAndEnhance(img)
% Image Pre-processing and Enhancement
% Convert to grayscale
grayImg = rgb2gray(img);
% Apply histogram equalization for enhancement
enhancedImg = histeq(grayImg);
% Apply Gaussian blur for noise reduction
output = imgaussfilt(enhancedImg, 2);
end

function detectedObjects = detectObjects(img)
% Image Segmentation/Detection
% Here, we use simple thresholding for demonstration; adapt as needed
thresholdValue = 0.5; % Adjust based on your needs
binaryImage = imbinarize(img, thresholdValue);
% Perform morphological operations to remove noise
cleanedImg = bwareaopen(binaryImage, 50); % Removes small objects
% Detect connected components
cc = bwconncomp(cleanedImg);
detectedObjects = regionprops(cc, 'BoundingBox', 'Area');
end

function outputImg = extractAndDisplayFeatures(img, objects)
% Feature Analysis/Extraction and Highlighting
outputImg = insertObjectAnnotation(img, 'rectangle', ...
    cat(1, objects.BoundingBox), 'Object');
end
