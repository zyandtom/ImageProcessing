function [IM_eq, out_C, out_match_C] = histogram_eq(Im, Im_RGB)

% ------------------------------------------------------------
% Compute the histogram of Im
% ------------------------------------------------------------
Im = double(Im);
Im_RGB = double(Im_RGB);

gray_table = zeros(256, 1);
for i = 1:numel(Im)
    for j = 0:255
        if Im(i) == j
            gray_table(j + 1) = gray_table(j + 1) + 1;
            continue
        end
    end
end
gray_table = gray_table/numel(Im);    

% ------------------------------------------------------------
% Display the histogram
% gray_table: the histogram of Im
% ------------------------------------------------------------
figure,
plot((0:1:255),gray_table(:,1));
ylabel('Count');
xlabel('Gray level value');


% ------------------------------------------------------------
% perform histogram equalization on Im
% ------------------------------------------------------------
newtable = gray_table;
for i = 2:256
    newtable(i) = newtable(i - 1) + newtable(i);
end
newtable = round(255*newtable);

gray_table_new = zeros(256, 1);
for i = 1:256
    gray_table_new(newtable(i) + 1) = gray_table_new(newtable(i) + 1) + gray_table(i);
end

IM_eq = Im;
for i = 1:numel(Im)
    for j = 0:255
        if Im(i) == j
            IM_eq(i) = newtable(j + 1);
            continue
        end
    end
end
IM_eq = uint8(IM_eq);
% ------------------------------------------------------------
% Display the histogram
% gray_table_new: the histogram of the equalized image
% ------------------------------------------------------------
figure,
plot((0:1:255),gray_table_new(:,1));
ylabel('Count_new');
xlabel('Gray level value');

% ----------------------------------------------------------------------
% ----------------------------------------------------------------------
C_R = Im_RGB(:,:,1);
C_G = Im_RGB(:,:,2);
C_B = Im_RGB(:,:,3);

% ------------------------------------------------------------
% Compute the histograms of C_R, C_G, C_B 
% ------------------------------------------------------------
gray_table_C_R = zeros(256, 1);
for i = 1:numel(C_R)
    for j = 0:255
        if C_R(i) == j
            gray_table_C_R(j + 1) = gray_table_C_R(j + 1) + 1;
            continue
        end
    end
end
gray_table_C_R = gray_table_C_R/numel(C_R);

gray_table_C_G = zeros(256, 1);
for i = 1:numel(C_G)
    for j = 0:255
        if C_G(i) == j
            gray_table_C_G(j + 1) = gray_table_C_G(j + 1) + 1;
            continue
        end
    end
end
gray_table_C_G = gray_table_C_G/numel(C_G);

gray_table_C_B = zeros(256, 1);
for i = 1:numel(C_B)
    for j = 0:255
        if C_B(i) == j
            gray_table_C_B(j + 1) = gray_table_C_B(j + 1) + 1;
            continue
        end
    end
end
gray_table_C_B = gray_table_C_B/numel(C_B);



% ------------------------------------------------------------
% perform histogram equalization on the R, G, B channels of Im_RGB separately
% gray_table_C_R: the histogram of C_R
% gray_table_C_G: the histogram of C_G
% gray_table_C_B: the histogram of C_B
% ------------------------------------------------------------
newtable_C_R = gray_table_C_R;
for i = 2:256
    newtable_C_R(i) = newtable_C_R(i - 1) + newtable_C_R(i);
end
newtable_C_R = round(255*newtable_C_R);
C_R_eq = C_R;
for i = 1:numel(C_R)
    for j = 0:255
        if C_R(i) == j
            C_R_eq(i) = newtable_C_R(j + 1);
            continue
        end
    end
end

newtable_C_G = gray_table_C_G;
for i = 2:256
    newtable_C_G(i) = newtable_C_G(i - 1) + newtable_C_G(i);
end
newtable_C_G = round(255*newtable_C_G);
C_G_eq = C_G;
for i = 1:numel(C_G)
    for j = 0:255
        if C_G(i) == j
            C_G_eq(i) = newtable_C_G(j + 1);
            continue
        end
    end
end

newtable_C_B = gray_table_C_B;
for i = 2:256
    newtable_C_B(i) = newtable_C_B(i - 1) + newtable_C_B(i);
end
newtable_C_B = round(255*newtable_C_B);
C_B_eq = C_B;
for i = 1:numel(C_B)
    for j = 0:255
        if C_B(i) == j
            C_B_eq(i) = newtable_C_B(j + 1);
            continue
        end
    end
end

% ------------------------------------------------------------
% Rebuild an RGB image from these processed channels.
% out_C_R: result image of C_R after histogram equalization
% out_C_G: result image of C_G after histogram equalization
% out_C_B: result image of C_B after histogram equalization
% ------------------------------------------------------------
out_C = zeros(256, 384, 3);
out_C(:,:,1) = C_R_eq;
out_C(:,:,2) = C_G_eq;
out_C(:,:,3) = C_B_eq;
out_C = uint8(out_C);

% ------------------------------------------------------------
% Calculate an average histogram from the R,G,B histograms
% ------------------------------------------------------------
average_hist = (gray_table_C_R + gray_table_C_G + gray_table_C_B)/3;

% ------------------------------------------------------------
% Use this average histogram as the basis to obtain a single histogram 
% equalization intensity transformation function. Apply this function to 
% the R, G, B channels individually
% ------------------------------------------------------------
newtable_ave = average_hist;
for i = 2:256
    newtable_ave(i) = newtable_ave(i - 1) + newtable_ave(i);
end
newtable_ave = round(255*newtable_ave);

out_match_C_R = C_R;
for i = 1:numel(C_R)
    for j = 0:255
        if C_R(i) == j
            out_match_C_R(i) = newtable_ave(j + 1);
            continue
        end
    end
end

out_match_C_G = C_G;
for i = 1:numel(C_G)
    for j = 0:255
        if C_G(i) == j
            out_match_C_G(i) = newtable_ave(j + 1);
            continue
        end
    end
end

out_match_C_B = C_B;
for i = 1:numel(C_B)
    for j = 0:255
        if C_B(i) == j
            out_match_C_B(i) = newtable_ave(j + 1);
            continue
        end
    end
end
% ------------------------------------------------------------
% Rebuild an RGB image from these processed channels.
% out_match_C_R: result image of C_R after histogram matching
% out_match_C_G: result image of C_G after histogram matching
% out_match_C_B: result image of C_B after histogram matching
% ------------------------------------------------------------
out_match_C = zeros(256, 384, 3);
out_match_C(:,:,1) = out_match_C_R;
out_match_C(:,:,2) = out_match_C_G;
out_match_C(:,:,3) = out_match_C_B;
out_match_C = uint8(out_match_C);

end