% This function performs different gaussain filters on different images
% using different optimal parameters
% input:
% img_path: The file path where the image is stored
% names: all image names
% output:
% show images
% return:
% SNR values

function [SNR_values] = applyGaussianFilter(image_path, names)
% image1
image1=imread([image_path names{1}]);
[img1_filtered, SNR_img1] = GaussianFilter(image1,9, 1.2);
% image2
image2=imread([image_path names{2}]);
[img2_filtered, SNR_img2] = GaussianFilter(image2,7, 1.1);
% image3
image3=imread([image_path names{3}]);
[img3_filtered, SNR_img3] = GaussianFilter(image3,9, 1.45);

SNR_values = [1 2 3; SNR_img1 SNR_img2 SNR_img3];

% show images
figure;
subplot(2,3,1);imshow(image1);title("image1");
subplot(2,3,2);imshow(image2);title("image2");
subplot(2,3,3);imshow(image3);title("image3");
subplot(2,3,4);imshow(img1_filtered);title("image1 gaussian filter");
subplot(2,3,5);imshow(img2_filtered);title("image2 gaussian filter");
subplot(2,3,6);imshow(img3_filtered);title("image3 gaussian filter");
end
