% GEN_UNIFORM_NOISE Generate additive uniform random noise.
%
%   Y = GEN_UNIFORM_NOISE(m,n,sigma) generates an additive uniform random noise image of
%   size m-by-n with the upper and lower bound equal to b and a
%   respectively.
%
function Noise = gen_uniform_noise(sizeX, sizeY, a, b)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO 3.1:
% Generate white uniform noise with the given sigma.
%
% Noise = ?
Noise = rand(sizeX, sizeY);
for i = 1:sizeX*sizeY
    if Noise(i) >= a && Noise(i) <= b
        Noise(i) = 10;
    else
        Noise(i) = 0;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ensure the noise is of double datatype.
assert_double_image(Noise);