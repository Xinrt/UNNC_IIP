% This function performs color quantization
% input:
% input_image: the input image
% return:
% quantified image
function quan_img = colorQuantization(input_image)
    [img_x,img_y,~]=size(input_image);
    quan_imgRGB=zeros(img_x, img_y,3);
    % quantified image into 12*12*12
    for i=1:img_x
        for j=1:img_y
            quan_imgRGB(i,j,1)=floor(double(input_image(i,j,1))/12)*12;
            quan_imgRGB(i,j,2)=floor(double(input_image(i,j,2))/12)*12;
            quan_imgRGB(i,j,3)=floor(double(input_image(i,j,3))/12)*12;
        end
    end
    quan_img=quan_imgRGB;
end
