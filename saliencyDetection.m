% This function performs saliency detection of a image
% input:
% img_path: The file path where the image is stored
% mask_path: The file path where the mask image is stored
% image_names: all image names
% mask_names: all mask image names
% image_number: index of current image
% return:
% one iou value
function iou=saliencyDetection(image_path, image_names,mask_path,mask_names,image_number)
    img=imread([image_path image_names{image_number}]);
    img_mask_actual=imread([mask_path mask_names{image_number}]);

    %% Quantify the color of each channel to 12 different values by even distribution
    [img_x,img_y,~]=size(img);
    quan_imgRGB=colorQuantization(img);

    %% Find the colors cover over 95% total pixels
    quan_3dimentions = [reshape(quan_imgRGB(:,:,1),img_x*img_y,1)...
                        reshape(quan_imgRGB(:,:,2),img_x*img_y,1)...
                        reshape(quan_imgRGB(:,:,3),img_x*img_y,1)];

    [quan_imgRGB_count(:,1:3), ~, C2] = unique(quan_3dimentions,'rows');
    % C2 shows the occurance position of the element in the original matrix
    % quan_imgRGB_count(1,1:3)= the 1 in C2
    [n_total,~]=size(quan_imgRGB_count(:,1:3));
    for i=1:n_total
        quan_imgRGB_count(i,4)=length(find(C2==i));
    end
    % sort all colors by the number of occurance
    quan_imgRGB_countSorted = sortrows(quan_imgRGB_count,-4);

    pixels_total=img_x*img_y;
    pixels_count=0;
    n_perserved=0;
    
    % find the colors cover over 95% pixels, 
    % also count the preserved numbers
    for i=1:n_total
        if pixels_count<=0.95*pixels_total
            pixels_count=pixels_count+quan_imgRGB_countSorted(i,4);
            preserved_color(i,1:3)=quan_imgRGB_countSorted(i,1:3);
            n_perserved=n_perserved+1;
        end
    end


    %% calcualte the color distance
    % quan_imgRGB_countSorted(i,1:3): color value
    % quan_imgRGB_countSorted(i,4)：number of occurance of current color
    % quan_imgRGB_countSorted(i,7:9)：the nearest color value of current color

    % define color distance calculation function in LAB color space
    temp=quan_imgRGB_countSorted(:,1:3);
    unique_colors=reshape(temp, [n_total, 1, 3]);
    value_labTemp=rgb2lab(unique_colors);
    value_lab = [reshape(value_labTemp(:,:,1),n_total*1,1)...
                        reshape(value_labTemp(:,:,2),n_total*1,1)...
                        reshape(value_labTemp(:,:,3),n_total*1,1)];

    cal_L = value_lab(:,1);
    cal_A = value_lab(:,2);
    cal_B = value_lab(:,3);

    D=@(l,j) sqrt((cal_L(l)-cal_L(j))^2+(cal_A(l)-cal_A(j))^2+(cal_B(l)-cal_B(j))^2);

    %% Find the nearest color of each preserved color
    img_all_distances=zeros(n_total,n_total);
    for i=n_perserved+1:n_total
        for j=1:n_perserved
            img_all_distances(i,j)=D(i,j);
        end
    end
    img_all_distances(img_all_distances==0)=inf;   % avoid fiding the 0
    for i=n_perserved+1:n_total  
        [~,d_index]=min(img_all_distances(i,:));   % find the min color value and corresponding index
        quan_imgRGB_countSorted(i,7:9)=quan_imgRGB_countSorted(d_index,1:3);      % find the nearest color by index
    end

    %% color replacement
    [n_3dimentionsTotal,~]=size(quan_3dimentions);
    % scan whole image
    for i=1:n_3dimentionsTotal
        if ismember(quan_3dimentions(i,:), preserved_color, 'rows')==0    % if the current color belongs to rest 5%
           [ ~,color_indx]=ismember(quan_3dimentions(i,:), quan_imgRGB_countSorted(:,1:3), 'rows');     % find the index of current color
            quan_3dimentions(i,:)=quan_imgRGB_countSorted(color_indx,7:9);     % replaced by the nearest color
        end
    end

    % change back to 3 dimentional image
    quan_imgRGB2=reshape(quan_3dimentions, [img_x, img_y, 3]);
    
    % update storing matrix
    for i=n_perserved+1:n_total   
        quan_imgRGB_countSorted(i,1:3)=quan_imgRGB_countSorted(i,7:9);      
    end
    
    % create a new matrix to store 95% colors and the number of occurance
    quan_imgRGB_count95=quan_imgRGB_countSorted(:,1:4);
    for i=1:n_perserved
        for j=n_perserved+1:n_total
            if quan_imgRGB_count95(j,1:3)==quan_imgRGB_count95(i,1:3)
                quan_imgRGB_count95(i,4)=quan_imgRGB_count95(i,4)+quan_imgRGB_count95(j,4);
            end
        end
    end
    quan_imgRGB_count95=quan_imgRGB_count95(1:n_perserved,1:4);

    %% calculate the saliency value of each color
    % find the color occurrence probability
    for i=1:n_perserved
        quan_imgRGB_count95(i,5)= quan_imgRGB_count95(i,4)/pixels_total;
    end
    
    % quan_imgRGB_count95(i,1:3): color value
    % quan_imgRGB_count95(i,4)：number of occurance of current color
    % quan_imgRGB_count95(i,6)：saliency value before smoothing
    % quan_imgRGB_count95(i,7)：saliency value after smoothing
    
    % calculate the saliency value and stored them
    for i=1:n_perserved
        quan_imgRGB_count95(i,6)=0;
        for j=1:n_perserved
            quan_imgRGB_count95(i,6)= quan_imgRGB_count95(i,6)+quan_imgRGB_count95(j,5)*D(i,j);
        end
    end


    %% smoothing in color space
    quan_imgRGB3=quan_imgRGB2;
    quan_imgRGB_countSortedmNear(:,1:3)=quan_imgRGB_count95(:,1:3);
    m_smooth=floor(n_perserved/4);
    
    img_all_distancesNew=zeros(n_perserved,n_perserved);
    for i=1:n_perserved
        for j=1:n_perserved
            if i==j
                img_all_distancesNew(i,j)=inf;
            else
                img_all_distancesNew(i,j)=D(i,j);
            end
        end
    end
    img_all_distancesNewCopy=img_all_distancesNew;

    % T: total distance between color c and its m nearest colors 
    T=zeros(n_perserved,1);
    for i=1:n_perserved
        T(i)=0;
        for m=1:m_smooth
            [min_value,d_index]=min(img_all_distancesNewCopy(i,:));   % find the min distance and corresponding index
            T(i)=T(i)+min_value;
            img_all_distancesNewCopy(i,d_index)=inf;                  % in order to find the last min distances, set the min distances already found to infinity
        end
    end

    % calculate the sum values of function
    for i=1:n_perserved
        quan_imgRGB_countSortedmNear(i,4)=0;
        for m=1:m_smooth
            [min_value,d_index]=min(img_all_distancesNew(i,:));   % find the min distance and corresponding index
            quan_imgRGB_countSortedmNear(i,4)=quan_imgRGB_countSortedmNear(i,4)+((T(i)-min_value)*quan_imgRGB_count95(d_index,6));
            img_all_distancesNew(i,d_index)=inf;                                     % in order to find the last min distances, set the min distances already found to infinity
        end
    end
    
    % get the new saliency value
    for i=1:n_perserved
        quan_imgRGB_count95(i,7)=quan_imgRGB_countSortedmNear(i,4)/((m_smooth-1)*T(i));
    end


    %% assign saliency value to each color in whole image
    quan_imgRGB4=quan_imgRGB3;     
    img_gray=rgb2gray(quan_imgRGB4); 
    quan_3dimentions_gray = reshape(img_gray(:,:),img_x*img_y,1);

    for i=1:n_3dimentionsTotal
        [ ~,color_indx]=ismember(quan_3dimentions(i,:), quan_imgRGB_count95(:,1:3), 'rows');     %找到该颜色
        color_s=quan_imgRGB_count95(color_indx,7);
        quan_3dimentions_gray(i,:)=color_s;
    end

    img_gray_saliency=reshape(quan_3dimentions_gray, [img_x, img_y, 1]);
    
    %%  threshold setting
    T_max=max(max(img_gray_saliency));
    img_gray = uint8(img_gray_saliency>0.7*T_max);   % initially assign

    if sum(img_gray(:)) > 0.8*img_x*img_y  % if the detected image has too many white
        img_gray = uint8(img_gray_saliency>0.9*T_max);    % increase threshold to add black
    elseif sum(img_gray(:)) < 0.3*img_x*img_y      % if the detected image has too many black
        img_gray = uint8(img_gray_saliency>0.4*T_max);  % decrease threshold to add white
    end
    
    % avoid the problems may caused by the first dynamic threshold assign
    if sum(img_gray(:)) < 0.1*img_x*img_y
        img_gray = uint8(img_gray_saliency>0.8*T_max);  
    elseif sum(img_gray(:)) > 0.95*img_x*img_y              
        img_gray = uint8(img_gray_saliency>0.65*T_max);
    end
    
    %% store images
    imwrite(double(img_gray),['./detected saliencies/' image_names{image_number} '.png'])

    %% IOU
    img_mask=double(img_gray);
    img_mask_actual=double(img_mask_actual);

    intersection = img_mask & img_mask_actual;
    union = img_mask | img_mask_actual;
    iou = sum(sum(intersection)) / sum(sum(union));
end