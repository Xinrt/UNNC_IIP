% This function realize gaussain filter on an image
% input:
% input_image: an image 
% hsize: filter size
% sigma: standard deviation of gaussian
% output:
% SNR value, filtered image
function [best_image_filtered,best_SNR] = GaussianFilter(input_image, hsize, sigma)
    img_rgb = imread('./task1_images/lena_gray.jpg');
    img_clean = double(img_rgb);
    
    % generate gaussian filter
    gaussian_filter = fspecial("gaussian", hsize, sigma);
    % apply gaussian filter
    image_filtered = conv2(input_image, gaussian_filter, 'same');
    
    % calculate corresponding SNR value
    SNR=snr(double(image_filtered),double(image_filtered)-double(img_clean));
    best_SNR = SNR;
    best_image_filtered = uint8(image_filtered);
end