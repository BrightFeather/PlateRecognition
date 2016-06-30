function [ Segment ] = Sep( Gray_array )
[row,line]=size(Gray_array);
line1=line/15*2;
Segment=zeros(row,line1,7);
Segment(:,:,1)=Gray_array(:,1:line1);
Segment(:,:,2)=Gray_array(:,line1+1:2*line1);
Segment(:,:,3)=Gray_array(:,2.5*line1+1:3.5*line1);
Segment(:,:,4)=Gray_array(:,3.5*line1+1:4.5*line1);
Segment(:,:,5)=Gray_array(:,4.5*line1+1:5.5*line1);
Segment(:,:,6)=Gray_array(:,5.5*line1+1:6.5*line1);
Segment(:,:,7)=Gray_array(:,6.5*line1+1:7.5*line1);
end

