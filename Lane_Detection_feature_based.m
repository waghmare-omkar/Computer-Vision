%% Detect Lanes in an image
close all
% Image Processing using feature based extraction technique
% Use of ROI Masking
% Use of Canny Edge Detector
% Use of gaussian filter to smoothen the image
% Use image dilation for enhancement
% Use of hough transform

%% Read Image and save as a frame
Fr = imread('lane_2.jpeg'); 
figure(1); imshow(Fr);
title('Original Image')

%% Convert RGB image to grayscale
Fr_BW = rgb2gray(Fr);
%figure(2); imshow(Fr_BW);

%% Apply Gaussian Filter for image smoothing
h = ones(10,10)/100;
Fr_Blur = imfilter(Fr_BW,h);
%figure(3); imshow(Fr_Blur);


%% Detect Edges using matlab edge canny function
Fr_edge = edge(Fr_Blur,'Canny');
%figure(4); imshow(Fr_edge)


%% Create a mask
% Left Mask
xl = [0.05*length(Fr_BW(1,:)) 0.05*length(Fr_BW(1,:)) 0.5*length(Fr_BW(1,:)) 0.5*length(Fr_BW(1,:))   0.4*length(Fr_BW(1,:))  0.05*length(Fr_BW(1,:))];
yl = [0.9*length(Fr_BW(:,1)) 0.98*length(Fr_BW(:,1)) 0.98*length(Fr_BW(:,1)) 0.6*length(Fr_BW(:,1))   0.6*length(Fr_BW(:,1))  0.9*length(Fr_BW(:,1))];
mask_left = poly2mask(xl,yl,length(Fr_BW(:,1)),length(Fr_BW(1,:))); 

% Right Mask
xr = [0.5*length(Fr_BW(1,:)) 0.5*length(Fr_BW(1,:))   0.6*length(Fr_BW(1,:))  0.98*length(Fr_BW(1,:)) 0.98*length(Fr_BW(1,:))];
yr = [0.98*length(Fr_BW(:,1)) 0.6*length(Fr_BW(:,1))   0.6*length(Fr_BW(:,1))  0.9*length(Fr_BW(:,1)) 0.98*length(Fr_BW(:,1))];
mask_right = poly2mask(xr,yr,length(Fr_BW(:,1)),length(Fr_BW(1,:)));

%% New Masked Image
% Left New
Fr_edge_new_left = Fr_edge.*mask_left;
% Right New
Fr_edge_new_right = Fr_edge.*mask_right;
%figure(5); imshow(Fr_edge_new)

%% Further tuning edge detection
% Left Dilate
Fr_dilate_left = imdilate(Fr_edge_new_left,strel('disk',4));
% Right Dilate
Fr_dilate_right = imdilate(Fr_edge_new_right,strel('disk',4));
%figure(6); imshow(Fr_dilate)

%% Hough Space Function
% Left Hough
[Hl,Tl,Rl]= hough(Fr_dilate_left);
% Right Hough
[Hr,Tr,Rr]= hough(Fr_dilate_right);


%% Identify Peaks in Hough Space
% Left Peaks
Pl = houghpeaks(Hl,1);
% Right Peaks
Pr = houghpeaks(Hr,1);

%% Identify Lines
% Left Lines
lines_left = houghlines(Fr_dilate_left,Tl,Rl,Pl,'FillGap',10,'MinLength',25);
% Right Lines
lines_right = houghlines(Fr_dilate_right,Tr,Rr,Pr,'FillGap',10,'MinLength',25);

%% Plot Identified Lines
% Need two diffferent for loops as numbers of lines extracted would be
% different

figure(7); imshow(Fr), hold on
title('Processed Image')
for k = 1:length(lines_left)
% Plot Left Lines
xy_left = [lines_left(k).point1 ; lines_left(k).point2]; 
plot(xy_left(:,1),xy_left(:,2),'LineWidth',4,'Color','red'); hold on
end

for k = 1:length(lines_right)
% Plot Right Lines
xy_right = [lines_right(k).point1 ; lines_right(k).point2]; 
plot(xy_right(:,1),xy_right(:,2),'LineWidth',4,'Color','red');
end
   