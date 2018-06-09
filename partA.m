clc
clear 
close all

img = imread('Lenna.png');
img = rgb2gray(img);
[row, col] = size(img);


% phase and power spectrum for original image
FFT_G = fft2(double(img));
power = abs(fftshift(FFT_G));
origin_phase = angle(fftshift(FFT_G));
% [f1,f2] = freqspace([row,col],'meshgrid');%get frequency space
% subplot(2,2,1);mesh(f1,f2,log(power+1));title('Original Power Spectrum');
subplot(3,3,1),imshow(img),title('Original Image');
subplot(3,3,2),imshow(log(power+1),[]),title('Original Power Spectrum');
%subplot(2,2,3);imagesc(origin_phase);title('Original Phase Spectrum');
subplot(3,3,3),imshow(origin_phase, []),title('Original Phase Spectrum');
%% phase-randomized

for m = 1:row
    for n = 1:col
        length = abs(FFT_G(m,n));
        rand_angle = rand(1)*2*pi;% random from (0,1)
        x = length*cos(rand_angle);
        y = length*sin(rand_angle);
        FFT_G(m,n) = x+1i*y;
    end
end

IFFT_G = ifft2(FFT_G);
IFFT_G = abs(IFFT_G);


%plot the phase and power of the suppressed image
power = abs(fftshift(FFT_G));
phase = angle(fftshift(FFT_G));
[f1,f2] = freqspace([row,col],'meshgrid');%get frequency space
%subplot(3,3,2);mesh(f1,f2,log(power+1));title('Phase-randomized Power Spectrum');
subplot(3,3,5),imshow(log(power+1),[]),title('Phase-randomized Power Spectrum');
%subplot(2,2,4);imagesc(phase);title('Phase-randomized Phase Spectrum');
subplot(3,3,6),imshow(phase,[]),title('Phase-randomized Phase Spectrum');

%figure,subplot(1,2,1),imshow(uint8(img));title('Original Image');
subplot(3,3,4),imshow(uint8(IFFT_G));title('Phase-randomized Image');

%% whitened 
img_origin = img;
img = im2double(img);

FFT_G = fft2(double(img));
power = abs(fftshift(FFT_G));
origin_phase = angle(fftshift(FFT_G));

% %whitened method2
% I = I-mean(I(:));
% A = I'*I;
% fudgefactor = 10;
% [V,D] = eig(A);
% I = I*V*diag(1./(diag(D)+fudgefactor).^(1/2))*V';
% 
% FFT_G = fft2(double(I));
% % mean_power = sqrt(mean(abs(FFT_G(:)).^2));
% mean_power = (mean(abs(FFT_G(:)).^2));


for m = 1:row
    for n = 1:col
        length = abs(FFT_G(m,n));
        FFT_G(m,n) = FFT_G(m,n)./length;
    end
end

%normalize and add some intensity to make it white
IFFT_G = ifft2(FFT_G);
IFFT_G = IFFT_G./max(IFFT_G(:));
%IFFT_G = IFFT_G+0.7;

%plot the phase and power of the suppressed image
FFT_G = fft2(double(IFFT_G));
power = abs(fftshift(FFT_G));
phase = angle(fftshift(FFT_G));
[f1,f2] = freqspace([row,col],'meshgrid');%get frequency space
%subplot(2,2,2);mesh(f1,f2,log(power+1));title('Power Spectrum');
% subplot(2,2,2);imagesc(log(power+1));title('Power Spectrum');
% subplot(2,2,4);imagesc(phase);title('Phase Spectrum');
subplot(3,3,8),imshow(log(power+1),[]),title('Whiten Power Spectrum')
subplot(3,3,9),imshow(phase,[]),title('Whiten Phase Spectrum');

%figure,subplot(1,2,1); imshow(uint8(img_origin));title('Original Image')
subplot(3,3,7);imshow(IFFT_G+0.5); title('Whitened Image');
diff = origin_phase - phase;
max(diff(:))
