function [Des]=Grey2Black(Src,adjust)
%Src is a GrayPic, adjust ranges from -100 to +100
%According to experiments, adjust should be around 15 for blue licenses
    [rows,columns]=size(Src);
    Des=zeros(rows,columns);
    average=sum(sum(Src))/(rows*columns);
    CutLine=average+adjust*(max(max(Src))-min(min(Src)))/100;
    for i=1:rows
        for j=1:columns
            if Src(i,j)>CutLine
                Des(i,j)=255;
            else
                Src(i,j)=0;
            end
        end
    end
end