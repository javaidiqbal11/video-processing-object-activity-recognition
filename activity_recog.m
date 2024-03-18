% Define video file path
videoFilePath = '1.mp4';

% Create a video reader object
v = VideoReader(videoFilePath);

% Read and convert video frames to grayscale
frames = zeros(v.Height, v.Width, v.NumFrames, 'uint8'); % Preallocating for grayscale frames
idx = 1;
while hasFrame(v)
    currentFrame = readFrame(v);
    frames(:, :, idx) = rgb2gray(currentFrame);
    idx = idx + 1;
end

% Assuming the first frame is the background for simplicity
background = frames(:, :, 1);
foregroundFrames = zeros(size(frames), 'logical');

% Background subtraction to identify moving objects
threshold = 25;
for i = 1:size(frames, 3)
    diffFrame = abs(double(frames(:, :, i)) - double(background));
    foregroundFrames(:, :, i) = diffFrame > threshold;
end

% Calculate motion vectors (simplified as differences in object positions)
motionVectors = zeros(size(frames, 3)-1, 2); % 2D motion (x, y)
for i = 1:size(foregroundFrames, 3)-1
    [y1, x1] = find(foregroundFrames(:, :, i), 1, 'first');
    [y2, x2] = find(foregroundFrames(:, :, i+1), 1, 'first');
    if ~isempty([x1, y1]) && ~isempty([x2, y2])
        motionVectors(i, :) = [x2 - x1, y2 - y1];
    else
        motionVectors(i, :) = [0, 0];
    end
end

% For this example, motion recognition is simplified to detecting significant movements
significantMotionIndices = find(sqrt(sum(motionVectors.^2, 2)) > 10); % Threshold for "significant" motion

% Display results (This part is very basic and intended for demonstration only)
disp('Frames with significant motion:');
disp(significantMotionIndices);
