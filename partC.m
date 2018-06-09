clc
clear
%close all
im = imread('castle.png');
im = rgb2gray(im);
im = im2double(im);

kernel_length = 40;
sigma = 4;
DtG0 = DtG(0,kernel_length,sigma);
DtG1 = DtG(1,kernel_length,sigma);
DtG2 = DtG(2,kernel_length,sigma);

% initial sysmmetry types
w2 = DtG2(:,:,2);
C00 = DtG0;
C00(:,end) = [];
C00(end,:) = [];
C10 = DtG1(:,:,1);
C10(:,end) = [];
C10(end,:) = [];
C01 = DtG1(:,:,2);
C01(:,end) = [];
C01(end,:) = [];
C20 = w2;
C02 = w2';
G11 = DtG(1,kernel_length,sigma);
C11 = G11(:,:,1).*G11(:,:,2);
C11(:,end) = [];
C11(end,:) = [];

% convolve to image
C00 = conv2(im,C00,'same');
C10 = conv2(im,C10,'same');
C01 = conv2(im,C01,'same');
C11 = conv2(im,C11,'same');
C20 = conv2(im,C20,'same');
C02 = conv2(im,C02,'same');

S00 = sigma^0*C00;
S10 = sigma^1*C10;
S01 = sigma^1*C01;
S11 = sigma^2*C11;
S20 = sigma^2*C20;
S02 = sigma^2*C02;
lambda = S20+S02;
gamma = sqrt((S20-S02).^2+4*S11.^2);
epsilon = 0.1;

M = zeros(size(C00,1),size(C00,2),7);
M(:,:,1) = epsilon*S00;
M(:,:,2) = 2*sqrt(S10.^2 + S01.^2);
M(:,:,3) = +lambda;
M(:,:,4) = -lambda;
M(:,:,5) = 2^(-1/2).*(lambda+gamma);
M(:,:,6) = 2^(-1/2).*(gamma - lambda);
M(:,:,7) = gamma;

Output = zeros(size(M,1),size(M,2),3);
hist_x = ['pink','grey','black','white','blue','yellow','green'];
hist_y = zeros(1,7);
for i = 1:size(M,1)
    for j = 1:size(M,2)
        colour = find(M(i,j,:)== max(M(i,j,:)));
        switch colour
            case 1
            %pink
            Output(i,j,1) = 255;
            Output(i,j,2) = 179;
            Output(i,j,3) = 178;
            hist_y(1,1) = hist_y(1,1)+1;
            case 2
            %grey
            Output(i,j,1) = 150;
            Output(i,j,2) = 150;
            Output(i,j,3) = 150;
            hist_y(1,2) = hist_y(1,2)+1;
            case 3
            %black
            Output(i,j,1) = 0;
            Output(i,j,2) = 0;
            Output(i,j,3) = 0;
            hist_y(1,3) = hist_y(1,3)+1;
            case 4
            %white
            Output(i,j,1) = 255;
            Output(i,j,2) = 255;
            Output(i,j,3) = 255;
            hist_y(1,4) = hist_y(1,4)+1;
            case 5
            %blue
            Output(i,j,1) = 0;
            Output(i,j,2) = 0;
            Output(i,j,3) = 255;
            hist_y(1,5) = hist_y(1,5)+1;
            case 6
            %yellow 
            Output(i,j,1) = 255;
            Output(i,j,2) = 255;
            Output(i,j,3) = 0;
            hist_y(1,6) = hist_y(1,6)+1;
            case 7
            %green
            Output(i,j,1) = 0;
            Output(i,j,2) = 255;
            Output(i,j,3) = 0;
            hist_y(1,7) = hist_y(1,7)+1;
        end
    end
end
figure,subplot(1,2,1),imshow(im),title('Original Img');
subplot(1,2,2),imshow(uint8(Output)),title({['Basic Image Features'];['sigma=',num2str(sigma),' epsilon=',num2str(epsilon)]});