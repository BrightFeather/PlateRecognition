function [Des]=ReSizePic(Src,AimHeight,level)
Des=zeros(AimHeight,AimHeight);
MidPic=imresize(Src,[AimHeight-4,NaN]);
MidPic=Grey2Black(MidPic,level);
[m,n]=size(MidPic);
start=floor((AimHeight-n)/2);
for i=1:m
    for j=1:n
        Des(i+2,start+j)=MidPic(i,j);
    end
end