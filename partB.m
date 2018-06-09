clc 
clear
%close all

img = imread('cheetah2.jpeg');
img = rgb2gray(img);
[row,col] = size(img);

pattern = 2;
kernel_length = 15;
sigma = kernel_length/6; % control the size of the gaussian
gaussian_filt = DtG(pattern, kernel_length, sigma);
[m,n,dim]= size(gaussian_filt);

output = zeros(row,col);

figure;

for d=1:dim
    out(:,:,d) = conv2(im2double(img), gaussian_filt(:,:,d), 'same');
    absout = abs(out(:,:,d));
    subplot(1,dim,d),imshow(absout./max(absout(:)));
    %title(['Apply Kernel ' num2str(d)]);
    %Gx^2+Gy^2
    output = output + out(:,:,d).^2; % avoid pixel value less than zero
end

%sqrt(Gx^2+Gy^2)
output= output.^(1/2);

output = output./max(output(:));
figure, subplot(1,2,1), imshow(img), title('Original img');
subplot(1,2,2), imshow(output), title('0th order result');
