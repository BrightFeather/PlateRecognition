function [ GrayDes, BwDes] = EnhancedSegmentation( Im, AimHeight, AimWidth )
%Im is a GrayPic, AimHeight&AimWidth are the desired size of output
%character
GrayPic=Im;
BwPic=im2bw(Im,graythresh(Im));
[Height,Width]=size(BwPic);
[Label,LabelNum]=bwlabel(BwPic,8);
%First cut the edge of the picture
for i=1:LabelNum
    [rows,columns]=find(Label==i);
    left=min(columns);right=max(columns);
    if ((right-left+1)>Width/7)%If some areas are especially long, we may consider it an edge
        j=length(rows);
        for k=1:j
            BwPic(rows(j),columns(j))=0;
            GrayPic(rows(j),columns(j))=0;
        end
    end
end
%Eliminate tiny areas in the picture
ChineseEnd=round(Width/7);
Temp=BwPic(:,1:ChineseEnd);
BwPic=bwareaopen(BwPic,round(Height*Width/200));
BwPic(:,1:ChineseEnd)=Temp;
BwPic=bwareaopen(BwPic,round(Height*Width/250));
%Segmentation based on vertical projection
VerticalSum=sum(BwPic);limit=Height/4;
LeftEdge=find(VerticalSum>=limit);
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
CharacterNum=7;num=0;
left=zeros(1,CharacterNum);right=left;peak=left;
limit=Height/5;
for i = 1:length(MYE)
    thispeak=max(VerticalSum(MYB(i):MYE(i)));
    if (thispeak<limit||(((MYE(i)-MYB(i)<Width/12)&&(MYE(i)>Width*13/14||MYB(i)<Width/14))))
        continue;
    end
    if (num==CharacterNum)
        if ((MYE(i)-left(num)<Width/7))
            right(num)=MYE(i);
            continue;
        end
        [minpeak,minNode]=min(peak);
        if (thispeak<=minpeak)
            continue;
        end
        for j=minNode:CharacterNum-1
            peak(j)=peak(i+1);left(j)=left(j+1);right(j)=right(j+1);
        end
        peak(CharacterNum)=thispeak;left(CharacterNum)=MYB(i);right(CharacterNum)=MYE(i);
        continue;
    end
    num=num+1;
    if (num>1&&(MYE(i)-left(num-1)<Width/7))
        num=num-1;
        right(num)=MYE(i);
    else
        peak(num)=thispeak;left(num)=MYB(i);right(num)=MYE(i);
    end
end
%Final Segmentation based on area detection
GrayDes=zeros(AimHeight,AimWidth,CharacterNum);BwDes=GrayDes;
for i=2:CharacterNum
    if (left(i))==0
        continue;
    end
    TempBw=BwPic(:,left(i):right(i));TempGray=GrayPic(:,left(i):right(i));
    TempBw=bwareaopen(TempBw,round(Height*(right(i)-left(i))/50));
%     [TempLabel,TempLabelNum]=bwlabel(TempBw,8);
%     ind=1;
%     if (TempLabelNum~=1)
%         x=zeros(1,TempLabelNum);
%         for j=1:TempLabelNum
%             x(j)=sum(sum(TempLabel==j));
%         end
%         [~,ind]=max(x);[r,c]=size(TempBw);
%         for k=1:r
%             for l=1:c
%                 if (TempLabel(k,l)~=ind)
%                     TempBw(k,l)=0;
%                 end
%             end
%         end
%     end
    [rows,columns]=find(TempBw~=0);
    top=min(rows);bottom=max(rows);left1=min(columns);right1=max(columns);
    if ((right1-left1+1)*AimHeight>AimWidth*(bottom-top+1))
        BwDes(:,:,i)=logical(imresize(TempBw(top:bottom,left1:right1),[AimHeight,AimWidth]));
        GrayDes(:,:,i)=uint8(imresize(TempGray(top:bottom,left1:right1),[AimHeight,AimWidth]));
    else
        B=logical(imresize(TempBw(top:bottom,left1:right1),[AimHeight,NaN]));[~,c]=size(B);start=floor((AimWidth-c)/2)+1;
        BwDes(:,start:start+c-1,i)=B;
        G=uint8(imresize(TempGray(top:bottom,left1:right1),[AimHeight,NaN]));
        G = double(G - min(min(G)));
        G = G.*255/max(max(G));
        G(G<100)=0;
        GrayDes(:,start:start+c-1,i)=G;
    end
end
if (left(1)~=0)
    TempBw=BwPic(:,left(1):right(1));TempGray=GrayPic(:,left(1):right(1));
    [rows,columns]=find(TempBw~=0);
    top=min(rows);bottom=max(rows);left1=min(columns);right1=max(columns);
    if ((right1-left1+1)*AimHeight>AimWidth*(bottom-top+1))
        BwDes(:,:,1)=logical(imresize(TempBw(top:bottom,left1:right1),[AimHeight,AimWidth]));
        GrayDes(:,:,1)=uint8(imresize(TempGray(top:bottom,left1:right1),[AimHeight,AimWidth]));
    else
        B=imresize(TempBw(top:bottom,left1:right1),[AimHeight,NaN]);[~,c]=size(B);start=floor((AimWidth-c)/2)+1;
        BwDes(:,start:start+c-1,1)=logical(B);
        G=imresize(TempGray(top:bottom,left1:right1),[AimHeight,NaN]);
        G = double(G - min(min(G)));
        G = G.*255/max(max(G));
        G(G<100)=0;
        GrayDes(:,start:start+c-1,1)=uint8(G);
    end
end
BwDes=logical(BwDes);GrayDes=uint8(GrayDes);
end