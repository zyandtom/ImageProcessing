function my_active_contour(img)

if(size(img,3) == 3) 
    img=rgb2gray(img); 
end

numPoints = 100;
splinePoints = get_initial_contour(img, numPoints);
X_spline  = splinePoints(1,:);
Y_spline  = splinePoints(2,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%Gaussian filtering
imgd = double(img);
[row, col] = size(imgd);
sigma=1.0; 
gaussianfilter = zeros(3, 3);
for i=-1:1
    for j=-1:1
        gaussianfilter(i+2, j+2) = 1/(2*pi*sigma^2)*exp(-(i^2 + j^2)/(2*sigma^2));
    end
end 
imgpadding = zeros(row+2, col+2);
imgpadding(2:row+1, 2:col+1) = imgd;
for i=1:row
    for j=1:col
        imgd(i,j) = sum(sum(gaussianfilter.*imgpadding(i:i+2, j:j+2)));
    end
end

%%%%%%%%%%%%%%%% computer the energy term(s) for snake model
alpha=0.08; beta=0.08; gamma = 1; k = 0.1;  
we=0.4;   

% Eline = imgd;
%%%%%%%%%%%%%%%%%there is a gradient function written by myself
[gx,gy]=my_gradient(imgd);  
Eedge = -1*sqrt((gx.*gx+gy.*gy));  

% m1 = [-1 1];   
% m2 = [-1;1];  
% m3 = [1 -2 1];   
% m4 = [1;-2;1];  
% m5 = [1 -1;-1 1];  
% %compute cx 
% cx = zeros(row, col);
% m1 = rot90(m1,2);
% imgd1 = [imgd,zeros(size(imgd,1), 1)];
% for i=1:row
%     for j=1:col
%         cx(i,j) = imgd1(i,j)*m1(1) + imgd1(i,j+1)*m1(2);
%     end
% end
% %compute cy 
% cy = zeros(row, col);
% m2 = rot90(m2,2);
% imgd2 = [imgd;zeros(1, size(imgd,2))];
% for i=1:row
%     for j=1:col
%         cy(i,j) = imgd2(i,j)*m2(1) + imgd2(i+1,j)*m2(2);
%     end
% end
% %compute cxx  
% cxx = zeros(row, col);
% m3 = rot90(m3,2);
% imgd3 = [imgd,zeros(size(imgd,1), 2)];
% for i=1:row
%     for j=1:col
%         cxx(i,j) = imgd3(i,j)*m3(1) + imgd3(i,j+1)*m3(2) + imgd3(i,j+2)*m3(3);
%     end
% end
% %compute cyy 
% cyy = zeros(row, col);
% m4 = rot90(m4,2);
% imgd4 = [imgd;zeros(2, size(imgd,2))];
% for i=1:row
%     for j=1:col
%         cyy(i,j) = imgd4(i,j)*m4(1) + imgd4(i+1,j)*m4(2) + imgd4(i+2,j)*m4(3);
%     end
% end
% %compute cxy 
% cxy = zeros(row, col);
% m5 = rot90(m5,2);
% imgd5 = [imgd;zeros(2, size(imgd,2))];
% imgd5 = [imgd5,zeros(size(imgd5,1), 2)];
% for i=1:row
%     for j=1:col
%         cxy(i,j) = imgd5(i,j)*m5(1) + imgd5(i+1,j)*m5(2) + imgd5(i,j+1)*m5(3) + imgd5(i+1,j+1)*m5(4);
%     end
% end 
%   
% for i = 1:row  
%     for j= 1:col  
%         Eterm(i,j) = (cyy(i,j)*cx(i,j)*cx(i,j) -2 *cxy(i,j)*cx(i,j)*cy(i,j) + cxx(i,j)*cy(i,j)*cy(i,j))/((1+cx(i,j)*cx(i,j) + cy(i,j)*cy(i,j))^1.5);  
%     end  
% end  
  
  
%%%%%%%%%%%%%%%%%%%%%%%%% Eext = Eimage + Econ  
Eext = we*Eedge;  

[fx,fy]=my_gradient(Eext);  
  
X_spline=X_spline';  
Y_spline=Y_spline';  
[m, n] = size(X_spline);  
[mm, nn] = size(fx); 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Computer the matrix A
% ----------------------------------------------------------------------
% ------------ State the derivation process of the matrix A ------------ 
% ------ You can also write it down in a .txt file or a .pdf file ------ 
%
%
%
%
% ----------------------------------------------------------------------
b(1)=beta;  
b(2)=-(alpha + 4*beta);  
b(3)=(2*alpha + 6 *beta);  
b(4)=b(2);  
b(5)=b(1);  
  
eyem2 = eye(m);
for i=1:2
    temp = eyem2(m,:);
    eyem2(m,:)=[];
    eyem2=[temp;eyem2];
end
A=b(1)*eyem2;  

eyem1 = eye(m);
temp = eyem1(m,:);
eyem1(m,:)=[];
eyem1=[temp;eyem1];
A=A+b(2)*eyem1;  

A=A+b(3)*eye(m);  

eyemf1 = eye(m);
temp = eyemf1(1,:);
eyemf1(1,:)=[];
eyemf1=[eyemf1;temp];
A=A+b(4)*eyemf1; 

eyemf2 = eye(m);
for i=1:2
    temp = eyemf2(1,:);
    eyemf2(1,:)=[];
    eyemf2=[eyemf2;temp];
end
A=A+b(5)*eyemf2;  
  

[L U] = lu(A + gamma.* eye(m));  
Ainv = inv(U) * inv(L); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set your own number of iterations
numIterations = 3000;
figure
for i=1:numIterations
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Update the locations of the contour
    % You are required to implement the interpolation algorithm by yourself
    % (The nearest interpolation are allowed to used.)
    
    %bilinear interpolation
    interplistx = zeros(size(X_spline));
    for j=1:length(X_spline)
        u = X_spline(j)-fix(X_spline(j));
        v = Y_spline(j)-fix(Y_spline(j));
        interplistx(j) = (1-u)*(1-v)*fx(fix(Y_spline(j)), fix(X_spline(j))) + u*(1-v)*fx(fix(Y_spline(j))+1, fix(X_spline(j)))...
            + (1-u)*v*fx(fix(Y_spline(j)), fix(X_spline(j))+1) + u*v*fx(fix(Y_spline(j))+1, fix(X_spline(j))+1);
    end
    interplisty = zeros(size(X_spline));
    for j=1:length(X_spline)
        u = X_spline(j)-fix(X_spline(j));
        v = Y_spline(j)-fix(Y_spline(j));
        interplisty(j) = (1-u)*(1-v)*fy(fix(Y_spline(j)), fix(X_spline(j))) + u*(1-v)*fy(fix(Y_spline(j))+1, fix(X_spline(j)))...
            + (1-u)*v*fy(fix(Y_spline(j)), fix(X_spline(j))+1) + u*v*fy(fix(Y_spline(j))+1, fix(X_spline(j))+1);
    end
    ssx = gamma*X_spline - k*interplistx;  
    ssy = gamma*Y_spline - k*interplisty;
    
    % compute the new position
    X_spline = Ainv * ssx;  
    Y_spline = Ainv * ssy;  
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    imshow(img); 
    hold on;
    plot([X_spline; X_spline(1)], [Y_spline; Y_spline(1)], 'r-'); 
    hold off;
    pause(0.001)    
end

%{
imshow(I); 
hold on;
plot([X_spline; X_spline(1)], [Y_spline; Y_spline(1)], 'r-');
hold off;
%}