% GRAD_MAG_IMAGE Compute a gradient magnitude image of the given image.
%
%   Y = GRAD_MAG_IMAGE(X) computes a gradient magnitude image of the image
%   X. The intensity values of the pixels that are out of the image
%   boundary are treated as zeros.
%
%   REMINDER: The gradient magnitude image return should be in uint8 type.
%
function GMIm = grad_mag_image(Im)

assert_grayscale_image(Im);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO 2: 
% Compute the gradient magnitude image.
% GMIm = ?;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %add 0 at the edge
[row, col] = size(Im);
z1 = zeros(row, 1);
z2 = zeros(1, col + 2);
newIm = [z1, Im, z1];
newIm = [z2; newIm; z2];
newIm = double(newIm);
GMIm = zeros(size(Im));
%compute the mag
[row, col] = size(newIm);
for i = 2:row - 1
    for j = 2:col - 1
        GMIm(i - 1, j - 1) = abs(newIm(i + 1, j - 1) + newIm(i + 1, j) + newIm(i + 1, j + 1)...
                             - newIm(i - 1, j - 1) - newIm(i - 1, j) - newIm(i - 1, j + 1))...
                             + abs(newIm(i - 1, j + 1) + newIm(i, j + 1) + newIm(i + 1, j + 1)...
                             - newIm(i - 1, j - 1) - newIm(i, j - 1) - newIm(i + 1, j - 1));
    end
end
GMIm = uint8(GMIm);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

assert_uint8_image(GMIm);