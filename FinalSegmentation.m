function [ GrayDes, BwDes] = FinalSegmentation( Im, AimHeight, AimWidth )
%Im is a GrayPic, AimHeight&AimWidth are the desired size of output
%character, the output characters have two rows of 0 above and below them
GrayPic=Im;
BwPic=im2bw(Im,graythresh(Im));
CharacterNum=7;
%BwPic=CutLicenseEdge(BwPic,CharacterNum);%This Code may not suit some situation
[Height,Width]=size(BwPic);
[Label,LabelNum]=bwlabel(BwPic,8);
%First cut the edge of the picture
for i=1:LabelNum
    [rows,columns]=find(Label==i);
    left=min(columns);right=max(columns);
    if ((right-left)>Width/7)%If some areas are especially long, we may consider it an edge
        j=length(rows);
        for k=1:j
            xcor=rows(k);ycor=columns(k);
            if (xcor<round(Height/6)||xcor>round(5*Height/6)||ycor<round(Width/20)||ycor>round(Width*19/20))
                BwPic(xcor,ycor)=0;
                GrayPic(xcor,ycor)=0;
            end
        end
    end
end
%Eliminate tiny areas in the picture
ChineseEnd=round(Width/7);
Temp=BwPic(:,1:ChineseEnd);
BwPic=bwareaopen(BwPic,round(Height*Width/200));
BwPic(:,1:ChineseEnd)=Temp;
BwPic=bwareaopen(BwPic,round(Height*Width/250));
%Roughly cut the Pic
CutWidth=round(Width*2/13);
HardSeg=zeros(Height,CutWidth,CharacterNum);
CutStart=[1,round(2*Width/15),round(91*Width/285),round(131*Width/285),round(167*Width/285),round(68*Width/95),Width-CutWidth+1];
Top=zeros(1,CharacterNum);Bottom=Top;
for i=1:CharacterNum
    HardSeg(:,:,i)=BwPic(:,CutStart(i):CutStart(i)+CutWidth-1);
    HardSeg(:,:,i)=bwareaopen(HardSeg(:,:,i),round(Height*CutWidth/50));
    % Cut the top and bottom edge off each character
    ColumnSum=sum((HardSeg(:,:,i))');
    ThisTop=1;ThisBottom=Height;
    while(ColumnSum(ThisTop)==0)
        ThisTop=ThisTop+1;
    end
    while(ColumnSum(ThisBottom)==0)
        ThisBottom=ThisBottom-1;
    end
    Top(i)=ThisTop;Bottom(i)=ThisBottom;
end
% Segmentation using vertical projection
GrayDes=zeros(AimHeight,AimWidth,CharacterNum);BwDes=GrayDes;
% Chinese character needs special treatment
left=floor(CutWidth/6)+1;SumRow=sum(HardSeg(:,:,1));
for i=(floor(CutWidth/6)+1):-1:1
    if SumRow(i)==0
        left=i;
        break;
    end
    if SumRow(i)<SumRow(left)
        left=i;
    end
end
right=floor(CutWidth*5/6);
for i=(floor(CutWidth*5/6)):CutWidth
    if SumRow(i)==0
        right=i;
        break;
    end
    if SumRow(i)<SumRow(right)
        right=i;
    end
end
if ((AimHeight-4)*(right-left+1)/(Bottom(1)-Top(1)+1)>AimWidth)
    B=imresize(HardSeg(Top(1):Bottom(1),left:right,1),[AimHeight-4,AimWidth]);
    BwDes(3:AimHeight-2,:,1)=logical(B);
    G=imresize(GrayPic(Top(1):Bottom(1),left:right),[AimHeight-4,AimWidth]);
    GrayDes(3:AimHeight-2,:,1)=uint8(G);
else
    B=imresize(HardSeg(Top(1):Bottom(1),left:right,1),[AimHeight-4,NaN]);[~,c]=size(B);start=round((AimWidth-c)/2)+1;
    BwDes(3:AimHeight-2,start:start+c-1,1)=logical(B);
    G=imresize(GrayPic(Top(1):Bottom(1),left:right),[AimHeight-4,NaN]);
    GrayDes(3:AimHeight-2,start:start+c-1,1)=uint8(G);
end
% Assume that letters and numbers are not broken. Note that this is a
% must!!!
for i=2:CharacterNum
    SumRow=sum(HardSeg(:,:,i));
    %lBound=round(CutWidth*2/5);rBound=round(CutWidth*3/5);
    % [~,note]=max(SumRow(lBound:rBound));
    left=floor(CutWidth/5)+1;right=floor(CutWidth*4/5);
    for j=floor(CutWidth/5)+1:-1:1
        if SumRow(j)==0
            left=j;
            break;
        end
        if SumRow(j)<SumRow(left)
            left=j;
        end
    end
    for j=floor(CutWidth*4/5):CutWidth
        if SumRow(j)==0
            right=j;
            break;
        end
        if SumRow(j)<SumRow(left)
            right=j;
        end
    end
    if ((AimHeight-4)*(right-left+1)/(Bottom(i)-Top(i)+1)>AimWidth)
        B=imresize(HardSeg(Top(i):Bottom(i),left:right,1),[AimHeight-4,AimWidth]);
        BwDes(3:AimHeight-2,:,i)=logical(B);
        G=imresize(GrayPic(Top(i):Bottom(i),CutStart(i)+left-1:CutStart(i)+right-1),[AimHeight-4,AimWidth]);
        GrayDes(3:AimHeight-2,:,i)=uint8(G);
    else
        B=imresize(HardSeg(Top(i):Bottom(i),left:right,i),[AimHeight-4,NaN]);[~,c]=size(B);start=round((AimWidth-c)/2)+1;
        BwDes(3:AimHeight-2,start:start+c-1,i)=logical(B);
        G=imresize(GrayPic(Top(i):Bottom(i),CutStart(i)+left-1:CutStart(i)+right-1),[AimHeight-4,NaN]);
        GrayDes(3:AimHeight-2,start:start+c-1,i)=uint8(G);
    end
end
BwDes=logical(BwDes);GrayDes=uint8(GrayDes);
end