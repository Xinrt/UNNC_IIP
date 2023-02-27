% This function realize anisotropic filter on an image
% input:
% input_image: an image
% niter: times of applying anisotropic filter 
% output:
% filtered image, SNR value

function [best_image_filtered, best_SNR] = AnisotropicFilter(input_image, niter)
    % apply one more circle of 0 around the input image, in order to make sure
    % all pixels in the image have been filtered by anistropic filter
    input_image = padarray(input_image, [1 1]);
    [nrows,ncols] = size(input_image);
    image_filtered = zeros(nrows, ncols);
    input_image = double(input_image);
    img_rgb = imread('./task1_images/lena_gray.jpg');
    img_clean = double(img_rgb);

    % calculate on 9 directions (including itself)
    for t = 1 : niter
        for i = 2 : nrows-1
            for j = 2 : ncols-1
                NI = abs(input_image(i-1, j) - input_image(i, j));
                SI = abs(input_image(i+1, j) - input_image(i, j));
                EI = abs(input_image(i, j-1) - input_image(i, j));
                WI = abs(input_image(i, j+1) - input_image(i, j));
                WNI = abs(input_image(i-1,j+1) - input_image(i, j));
                WSI = abs(input_image(i+1, j+1) - input_image(i, j));
                ENI = abs(input_image(i-1, j-1) - input_image(i, j));
                ESI = abs(input_image(i+1, j-1) - input_image(i, j));
                PI = abs(input_image(i, j) - input_image(i, j));

                % S = (D-d)/D
                diff = [NI,SI,EI,WI,WNI,WSI,ENI,ESI, PI];
                D = max(diff);
                % if D==0, assign 1 to all of them
                if D==0
                    cN = 1;
                    cS = 1;
                    cE = 1;
                    cW = 1;
                    cWN = 1;
                    cWS = 1;
                    cEN = 1;
                    cES = 1;
                    cP = 1;
                else
                    % normalize to range [0,1]
                    cN = (D-NI)/D;
                    cS = (D-SI)/D;
                    cE = (D-EI)/D;
                    cW = (D-WI)/D;
                    cWN = (D-WNI)/D;
                    cWS = (D-WSI)/D;
                    cEN = (D-ENI)/D;
                    cES = (D-ESI)/D;
                    cP = (D-PI)/D;
                end
                image_filtered(i,j)=(input_image(i-1, j)*cN+input_image(i+1, j)*cS+input_image(i, j-1)*cE+input_image(i, j+1)*cW+input_image(i-1,j+1)*cWN + input_image(i+1, j+1)*cWS+input_image(i-1, j-1)*cEN+input_image(i+1, j-1)*cES+input_image(i, j)*cP)/(cN+cS+cE+cW+cWN+cWS+cEN+cES+cP);
            end
        end

        % clean the outmost zeros
        input_image=input_image(2:nrows-1,2:ncols-1);
        image_filtered=image_filtered(2:nrows-1,2:ncols-1);

        %% calculate the SNR value
        SNR=snr(double(image_filtered),double(image_filtered)-double(img_clean));
        best_SNR = SNR;
        best_image_filtered=uint8(image_filtered);

        input_image = image_filtered;
        input_image = padarray(input_image, [1 1]);
    end
end