function [c_img, dist_img, label_img, ridge_img, sep_img] = my_watershed(img)
    g = img;
    gc = imcomplement(g);  % Complement image
    D = bwdist(gc);  % distant tranform
    D = -D; % Inverse distance map
    
    % To Do:
    [Lin, numConns] = bwlabel(imregionalmin(D, 8), 8);

    %build dam
    sizeD = size(D);
    numelD = numel(D);
    L = uint16(Lin);

    connb = logical([1 1 1; 1 0 1; 1 1 1]);
    np = images.internal.coder.NeighborhoodProcessor(sizeD, connb); 
    np.updateInternalProperties();

    priorityq = images.internal.coder.FifoPriorityQueue(numelD);

    S = false(numelD,1);
    washed = 0;

    for i = 1:numelD
        if(L(i)~=washed)
            S(i) = true;
            neighbors = np.getNeighborIndices(i);
            for j = 1:numel(neighbors)
                if(~S(neighbors(j)) && L(neighbors(j))==washed)
                    S(neighbors(j)) = true;
                    priorityq.push(neighbors(j),D(neighbors(j)));
                end
            end
        end
    end

    while(~priorityq.isempty())
        [d,p] = priorityq.pop();
        state = false;
        label = washed;
        neighbors = np.getNeighborIndices(d);
        for j = 1:numel(neighbors)
            if(~state && L(neighbors(j))~=washed)
                if(label~=washed && L(neighbors(j))~=label)
                    state = true;
                else
                    label = double(L(neighbors(j)));
                end
            end
        end
        if(~state)
            L(d) = label;
            for j = 1:numel(neighbors)
                if (~S(neighbors(j)))
                    S(neighbors(j)) = true;
                    priorityq.push(neighbors(j), max(D(neighbors(j)),p));
                end
            end
        end
    end

    Lb=im2bw(L,0);
    Lb=imcomplement(Lb);

    %dilation 
    [sizex, sizey]=size(Lb);
    Di = Lb;
    for i = 2:sizex-1
        for j = 2:sizey-1
            if Lb(i-1, j-1)==1 || Lb(i-1, j)==1 ||Lb(i-1, j+1)==1 || Lb(i, j-1)==1 || Lb(i, j+1)==1 || Lb(i+1, j-1)==1 || Lb(i+1, j)==1 || Lb(i+1, j+1)==1
                Di(i, j) = 1;
            end
        end
    end
            
    
    
    L = L;  % L is a label matrix, 0 = ridge pixels/dam, integer>0 = unique label for each region
    w = Lb;  % Ridge pixels. If pixels in L=0, pixels in w=1.

    w = Di; % Dilated ridge pixels
    g2 = g-Di;  % superimposed image of dilated ridge lines and original binary image
    
    % return the results
    c_img = gc;
    dist_img = D;
    label_img = L;
    ridge_img = w;
    sep_img = g2;
    
end