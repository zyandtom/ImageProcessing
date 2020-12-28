function compression_jpeg()
% Read the image
Im = imread('lenaTest1.jpg');
% change the image type to double
Im = double(Im);
OriginalIm=Im;
%
% Start compression
%

%
% (1)Subtract the image intensity by 128.
Im = Im -128;

% (2)Partition the input image into 8x8 blocks
for r=1:64
    for c=1:64
        B((r-1)*64+c, 1:8, 1:8) = Im( (r-1)*8+1:r*8 , (c-1)*8+1:c*8 ); 
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO:
% (3)Apply DCT to each 8x8 block 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Q=[16 11 10 16 24 40 51 61;
   12 12 14 19 26 58 60 55;
   14 13 16 24 40 57 69 56;
   14 17 22 29 51 87 80 62;
   18 22 37 56 68 109 103 77;
   24 35 55 64 81 104 113 92;
   49 64 78 87 103 121 120 101;
   72 92 95 98 112 100 103 99];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO:
% (4) Perform quantisation with Quantisation Table and change all the
% quantized coefficients into integer.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% (5) Follow zip-zag order (pp. 80 Image compression Part I), change all 8x8 blocks 
%       into vectors with 64 elements.

Z=[0 1 5 6 14 15 27 28;
   2 4 7 13 16 26 29 42;
   3 8 12 17 25 30 41 43;
   9 11 18 24 31 40 44 53;
   10 19 23 32 39 45 52 54;
   20 22 33 38 46 51 55 60;
   21 34 37 47 50 56 59 61;
   35 36 48 49 57 58 62 63];
Z=Z+1;

for k=1:4096
   tmpCS(Z)=C1(k, 1:8, 1:8);
   CS(k, 1:64)=tmpCS;
end


%
% Finish compression, start decompression
%


% (1) Change the vectors back to 8x8 blocks 
%
for k=1:4096
   tmpCS=CS(k, 1:64);
   tmpDC1=tmpCS(Z);
   DC1(k, 1:8, 1:8)=tmpDC1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO:
%(2) Multiply the blocks with quantization table.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO:
%(3) Apply Inverse DCT to each block, (use command idct2¨ of matlab)
%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%(4) Group all 8x8 blocks back to form an image
%
for r=1:64
    for c=1:64
        tmpIm=DB((r-1)*64+c, 1:8, 1:8);
        Im( (r-1)*8+1:r*8 , (c-1)*8+1:c*8 ) = tmpIm;
    end
end

%
%(5)  Add 128 to each pixel of the image.
%

Im = Im + 128;
Im = uint8(Im);
Im = double(Im);

%
% Finish Decompression
%
figure;
subplot(1,3,1);imshow(OriginalIm, [0 255]);title('Original Image');
subplot(1,3,2);imshow(Im, [0 255]);title(['After DCT/Quantisation']); %, MSE = ' num2str(sum(sum((Im-OriginalIm).^2)))]);
subplot(1,3,3);imshow((OriginalIm-Im), []);title(['Difference image, MSE= ' num2str(mean(mean(  (  (Im-OriginalIm) .^2 ))  ))]);
%subplot(2,2,4); imshow([205], [0 255]);title(['Mean Square Error = ' num2str(sum(sum((Im-OriginalIm).^2)))]);

