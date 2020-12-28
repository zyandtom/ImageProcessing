function [bw,c_img, dist_img, label_img, ridge_img, sep_img] = my_watershed(img)

    g = img;
    gc = imcomplement(g);  % Complement image
    D = bwdist(gc);  % distant tranform
    D = -D; % Inverse distance map
    
%     To Do:
%     L = ;  % L is a label matrix, 0 = ridge pixels/dam, integer>0 = unique label for each region
%     w = ;  % Ridge pixels. If pixels in L=0, pixels in w=1.
% 
%     w = ; % Dilated ridge pixels
%     g2 = ;  % superimposed image of dilated ridge lines and original binary image
%     
    
    
    % input_img = img
    % f=rgb2gray(input_img);
    img_gray=img;
    % img_gray__=img_gray

    se = strel('disk',2);
    Ie = imerode(img_gray, se);
    Iobr = imreconstruct(Ie, img_gray);
    Iobrd = imdilate(Iobr, se);
    Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
    Iobrcbr = imcomplement(Iobrcbr);
    bw = im2bw(Iobrcbr, graythresh(Iobrcbr));
    D = bwdist(bw);
    D1 = D
%     figure
%     imshow(D)
%     figure
    D=uint8(D);
%     imshow(D)
    img = D;

    threshold=255;  

    [height,width] = size(img);
    minImg=min(min(img));
    maxImg=max(max(img));
    C=zeros(height,width);
    C1=zeros(height,width);
    water_line=zeros(height,width);



    for nn=1:maxImg-minImg+1
        [indX indY]=find(img<minImg+nn); 
        for m=1:length(indX)
            C(indX(m),indY(m))=1;
        end
        [Label num]=bwlabel(C,8);

        [indX1 indY1]=find(img<minImg+nn+1);
        for n=1:length(indX1)
            C1(indX1(n),indY1(n))=1;
        end
        [Label1 num1]=bwlabel(C1,8);
        
        if nn == 2
            sepimg_origin = C;
        end
%         figure
%         subplot(2,2,1),imshow(C);
%         subplot(2,2,2),imshow(C1);
%         subplot(2,2,3),imagesc(Label);title('Label Image');
        % check if the number of connecting components decrease
        if num==num1        
            continue
        end
        %find the label location in C and C1
        for i=1:num
            subimg(:,:,i)=(Label==i);
        end
        for i=1:num1
            subimg1(:,:,i)=(Label1==i);
        end
        
        
        
        % find if the next connecting components in the image include more
        % than one previous connecting components! 
        % If it does, then go to the mydilation function to build the
        % dam!
        include_img=zeros(1,num1);
        
        sub_img_before=zeros([size(img) num1]);
        for k=1:num
            for kk=1:num1
                is_equ=isequal(subimg(:,:,k)&subimg1(:,:,kk),subimg(:,:,k));
                if is_equ
                    include_img(kk)=include_img(kk)+1;
                    sub_img_before(:,:,kk)=sub_img_before(:,:,kk)+subimg(:,:,k);  %record the location of corresponding connected components to build the dam!
                    break                                                         %k represents different connected parts!
                end
            end
        end

        for m=1:num1
            if include_img(m)>1
                [Label_exam num_exam]=bwlabel(sub_img_before(:,:,m),8);
                water_line=water_line+myDilation(Label_exam,subimg1(:,:,m),threshold);  %myDilation function
            end
        end


        img_add_temp=(water_line~=0);
        img_add_temp=uint8(~img_add_temp);
        img=img.*img_add_temp+uint8(water_line);
    end
    
%     figure
%     subplot(2,3,3),imshow(water_line)    
%     subplot(2,3,4),imagesc(Label);title('Label Image');
%     subplot(2,3,5),imshow(sepimg_origin+water_line)
    % return the results
    c_img = gc;
    dist_img = D;
    label_img = Label;
    ridge_img = water_line;
    sep_img = uint8(255*sepimg_origin)+uint8(water_line);


end