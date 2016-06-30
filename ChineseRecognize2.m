function Char=ChineseRecongnize(img1)
load('template.mat');
char=['¾©','ËÕ','Õã','Íî','Ãö','¸Ó','Â³','Ô¥','¶õ','Ïæ','ÔÁ','½ò','Çí','´¨','¹ó','ÔÆ','ÉÂ','¸Ê','Çà','²Ø','¹ğ','ÃÉ','»¦','ĞÂ','Äş','¸Û','Óå','¼½','½ú','ÁÉ','¼ª','ºÚ'];
[image,~]=UltimateSegmentation(img1,32,16);
imgn=image(:,:,1);
imgn=imadjust(imgn);
imgn=double(imgn);
img5=reshape(imgn,1,512);
[~,tag]=max(img5*pic./sqrt(sum(pic.^2))./sqrt(sum(img5.^2.')));
Char=char(tag);
