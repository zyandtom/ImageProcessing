function HBIm = high_boost_filter(HBIm, Im_blur, k)
%high_boost_filter
HBIm = double(HBIm);
Im_blur = double(Im_blur);
HBIm = HBIm + k*(HBIm - Im_blur);
% image to 0-255.
HBIm = uint8(HBIm);
end