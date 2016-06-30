function [ Des ] = BetterSegmentation( Im, CharacterNum, AimHeight, AimWidth)
%Im can be a rgb picture
BwPic=im2bw(Im,graythresh(Im));
GrayPic=rgb2gray(Im);
BwPic=CutLicenseEdge(BwPic,CharacterNum);
[Height,Width]=size(BwPic);
[Label,LabelNum]=bwlabel(BwPic,8);
top=zeros(1,CharacterNum);bottom=zeros(1,CharacterNum);
left=zeros(1,CharacterNum);right=zeros(1,CharacterNum);
top(1)=Height;bottom(1)=1;left(1)=Width;right(1)=1;
for i=1:CharacterNum-1
    [rows,columns]=find(Label==LabelNum-i+1);
    top(CharacterNum-i+1)=min(rows);bottom(CharacterNum-i+1)=max(rows);
    left(CharacterNum-i+1)=min(columns);right(CharacterNum-i+1)=max(columns);
end
for i=CharacterNum:LabelNum
    [rows,columns]=find(Label==LabelNum-i+1);
    top(1)=min(top(1),min(rows));bottom(1)=max(bottom(1),max(rows));
    left(1)=min(left(1),min(columns));right(1)=max(right(1),max(columns));
end
Des=zeros(AimHeight,AimWidth,CharacterNum);
for i=1:CharacterNum
    if bottom(i)-top(i)>3*(right(i)-left(i))
        tmp=imresize(GrayPic(top(i):bottom(i),left(i):right(i)),[AimHeight,NaN]);
        [~,c]=size(tmp);start=round((AimWidth-c))/2;Des(:,start:start+c-1,i)=tmp;
        continue;
    end
    Des(:,:,i)=imresize(GrayPic(top(i):bottom(i),left(i):right(i)),[AimHeight,AimWidth]);
end
Des=uint8(Des);
end