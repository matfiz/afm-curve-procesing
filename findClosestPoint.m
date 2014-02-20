function Min = findClosestPoint(x,y,xData,yData)
    [a,index]=min((xData-x).^2+(yData-y).^2);
    Min = [xData(index(1)),yData(index(1)),index(1)];