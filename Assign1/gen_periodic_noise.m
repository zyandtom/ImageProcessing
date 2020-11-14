function Noise = gen_periodic_noise(Ax, Ay, Bx, By, u0, v0, M, N)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO 5.1:
% Generate white periodic noise with the given parameters.
%
% Noise = ?
% Noise = zeros(M, N);
% for x = 1:M
%     for y = 1:N
%         Noise(x, y) = Ax*sin(2*pi*u0*(x + Bx)/M) + Ay*sin(2*pi*v0*(y + By)/N);
%     end
% end
x = 1:M;
y = 1:N;
[X, Y] = meshgrid(x, y);
Noise = Ax*sin(2*pi*u0*(X' + Bx)/M) + Ay*sin(2*pi*v0*(Y' + By)/N);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%