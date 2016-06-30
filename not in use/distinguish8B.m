% close all;
clc;
figure(1);
for i=1:50
    Src=q(:,:,i);
% BlackPic=Grey2Black(Src,50);
    [rows, columns] = size(Src);      %来自二值化图像数据
    averageSrc = sum(Src)./rows;        %进行列相加
    subplot(5,10,2*i-1);vl_imarraysc(Src);colormap gray;
% figure(2);
    subplot(5,10,2*i);plot(averageSrc,'ro');           %列向的二值化统计数据
end
