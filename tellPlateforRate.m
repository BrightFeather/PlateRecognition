function [plate] = tellPlateforRate(filename)
%%  This function tests the accuracy rate for letters and digits.
%%
%   setup only necessary at initialization   
%   setup; 

    close all;
    im=imread(filename);
    figure;imshow(im);
    GreyPic=rgb2gray(im);
    load('template.mat');
    [Set1,t]=FinalSegmentation(GreyPic,20,20);
%     save('Set1.mat','Set1'); 
%     save it if you want to see the segmented pictures

    figure;vl_imarraysc(single(Set1(:,:,:)),'layout',[1,7]);colormap gray;
    
    plate='000000';
    for i=2:7
        plate(i-1)=recognizeCharknn(single(Set1(:,:,i)));
    end
end