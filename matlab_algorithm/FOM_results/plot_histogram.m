data = readtable("data_K1_SSIM.xlsx");
sorted_data = sortrows(data,"K1");


% plot scater graph of SSIM vs K1
figure;
scatter(data.K1, data.SSIM, 'filled', 'MarkerFaceColor', 'b');
xlabel('K1');
ylabel('SSIM');
title('Scatter Plot of SSIM vs. K2');

%plot Histogram 
figure;
histogram (sorted_data.SSIM,'BinWidth', 0.02, 'FaceColor', 'b', 'EdgeColor', 'k', 'Orientation', 'vertical');
xlabel('SSIM');
ylabel('Frequency');
title('Histogram of Higest SSIM values');

figure;
histogram (sorted_data.K1,'BinWidth', 0.005, 'FaceColor', 'b', 'EdgeColor', 'k', 'Orientation', 'vertical');
xlabel('K1');
ylabel('Frequency');
title('Histogram of K1 for Higest SSIM values');
