function [ Des ] = CutLicenseEdge( Src, CharacterNum)
%Src has logical components
Des=Src;JumpNum=2*CharacterNum-1;
[rows,columns]=size(Src);
for i=1:rows
    CountJump=0;
    for j=2:columns
        if (Des(i,j)-Des(i,j-1))~=0
            CountJump=CountJump+1;
        end
    end
    if CountJump<JumpNum
        Des(i,:)=zeros(1,columns);
    end
end
Des=bwareaopen(Des,round(rows*columns/300));
VerticalSum=sum(Des);
i=1;
while(VerticalSum(i)~=0)
 i=i+1;
end
if i<columns/20
    Des(:,1:i)=zeros(rows,i);
end
i=columns;
while(VerticalSum(i)~=0)
 i=i-1;
end
if columns-i+1<columns/20
    Des(:,i:columns)=zeros(rows,columns-i+1);
end
%Des(1:smaller,:)=zeros(smaller,columns);
%Des(bigger:rows,:)=zeros(rows-bigger+1,columns);
end