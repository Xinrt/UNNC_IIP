% This function realize anisotropic filter on an image
% input:
% input_image: an image
% r: amount of padding to add to each dimension
% sigma1: standard deviation of gaussian in space weight
% sigma2: standard deviation of gaussian in range weight
% output:
% filtered image, SNR value

function [best_image_filtered,best_SNR]= BilateralFilter(input_image,r,sigma1,sigma2)
    img_rgb = imread('./task1_images/lena_gray.jpg');
    img_clean = double(img_rgb);
    
    %% apply bilateral filter
    [x,y] = meshgrid(-r:r);
    w1 = exp(-(x.^2+y.^2)/(2*sigma1^2));
    input_image = im2single(input_image);

    [img_x,img_y] = size(input_image);
    temp_filter = padarray(input_image,[r r],'symmetric');
    image_filtered = zeros(img_x,img_y);
    for i = r+1:img_x+r
        for j = r+1:img_y+r
            temp = temp_filter(i-r:i+r,j-r:j+r);
            w2 = exp(-(temp-input_image(i-r,j-r)).^2/(2*sigma2^2));
            % calculate the normalize coefficient W
            w = w1.*w2;
            SR = temp.*w;
            image_filtered(i-r,j-r) = sum(SR(:))/sum(w(:));
        end
    end
    
    % change image values back 
    image_filtered = image_filtered.*255;
    % calculate SNR value
    SNR=snr(double(image_filtered),double(image_filtered)-double(img_clean));
    best_SNR = SNR;
    best_image_filtered=uint8(image_filtered);
end