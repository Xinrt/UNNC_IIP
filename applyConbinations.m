% This function performs combined filters on image 3
% input:
% img_path: The file path where the image is stored
% names: all image names
% output:
% show images
% return:
% SNR values

function SNR_values = applyConbinations(image_path, names)
    % image3
    image3=imread([image_path names{3}]);
    [img3_filtered, SNR_img3] = CombinedFilters(image3);
    SNR_values = [3; SNR_img3];

    figure; 
    subplot(1,2,1); imshow(image3); title("image3");
    subplot(1,2,2); imshow(img3_filtered); title("image3 using Combined techniques");
end
