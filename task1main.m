% Task 1: Image enhancement
% input: image_path, extension of images
% output:
% Gaussian_SNR_values: SNR values of three images by applying gaussian
% filter
% Median_SNR_values: SNR values of three images by applying median filter
% Anisotropic_SNR_values: SNR values of three images by applying
% anisptropic filter
% Bilateral_SNR_values: SNR values of three images by applying bilateral
% filter
% Combinations_SNR_values: SNR values of the third image by applying
% combination filter

rng('default');
% read all bmp images in a file
image_path = './task1_images/';
extension = '*.bmp';
dis = dir([image_path extension]);
names = {dis.name};

% apply Gaussian filter
[Gaussian_SNR_values] = applyGaussianFilter(image_path, names);

% apply Median filter
[Median_SNR_values] = applyMedianFilter(image_path, names);

% apply Anisotropic filter with the similarity function of S = (D-d)/D
[Anisotropic_SNR_values] = applyAnisotropicFilter(image_path, names);

% apply Bilateral filter
[Bilateral_SNR_values] = applyBilateralFilter(image_path, names);

% apply Combinations of image processing techniques to image3
Combinations_SNR_values = applyConbinations(image_path, names);
