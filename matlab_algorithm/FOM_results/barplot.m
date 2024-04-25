% Creats barplot of SSIM for each image.

% read excel file to extract data 
data = readtable("PSNR_barplot_data_for_average_K1_and_K2.xlsx");

% extract values of SSIM
psnr_val = data.PSNR;

% extract Image numbers 
image_numbers = (1:size(psnr_val));

% create bar plot
bar(image_numbers,psnr_val);

% display plot 
%figure
xlabel('Image\_Numbers');
ylabel('PSNR');
xticks(image_numbers);
title('Bar plot of PSNR value of each image for average value of K\_1 and K\_2');
grid on;

