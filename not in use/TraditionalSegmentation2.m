function [ Set1, num ] = TraditionalSegmentation2( Src, level)
%   Src is a grey pic
%   level is the adjust value for Grey2Black
Src=CutEdge(Src);
BlackPic=Grey2Black(Src,level);
[rows, columns] = size(Src);      %���Զ�ֵ��ͼ������
averageSrc = sum(BlackPic)./rows;        %���������
% figure;
% plot(averageSrc);           %����Ķ�ֵ��ͳ������
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
myd = LeftEdge~=0; %�ҵ������ǰ��Ե
MYE = LeftEdge(myd);     %��Ӧ�к�
myh = RightEdge~=0; %�ҵ�����ĺ��Ե
myi = RightEdge(myh);
MYB = [1 myi];
num=1;
MaxNum=7;
Set1=zeros(32,16,MaxNum);
%Set2=zeros(32,16,MaxNum);
for i = 1:length(MYE)
    if max(averageSrc(MYB(i):MYE(i)))<50
    %if MYE(i)-MYB(i)<columns/12
        continue;
    end
    %figure(num+1);
    Set1(:,:,num)=Grey2Black(ReSizePic2(Src(:,MYB(i):MYE(i)),32),level);
    %Set1(:,:,num)=ReSizePic(Grey2Black(Src(:,MYB(i):MYE(i)),level),AimSize);
    %imshow(uint8(Set1(:,:,num)));
    %imshow(uint8(Set1(:,:,num)));
    num=num+1;
end
end