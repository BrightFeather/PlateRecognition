function Char=ChineseRecongnize(img1)
load('template.mat');
char=['��','��','��','��','��','��','³','ԥ','��','��','��','��','��','��','��','��','��','��','��','��','��','��','��','��','��','��','��','��','��','��','��','��'];
[image,~]=UltimateSegmentation(img1,32,16);
imgn=image(:,:,1);
imgn=imadjust(imgn);
imgn=double(imgn);
img5=reshape(imgn,1,512);
[~,tag]=max(img5*pic./sqrt(sum(pic.^2))./sqrt(sum(img5.^2.')));
Char=char(tag);
