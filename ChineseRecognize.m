function Char=ChineseRecongnize(img1)
%list=dir(['C:\Users\lijunyi\Desktop\tt\','*.jpg']);
%k=length(list); 
% [img1,map]=imread('C:\Users\lijunyi\Desktop\tt\4.bmp');
%num=0;
char=['¾©','ËÕ','Õã','Íî','Ãö','¸Ó','Â³','Ô¥','¶õ','Ïæ','ÔÁ','½ò','Çí','´¨','¹ó','ÔÆ','ÉÂ','¸Ê','Çà','²Ø','¹ğ','ÃÉ','»¦','ĞÂ','Äş','¸Û','Óå','¼½','½ú','ÁÉ','¼ª','ºÚ'];
char1=['A','B','C','D','E','F','G','H','J','K','L','M','P','Q','R','S','T','U','V','W','X','Y','Z','0','1','2','3','4','5','6','7','8','9'];
%for m=1:k
%     [img1,error]=rgbcolormap(strcat ('C:\Users\lijunyi\Desktop\ttt\',list(m).name),1); 
%     figure(1);
%     imshow(img1);
%     if error==1;
%         continue;
%     end
%  imshow(img);
% img1=imread(strcat ('C:\Users\lijunyi\Desktop\tt\',list(m).name));
% img2=rgb2gray(img1);
[image]=BetterSegmentation(img1,7,32,16);
% image=double(image)*255;
% [image,~]=TraditionalSegmentation2(img1,10);
 imgn=image(:,:,1);
 imgn=imadjust(imgn);
 figure(2);
 imshow(imgn);
 imgn=double(imgn);
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
  [r,l]=size(imgn);
  if r==0 || l==0
      continue;
  end
  imgn2=imresize(imgn,[32,16]);
  imshow(imgn2);
   for i=1:32
     for j=1:16
         if(imgn2(i,j)<0.5)
             imgn2(i,j)=0;
         else
             imgn2(i,j)=1;
         end
     end
   end
img5=reshape(imgn,1,512);
[~,tag]=max(img5*template./sqrt(sum(template.^2))./sqrt(sum(img5.^2.')));
i=1;
if tag==2 || tag==4 || tag==24 || tag==32
   img3=reshape(imgn,1,512);
   while 1
       if img3(i) < 65
           i=i+1;
       else
           break;
       end
   end
   while 1
       if img3(i) < 65
           break;
       end
       i=i+1;
   end
   if i<15
       tag=32;
   elseif i>15&&i<50
       tag=24;
   elseif i>50&&i<105
       tag=4;
   else
       tag=2;
   end
end
Char=char(tag);
%if char1(tag)==list(m).name(4)
%    num=num+1;
%end
%end
%  result1=zeros(1,32);
%  for i=1:32
%      result1(i)=max(xcorr(reshape(imgn2,1,512),pic(:,i)))/sum(pic(:,i));
%  end
%  figure;
%  plot(result1);