function [ GrayDes, BwDes] = UltimateSegmentation( Im, AimHeight, AimWidth )
%Im is a GrayPic, AimHeight&AimWidth are the desired size of output
%character, the output characters have two rows of 0 above and below them
GrayPic=Im;
BwPic=im2bw(Im,graythresh(Im));
CharacterNum=7;
%BwPic=CutLicenseEdge(BwPic,CharacterNum);%This Code may not suit some situation
[Height,Width]=size(BwPic);
CutWidth=round(Width/5);
HardSeg=zeros(Height,CutWidth,CharacterNum);
CutStart=[1,round(31*Width/306),round(5*Width/17),round(22*Width/51),round(175*Width/306),round(109*Width/153),Width-CutWidth+1];
Top=zeros(1,CharacterNum);Bottom=Top;
% Cut the left and right edges first
SumRow=sum(BwPic);
TempCol=1;
while(SumRow(TempCol)>Height/20)
    TempCol=TempCol+1;
end
if (TempCol~=1&&TempCol<5*Width/306)
    BwPic(:,1:TempCol)=zeros(Height,TempCol);
end
TempCol=Width;
while(SumRow(TempCol)>Height/20)
    TempCol=TempCol-1;
end
if (TempCol~=Width&&TempCol>301*Width/306)
    BwPic(:,1:TempCol)=zeros(Height,TempCol);
end
% Roughly Cut the License into seven parts: Note that the plate must be
% extremely well-captured ahead for this algrithm to run smoothly!!!
for i=1:CharacterNum
    HardSeg(:,:,i)=BwPic(:,CutStart(i):CutStart(i)+CutWidth-1);
    % Cut the top and bottom edge off each character
    ColumnSum=sum((HardSeg(:,:,i))');
    ThisTop=1;ThisBottom=Height;
    while(ColumnSum(ThisTop==0))
        ThisTop=ThisTop+1;
    end
    while(ColumnSum(ThisBottom==0))
        ThisBottom=ThisBottom-1;
    end
    if (ThisTop==1)
        for k=round(Height/20):1
            if (ColumnSum(k)==0)
                ThisTop=k;
                break;
            end
        end
    end
    if (ThisBottom==Height)
        for l=round(19*Height/20):Height
            if (ColumnSum(l)==0)
                ThisBottom=l;
                break;
            end
        end
    end
    if (ThisTop~=1)
        HardSeg(1:ThisTop-1,:,i)=zeros(ThisTop,CutWidth);
    end
    if (ThisBottom~=Height)
        HardSeg(ThisBottom+1:Height,:,i)=zeros(Height-ThisBottom,CutWidth);
    end
    Top(i)=ThisTop;Bottom(i)=ThisBottom;
    HardSeg(:,:,i)=bwareaopen(HardSeg(:,:,i),round(Height*CutWidth/50));
end
% Segmentation using vertical projection
GrayDes=zeros(AimHeight,AimWidth,CharacterNum);BwDes=GrayDes;
% Chinese character needs special treatment
left=1;SumRow=sum(HardSeg(:,:,1));
while (SumRow(left)<Height/20&&left<CutWidth)
    left=left+1;
end
right=left;
while ((right<=size(SumRow,2) && SumRow(right)>Height/20) ||(right-left)<Width/10)
    right=right+1;
end
B=imresize(HardSeg(Top(1):Bottom(1),left:right,1),[AimHeight-4,NaN]);[~,c]=size(B);start=floor((AimWidth-c)/2)+1;
BwDes(3:AimHeight-2,start:start+c-1,1)=logical(B);
G=imresize(GrayPic(Top(1):Bottom(1),left:right),[AimHeight-4,NaN]);
GrayDes(3:AimHeight-2,start:start+c-1,1)=uint8(G);
% Assume that letters and numbers are not broken. Note that this is a
% must!!!
for i=2:CharacterNum
    SumRow=sum(HardSeg(:,:,i));
    lBound=round(CutWidth/4);rBound=round(CutWidth-CutWidth/4);
    [~,note]=max(SumRow(lBound:rBound));
    left=lBound+note-1;right=left;
    flagl=1;flagr=1;
%     while (SumRow(left)>Height/15&&left>1)
%         left=left-1;
%     end
%     while (SumRow(right)>Height/15&&(right-left)<Width*22/153&&right<CutWidth)
%         right=right+1;
%     end
    while ((flagl||flagr)&&(right-left)<Width*22/153)
        if (SumRow(left)>Height/15&&left>1)
            left=left-1;
        else
            flagl=0;
        end
        if (SumRow(right)>Height/15&&right<CutWidth)
            right=right+1;
        else
            flagr=0;
        end
    end
    B=imresize(HardSeg(Top(i):Bottom(i),left:right,i),[AimHeight-4,NaN]);[~,c]=size(B);start=floor((AimWidth-c)/2)+1;
    BwDes(3:AimHeight-2,start:start+c-1,i)=logical(B);
    G=imresize(GrayPic(Top(i):Bottom(i),CutStart(i)+left-1:CutStart(i)+right-1),[AimHeight-4,NaN]);
    GrayDes(3:AimHeight-2,start:start+c-1,i)=uint8(G);
end
BwDes=logical(BwDes);
GrayDes=uint8(GrayDes);

% for i=1:7
%     GrayDes(:,:,i)=Grey2Black(GrayDes(:,:,i),15);
% end
end