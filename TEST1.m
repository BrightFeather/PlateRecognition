list=dir(['testset/','*.jpg']);
k=length(list);
count=0;
fid = fopen('result.txt', 'wt');
for m=1:k
    img1=imread(strcat ('testset/',list(m).name));
    image=FinalSegmentation(img1,20,20);
    [numOfCorrect,recName] = TEST(image,list(m).name);
    fprintf(fid,'Plate %s recognized as %s. ', list(m).name(2:7),recName);
    if numOfCorrect == 6
        fprintf(fid,'Correct!:)\n');
    else
        fprintf(fid,'Wrong~:(\n');
    end
    count = count + numOfCorrect;
    
    rate=count/(k*6);
    fprintf(fid,'%d out of %d characters successfully recognized. Correct rate is %f.\n',count,k*6,rate);
end
rate=count/(k*6);
fprintf(fid,'Summary: %d out of %d characters successfully recognized. Correct rate is %f.\n',count,k*6,rate);