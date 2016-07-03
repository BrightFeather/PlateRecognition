function Char=ChineseRecongnize(image)
load('template.mat');
char=['¾©','ËÕ','Õã','Íî','Ãö','¸Ó','Â³','Ô¥','¶õ','Ïæ','ÔÁ','½ò','Çí','´¨','¹ó','ÔÆ','ÉÂ','¸Ê','Çà','²Ø','¹ğ','ÃÉ','»¦','ĞÂ','Äş','¸Û','Óå','¼½','½ú','ÁÉ','¼ª','ºÚ'];
imgn=image(:,:,1);
sum1=sum(imgn.');
 j=1;
 for i=1:32
     if sum1(i) <2
         imgn(j,:)=[];
     else
         j=j+1;
     end
 end
 j=1;
 sum2=sum(imgn);
  for i=1:16
     if sum2(i) <2
         imgn(:,j)=[];
     else
         j=j+1;
     end
  end
  imgn2=imresize(imgn,[32,16]);
imgn2=imadjust(imgn2);
imgn2=double(imgn2);
img5=reshape(imgn2,1,512);
[~,tag]=max(img5*pic./sqrt(sum(pic.^2))./sqrt(sum(img5.^2.')));
Char=char(tag);
