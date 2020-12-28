function [dam]=builddam(q,C_n_1)
    %q is one connected_com after flooding, and C_n_1 is all connected_comp in last step
    %do dilation for each connected component and label differently
    %return the dam
    c=(q.*C_n_1);%find the connected component that should be dilated 
    
    [connected_comp,num]=bwlabel(c,4);%find the number and label each of the connected component
    [sizeX,sizeY]=size(connected_comp);
    %dilation
    %dilate when there is still a point in q not labeled.
    is_end=0;
    old_dam=ones(sizeX,sizeY);
    dila=zeros(sizeX,sizeY);
    former_connected_comp=zeros(sizeX,sizeY);
    count=0;
    while(~is_end)
        count=count+1;
        for i=1:num
            %do dilation for each connected_component
            %each_dila=zeros(sizeX,sizeY);
            %the dilation array for this round
            [x,y]=find(connected_comp==i);%find the position for all the position of connected_component i
            temp=zeros(sizeX+2,sizeY+2);
            for j=1:length(x)
                temp(x(j):x(j)+2,y(j):y(j)+2)=1;                
            end
            each_dila=(q.*temp(2:sizeX+1,2:sizeY+1))*(2*i-1);
            dila=dila+each_dila;  
        end
        %imshow(dila>0,[]);
        dila=dila.*old_dam;
        
        is_end=isequal((dila>0),q.*old_dam);
        
        new_dam=1-(dila>0).*(1-mod(dila,2));
        old_dam=new_dam.*old_dam;
        q=q.*old_dam;
        %dam is the even point in matrix dila;
        %0 in dam means it is a dam
        %find the new connected_comp after one dilation;
        connected_comp=dila.*old_dam+1;
        connected_comp=(1-rem(connected_comp,2)).*connected_comp;
        connected_comp=connected_comp/2;
        dila=zeros(sizeX,sizeY);
        
        
        if(max(max(connected_comp)))>num && mod(count,2)
            if isequal(connected_comp,former_connected_comp)
                is_end=1;
                old_dam=connected_comp.*(connected_comp<num+1);
            end
            former_connected_comp=connected_comp;
        end
    end
    dam=bwlabel(old_dam,4);
end