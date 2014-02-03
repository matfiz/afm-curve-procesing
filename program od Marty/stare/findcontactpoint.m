function [z0]=findcontactpoint(x,y,treshold);
n=length(x);
curr=0;
i0=round(1/4*n);
for i=i0:1:n,
    curr=curr+1;
    x0=x(1:i);
    y0=y(1:i);
    p = polyfit(x0,y0,1);
    yout = polyval(p,x0);
    chi=1/(length(x0)-2)*sum( (yout-y0).^2/std(y(1:200)).^2); 
    r1(curr)=chi;
    z1(curr)=x(i);   
    
end
gdzie=find(r1>treshold);
z0=z1(gdzie(1))
mask=(abs(z0-x));
gdzie=find(mask==min(mask));
nz=gdzie(1);
