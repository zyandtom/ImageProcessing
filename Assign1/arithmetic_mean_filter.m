% ARITHMETIC_MEAN_FILTER Filter a noisy image with an arithmetic mean filter.
%
%   Y = ARITHMETIC_MEAN_FILTER(X) filters a noisy image X with an arithmetic mean filter.
%   A 3-by-3 window is used in the filtering process.
%
function Im = arithmetic_mean_filter(NoisyIm)

% Check if the noisy image is grayscale and of uint8 datatype.
assert_grayscale_image(NoisyIm);
assert_uint8_image(NoisyIm);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO 3.2:
% Filter the noisy image with arithmetic mean filter.  Use a 3x3 window to
% filter the image.
%
% Im = ?

%add 0 at the edge
NoisyIm = double(NoisyIm);
[row, col] = size(NoisyIm);
z1 = zeros(row, 1);
z2 = zeros(1, col + 4);
newIm = [z1, z1, NoisyIm, z1, z1];
newIm = [z2; z2; newIm; z2; z2];   
Im = zeros(size(NoisyIm));

%filtering
[row, col] = size(newIm);
for i = 3:row - 2
    for j = 3:col - 2
        Im(i - 2, j - 2) = mean(mean(newIm(i-2 : i+2, j-2 : j+2)));
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rescale the grayscale values of the filtered image to 0-255 and convert
% the image to uint8 datatype.
Im = (Im-min(Im(:)))./(max(Im(:))-min(Im(:))).*255;
Im = uint8(Im);