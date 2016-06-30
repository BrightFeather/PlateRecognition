function e=CutEdge(d)
[m,n]=size(d);
top=1;bottom=m;left=1;right=n;   % init
temp=Grey2Black(d,0);
while sum(temp(top,:))==0 && top<=m
    top=top+1;
end
while sum(temp(bottom,:))==0 && bottom>=1
    bottom=bottom-1;
end
while sum(temp(:,left))==0 && left<=n
    left=left+1;
end
while sum(temp(:,right))==0 && right>=1
    right=right-1;
end
dd=right-left;
hh=bottom-top;
e=imcrop(d,[left top dd hh]);
end