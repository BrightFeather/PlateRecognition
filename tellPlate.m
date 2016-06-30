function [plate] = main(filename)
    close all;
    im=imread(filename);
    figure;imshow(im);
    GreyPic=rgb2gray(im);
%     figure;imshow(uint8(GreyPic));
    load('template.mat');
    [Set1,t]=FinalSegmentation(GreyPic,20,20);
%     [Set2,num2]=TraditionalSegmentation2(GreyPic,10);
%     save('Set1.mat','Set1');
    figure;vl_imarraysc(single(Set1(:,:,:)),'layout',[1,7]);colormap gray;
    plate='000000';
    
%     plate(0)=ChineseRecognize(Set1(:,:,1),pic);
    
    for i=2:7
        plate(i-1)=recognizeCharknn(single(Set1(:,:,i)));
    end
%     save('Set1.mat','Set1')
%     fprintf('%s',plate);


end