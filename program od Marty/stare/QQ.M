n=length(x);
clear r1 r2 z1
curr=0;
for i=100:5:n-50,
    curr=curr+1;
    i
    x0=x(1:i);
    y0=y(1:i);
    subplot(2,1,1);
    plot(x0,y0,'og');
    hold on
    p = polyfit(x0,y0,1);
    yout = polyval(p,x0);
    plot(x,y,'.')
    hold off
    hold on
    plot(x0,yout,'r');
    hold off
    chi=1/(length(x0)-2)*sum( (yout-y0).^2/std(y(1:200)).^2)
       
    r1(curr)=chi;
    z1(curr)=x(i);   
    subplot(2,1,2);
    plot(r1);
    drawnow    
    
end
gdzie=find(r1>1.02);
z0=z1(gdzie(1));

mask=(abs(z0-x));
gdzie=find(mask==min(mask));
nz=gdzie(1);

subplot(2,1,1);
hold on
plot([z0 z0],[min(y) max(y)],'r');

x0=x(1:nz);
y0=y(1:nz);
p = polyfit(x0,y0,1);
yout = polyval(p,x0);
plot(x0,yout,'k');
 