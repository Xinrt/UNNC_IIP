% Task 2: Saliency detection

rng('default');

% read all images in a file
image_path = './task2_salient_detection_images/salient_detection/image/';
image_extension = '*.jpg';
image_dis = dir([image_path image_extension]);
image_names = {image_dis.name};

mask_path = './task2_salient_detection_images/salient_detection/mask/';
mask_extension = '*.png'; 
mask_dis = dir([mask_path mask_extension]);
mask_names = {mask_dis.name};

% create a new folder to store all detected saliencies
if ~exist('./detected saliencies','dir')
	mkdir('./','detected saliencies');
end

[~,total_images]=size(image_names);
for image_number=1:total_images
    iou(image_number)=saliencyDetection(image_path, image_names,mask_path,mask_names,image_number);
end
iou_average=sum(iou)/image_number;



