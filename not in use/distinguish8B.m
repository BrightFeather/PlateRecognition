% close all;
clc;
figure(1);
for i=1:50
    Src=q(:,:,i);
% BlackPic=Grey2Black(Src,50);
    [rows, columns] = size(Src);      %���Զ�ֵ��ͼ������
    averageSrc = sum(Src)./rows;        %���������
    subplot(5,10,2*i-1);vl_imarraysc(Src);colormap gray;
% figure(2);
    subplot(5,10,2*i);plot(averageSrc,'ro');           %����Ķ�ֵ��ͳ������
end
