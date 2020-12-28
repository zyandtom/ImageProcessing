% Watershed Segmentation Algorithm
input_img = imread('circle_input.png');
f=rgb2gray(input_img);
g=im2bw(f,graythresh(f));

[c_img, dist_img, label_img, ridge_img, sep_img] = my_watershed(g);

figure,subplot(2,3,1),imshow(g);title('Binary Image');
subplot(2,3,2),imshow(c_img);title('Complement Image');
subplot(2,3,3),imshow(dist_img,[]);title('Inverse Distance Image');
subplot(2,3,4),imagesc(label_img);title('Label Image');
subplot(2,3,5),imshow(ridge_img);title('Dilated Ridge Pixels');
subplot(2,3,6),imshow(sep_img);title('Watershed Segmentation');


% Active Contour Model
img = imread('leaf.jpg');
my_active_contour(img);


% Hough transform
hough_transform();
