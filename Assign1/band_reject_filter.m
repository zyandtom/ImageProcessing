function BRIm = band_reject_filter(NoiseIm, D0, W)
NoiseIm = double(NoiseIm);

%build the matrix for filter and output in frequency domain
[row, col] = size(NoiseIm);
H = zeros(row, col);
G = zeros(row, col);

%find the center
cx = (row + 1)/2;
cy = (col + 1)/2;

%Fourier transform and move to center
F = fftshift(fft2(NoiseIm));

%Gaussian filtering
for i = 1:row
    for j = 1:col
        d = (i-cx)^2 + (j-cy)^2;
        H(i, j) = 1 - exp(-1/2*((d - D0^2)/(sqrt(d)*W))^2);
        G(i, j) = H(i, j)* F(i, j);
    end
end

%output
BRIm = real(ifft2(ifftshift(G))); 
BRIm = uint8(BRIm);
        
end