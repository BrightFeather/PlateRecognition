function [ Set, num ] = TraditionalSegmentation( Src, AimSize, level)
%   Src is a grey pic
%   level is the adjust value for Grey2Black
close all;
clc;
Src=CutEdge(Src);
BlackPic=Grey2Black(Src,level);
[rows, columns] = size(Src);      %来自二值化图像数据
averageSrc = sum(BlackPic)./rows;        %进行列相加
figure(1);
plot(averageSrc);           %列向的二值化统计数据
set(gca,'fontsize',13);
limit=20;
LeftEdge=find(averageSrc>=limit);
RightEdge=zeros(1,length(LeftEdge));
for i=2:length(LeftEdge)
    if LeftEdge(i)-LeftEdge(i-1) == 1
        LeftEdge(i-1)=0;
    else
        RightEdge(i)=LeftEdge(i);
    end
end
myd = LeftEdge~=0; %找到跳变的前边缘
MYE = LeftEdge(myd);     %对应列号
myh = RightEdge~=0; %找到跳变的后边缘
myi = RightEdge(myh);
MYB = [1 myi];
num=1;
MaxNum=7;
Set=zeros(AimSize,AimSize,MaxNum);
for i = 1:length(MYE)
    if MYE(i)-MYB(i)<columns/12
        continue;
    end
    figure(num+1);
    Set(:,:,num)=ReSizePic(Grey2Black(Src(:,MYB(i):MYE(i)),level),AimSize,level);
    imshow(uint8(Set(:,:,num)));
    num=num+1;
end
end