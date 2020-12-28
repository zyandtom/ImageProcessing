function [gx, gy] = my_gradient(F)
[x, y] = size(F);
gx = zeros(size(F));
gy = zeros(size(F));
%compute gradient on x
for i=1:x
    for j=1:y
        if j==1
            gx(i,j)=F(i,j+1)-F(i,j);
        elseif 1<j && j<y
            gx(i,j)=(F(i,j+1)-F(i,j-1))/2;
        else
            gx(i,j)=F(i,j)-F(i,j-1);
        end
    end
end
%compute gradient on y
for i=1:x
    for j=1:y
        if i==1
            gy(i,j)=F(i+1,j)-F(i,j);
        elseif 1<i && i<x
            gy(i,j)=(F(i+1,j)-F(i-1,j))/2;
        else
            gy(i,j)=F(i,j)-F(i-1,j);
        end
    end
end
end