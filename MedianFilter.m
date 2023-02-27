% This function realize median filter on an image
% input:
% input_image: an image
% n: n-n neighborhood around the corresponding pixel in the input image
% output:
% filtered image, SNR value
function [best_image_filtered, best_SNR] = MedianFilter(input_image, n)
    img_rgb = imread('./task1_images/lena_gray.jpg');
    img_clean = uint8(img_rgb);
   
    % apply median filter
    image_filtered = medfilt2(input_image, [n n]);
    % calculate SNR
    SNR=snr(double(image_filtered),double(image_filtered)-double(img_clean));
    best_SNR=SNR;
    best_image_filtered=image_filtered;
end