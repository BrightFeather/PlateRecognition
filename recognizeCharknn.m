function [ Char ] = recognizeCharknn( im )
%recognizeCharknn: recognize a character using hog feature + k nearest neighbour
%algorithm for classification

Mdl = load('knnMdl4.mat')
Mdl = Mdl.Mdl;
Mdl.NumNeighbors=4;

cellSize=2;
HOGtest=vl_hog(single(im),cellSize,'verbose');
imHOGtest = vl_hog('render', single(HOGtest), 'verbose');
% figure;vl_imarraysc(imHOGtest,im);colormap gray;
CharClass = predict(Mdl,reshape(HOGtest,1,3100));

classes='0123456789ABCDEFGHJKLMNPQRSTUVWXYZ';
% fprintf('Recognized Character is %s',classes(CharClass+1))
Char=classes(CharClass+1);
end

