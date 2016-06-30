function [Des]=ReSizePic2(Src,AimHeight)
AimWidth=floor(AimHeight/2);
[k,l]=size(Src);
if l>k/2
    Des=imresize(Src,[AimHeight,AimWidth]);
else
    MidPic=imresize(Src,[AimHeight,NaN]);
    [m,n]=size(MidPic);
    start=floor((AimWidth-n)/2);
    Des=zeros(AimHeight,AimWidth);
    for i=1:m
        for j=1:n
            Des(i,start+j)=MidPic(i,j);
        end
    end
end