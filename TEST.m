function [ numOfCorrect, recName ] = TEST( img,name )
%UNTITLED5 此处显示有关此函数的摘要
%   此处显示详细说明
numOfCorrect = 0;
recName='000000';
% recName(1)=ChineseRecognize2(single(img(:,:,1)));
for i=2:7
    recName(i-1) = recognizeCharknn(single(img(:,:,i)));
    if recName(i-1) == name(i)
        numOfCorrect = numOfCorrect + 1;
    end
end

