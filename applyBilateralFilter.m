% This function performs different bilateral filters on different images
% using different parameters
% input:
% img_path: The file path where the image is stored
% names: all image names
% output:
% show images
% return:
% SNR values

function [SNR_values] = applyBilateralFilter(image_path, names)
    % input: (in order) r, sigma1, sigma2
    % image1
    image1=imread([image_path names{1}]);
    [img1_filtered, SNR_img1] = BilateralFilter(image1,5,4,1);
    % image2
    image2=imread([image_path names{2}]);
    [img2_filtered,SNR_img2] = BilateralFilter(image2,5,1,1);
    % image3
    image3=imread([image_path names{3}]);
    [img3_filtered,SNR_img3] = BilateralFilter(image3,3,2,1);
    
    SNR_values = [1 2 3; SNR_img1 SNR_img2 SNR_img3];

    % show images
    figure;
    subplot(2,3,1);imshow(image1);title("image1");
    subplot(2,3,2);imshow(image2);title("image2");
    subplot(2,3,3);imshow(image3);title("image3");
    subplot(2,3,4);imshow(img1_filtered);title("image1 bilateral filter");
    subplot(2,3,5);imshow(img2_filtered);title("image2 bilateral filter");
    subplot(2,3,6);imshow(img3_filtered);title("image3 bilateral filter");
end