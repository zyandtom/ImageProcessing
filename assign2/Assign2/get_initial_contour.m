function splinePoints = get_initial_contour(img, numPoints)

% Reference Ritwik Kumar, Harvard University 2010
%           www.seas.harvard.edu/~rkkumar

figure, imshow(img)

X = [];
Y = [];
count = 1;

while count < numPoints
    [x,y,button]=ginput(1);
    X = [X x];
    Y = [Y y];
    hold on
    plot(x,y,'ro');
    if(button==3)
        break; 
    end
    count = count+1;
end
X = [X X(1)];
Y = [Y Y(1)];
controlPoints = [X; Y];


splinePoints = spline(1:count+1,controlPoints,1:0.1:count+1);

hold on
plot(X(1),Y(1),'ro',splinePoints(1,:),splinePoints(2,:),'b.');

end