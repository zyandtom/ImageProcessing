% MSBD5010_ASSIGN1 MSBD5010 assignment 1 main routine.
%
function msbd5010_assign1()
clc;
clear;
close all;

ImFileName = 'leaf.jpg';
ImFileName_RGB = 'bus.png';

% Read the grayscale image, check if it is a grayscale image of uint8
% datatype.
Im = imread(ImFileName);
Im=rgb2gray(Im);
assert_grayscale_image(Im);
assert_uint8_image(Im);

Im_RGB = imread(ImFileName_RGB);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO 1:
% Histogram equalization.
% Please fill in code in "histogram_eq.m" to accomplish function
% histogram_eq
[HIST_Im, out_C, out_match_C] = histogram_eq(Im, Im_RGB);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO 2:
% Build gradient magnitude image.
% Please fill in code in "grad_mag_image.m" to accomplish function
% grad_mag_image
GMIm = grad_mag_image(Im);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get the image size.
[sizeX, sizeY] = size(Im);

% upper and lower bound for uniform random noise
upper_b = 0.6;
lower_a = 0.5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO 3.1:
% Generate additive Gaussian noise with the given sigma.
% You are required to complete the implementation in gen_uniform_noise.m.
UniformNoise = gen_uniform_noise(sizeX,sizeY,lower_a, upper_b);

% Add uniform noise to the image.
NoiseIm = add_noise(Im,UniformNoise);

% TODO 3.2:
% Filter the noisy image with arithmetic mean filter.
% You need to complete the implementation in arithmetic_mean_filter.m.
ArithIm = arithmetic_mean_filter(NoiseIm);

% TODO 3.3:
% Filter the noisy image with alpha-trimmed mean filter with different
% values of d (listed in the functions below).
% the size of mask should be set to 3x3
% You are required to complete the implementation in atrimmed_mean_fliter.m.
atr_meanIm_1 = atrimmed_mean_filter(NoiseIm,2);
atr_meanIm_2 = atrimmed_mean_filter(NoiseIm,6);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO 4: High-boost filter
% % You are required to complete the implementation in high_boost_filter.m.
% Determine the k by yourself
k = 1.2;
HBIm = high_boost_filter(Im,ArithIm, k);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO 5.1: Periodic noise generator
% You are required to complete the implementation in gen_periodic_noise.m.

Ax = 10;
Ay = 10;
Bx = 0;
By = 0;
u0 = 2*sizeX/pi;
v0 = 2*sizeY/pi;
PeriodicNoise = gen_periodic_noise(Ax, Ay, Bx, By, u0, v0, sizeX,sizeY);

% Add periodic noise to the image.
NoiseIm_periodic = add_noise(Im,PeriodicNoise);

% TODO 5.2: Denoising in frequency domain
% You are required to complete the implementation in band_reject_filter.m.
D0 = 100;
W = 100;
BRIm = band_reject_filter(NoiseIm_periodic, D0, W);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimate the degradation function by image observation, suppose we use the
% observed subimage gs and the undegraded subimage fs for the estimation.
gs = NoiseIm(158:226,164:241);
fs = Im(158:226,164:241);
H = estimate_degradation_func(gs,fs,sizeX,sizeY);

Sn = conj(fft2(UniformNoise)).*fft2(UniformNoise);
Sf = conj(fft2(Im)).*fft2(Im);

% TODO 6:
% Filter the noisy image with Wiener filter, suppose we know the power
% spectra of the noise Sn and the undegraded image Sf.
% You are required to complete the implementation in wiener_filter.m.
WienerIm1 = wiener_filter(NoiseIm,H,Sn,Sf);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% show the result of part 1
figure;
subplot(1,4,1);imshow(Im);title('Original Image');
subplot(1,4,2);imshow(HIST_Im);title('Histogram equalization');
subplot(1,4,3);imshow(out_C);title('Histogram equalization for RGB(1)');
subplot(1,4,4);imshow(out_match_C);title('Histogram equalization for RGB(2)');


% show the result of part 2
figure;
subplot(1,2,1);imshow(Im);title('Original Image');
subplot(1,2,2);imshow(GMIm);title('Gradient magnitude image');


% show the result of part 3 and 4
figure;
subplot(2,3,1);imshow(UniformNoise,[min(UniformNoise(:)) max(UniformNoise(:))]);title('Gaussian Noise');
subplot(2,3,2);imshow(NoiseIm);title('Original Image with noise');
subplot(2,3,3);imshow(ArithIm);title('Arithmetic Mean');
subplot(2,3,4);imshow(atr_meanIm_1);title('Alpha-trimmed Mean 1');
subplot(2,3,5);imshow(atr_meanIm_2);title('Alpha-trimmed Mean 2');
subplot(2,3,6);imshow(HBIm);title('High-boost filter');


% show the reslut of part 5 and 6
figure;
subplot(2,2,1);imshow(Im);title('Original Image');
subplot(2,2,2);imshow(NoiseIm_periodic);title('Periodic noise');
subplot(2,2,3);imshow(BRIm);title('Denoising in frequency domain');
subplot(2,2,4);imshow(WienerIm1);title('Wiener filter');

disp('Done.');