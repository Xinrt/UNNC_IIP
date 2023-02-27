% This function realize combined filters on an image
% input:
% input_image: an image
% output:
% filtered image

function [image_filtered, best_SNR] = CombinedFilters(img)
% anisotropic + median filter
[image_filtered, ~] = AnisotropicFilter(img,7);
[image_filtered, best_SNR] = MedianFilter(image_filtered,5);
end