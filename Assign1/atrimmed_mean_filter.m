function atrim=atrimmed_mean_filter(NoisyIm,d)

%the mask size is set to be 3x3
masksize=1;

NoisyIm = double(NoisyIm);
[sizeX, sizeY] = size(NoisyIm);

 % create a zero matrix with the same size of the input image
reformedimage(sizeX,sizeY)=zeros;

%add 0 at the edge
z1 = zeros(sizeX, 1);
z2 = zeros(1, sizeY + 2);
newIm = [z1, NoisyIm, z1];
newIm = [z2; newIm; z2]; 

for i=1:sizeX;
    for j=1:sizeY;
        window=[];
        for m=-masksize:masksize;
            for n=-masksize:masksize;

% TODO:
% complete this for loop to apply the alpha trimmed mean filter
% pay attention to the range of the index
%
              window(m+2, n+2) = newIm(i+m+1, j+n+1);                      
                
            end
        end
        

       
      
% TODO:
% complete this for loop to apply the alpha trimmed mean filter
%
%
% reformedimage(i,j)= ?
       array = []; %for sorting and averaging
       for k = 1:9
           array(k) = window(k);
       end
       array = sort(array);
       reformedimage(i, j) = mean(array(1+d/2: 9-d/2));   
        
    end
end

atrim=uint8(reformedimage);