function recognizeChar(im)
% imfile: absolute/relative location to image (20*20 gray picture)

setup;
%load image
% im = im2single(imread(imfile));

if size(im)~=[20,20]
    im=imresize(im,[20 20]);
end
% initialize net
net = load('net-epoch-30.mat') ;
net = net.net;
net.layers{end}.type='softmax';

% figure;clf;
% imagesc(im);colormap gray;

% Apply the neural network to image
res = vl_simplenn(net, im) ;

% calculate possibilities
m = squeeze(sum(sum(res(end).x,1),2));

% Get the results
dig = find(m==max(m));
classes='0123456789ABCDEFGHJKLMNPQRSTUVWXYZ';
if (classes(dig)=='8') | (classes(dig)=='B')
    fprintf('hi');
    recognize8B(im);
else
    fprintf('Recognized character is: %s\n', classes(dig));
end
end
