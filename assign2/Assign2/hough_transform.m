function hough_transform()
    img = imread('circle_hough_image.jpg');

    % Display the input image
    figure;
    imshow(img);title('Input image');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % TODO_1: Find the edge of the image
    % imgEdge = ??
    [row, col] = size(img);
    z1 = zeros(row, 1);
    z2 = zeros(1, col + 2);
    newimg = [z1, img, z1];
    newimg = [z2; newimg; z2];
    newimg = double(newimg);
    imgEdge = zeros(size(img));
    %compute the mag
    [row, col] = size(newimg);
    for i = 2:row - 1
        for j = 2:col - 1
            imgEdge(i - 1, j - 1) = abs(newimg(i + 1, j - 1) + newimg(i + 1, j) + newimg(i + 1, j + 1)...
                                 - newimg(i - 1, j - 1) - newimg(i - 1, j) - newimg(i - 1, j + 1))...
                                 + abs(newimg(i - 1, j + 1) + newimg(i, j + 1) + newimg(i + 1, j + 1)...
                                 - newimg(i - 1, j - 1) - newimg(i, j - 1) - newimg(i + 1, j - 1));
        end
    end
    imgEdge = uint8(imgEdge);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    imgBW = imbinarize(imgEdge);
    
    figure;    
    imshow(imgBW);title('Edge');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % TODO_2: Perform the circular Hough Transform. Create a varible 
    %'Accumulator' to store the bin counts.
    % Accumulator = ??
    step_r = 1;
    step_angle = 0.1;
    r_min = 40;
    r_max = 80;
    
    [m,n] = size(imgBW);
    size_r = round((r_max-r_min)/step_r)+1;
    size_angle = round(2*pi/step_angle);
    Accumulator = zeros(m,n,size_r);
    [rows,cols] = find(imgBW);
    ecount = size(rows);
    % Hough变换
    % 将图像空间(x,y)对应到参数空间(a,b,r)
    % a = x+r*cos(angle)
    % b = y+r*sin(angle)
    maxr = zeros(1,size_r);
    for i=1:ecount
        for r=1:size_r
            for k=1:size_angle
                a = round(rows(i)+(r_min+(r-1)*step_r)*cos(k*step_angle));
                b = round(cols(i)+(r_min+(r-1)*step_r)*sin(k*step_angle));
                if(a>0 && a<=m && b>0 && b<=n)
                    Accumulator(a,b,r) = Accumulator(a,b,r)+1;
                end
            end
            maxr(r) = max(max(Accumulator(:,:,r)));
        end
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % TODO_3: Search the count cell in 'Accumulator' and store the required
    % x,y-coordinates and the corresponding radii in three separate arrays. 
    % Note that there should be 2 sets of x, y-coordinates and radii, 
    % ie: Xc = [{Xvalue1};{Xvalue2}] , Yc = [{Yvalue1};{Yvalue2}], 
    % max_Rs = [{Rvalue1};{Rvalue2}]
    % Xc = ??
    % Yc = ??
    % max_Rs = ??
    
    first = find(max(maxr) == maxr);
    max_Rs = [first(1);first(2)];

    Xc = [];
    Yc = [];
    [row, col] = find(max(max(Accumulator(:,:,max_Rs(1)))) == Accumulator(:,:,max_Rs(1)));
    Xc = [Xc; row(1)];
    Yc = [Yc; col(1)];
    [row, col] = find(max(max(Accumulator(:,:,max_Rs(2)))) == Accumulator(:,:,max_Rs(2)));
    Xc = [Xc; row(1)];
    Yc = [Yc; col(1)];
    max_Rs = r_min+(max_Rs-1);
 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Plot the results using red line
    figure;
    imshow(imgBW);title('Locate the circles');
    hold on;
    for i = 1:length(Xc)
        plot(Yc(i),Xc(i),'x','LineWidth',2,'Color','red');
        viscircles([Yc(i) Xc(i)], max_Rs(i),'EdgeColor','r');
    end
    

end