function [yout]=afmaproachfun01(p,xdata,ydata)
,


lin1=p(3)*xdata+p(4);
lin2=p(1)*xdata+p(2);
breakpoint=p(6);
quad=p(5)*xdata.^2;

yout=lin1.*(xdata>=breakpoint) + (quad+lin2).*(xdata<breakpoint);




plot(xdata,ydata,'.');
hold on
plot(xdata,yout,'r');
drawnow
hold off