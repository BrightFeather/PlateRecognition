function [  ] = recognize8B( im )
%This function is written to distinguish 8 and B
%   im: 20*20 gray image, with human recognizable char of either 8 or B

% setup vlfeat environment, uncomment or type in command line during
% initialization
% setup;
% show image
% figure;vl_imarraysc(im);colormap gray;

cellSize=2;
hog = vl_hog(im, cellSize, 'verbose') ;
% Show the HoG image
% imhog = vl_hog('render', hog, 'verbose') ;
% clf ; imagesc(imhog) ; colormap gray ;

s=load('para_svm_cs2.mat');
vhog = reshape(hog,[],1);
if(s.w'*vhog+s.b>0)
    fprintf('Recognized char is B');
else
    fprintf('Recognized char is 8');
end

end

