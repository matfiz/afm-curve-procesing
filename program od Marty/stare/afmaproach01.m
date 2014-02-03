function [p,fit]=afmaproach01(xdata,ydata)


%breakpoint
meanfirst=mean(ydata(1:30));
meanstd=std(ydata(1:30));
mask=abs(ydata-meanfirst)>3*meanstd;
gdzie=find(mask);

breakpoint0=xdata(gdzie(1));
b2_0=meanfirst;
a2_0=0.0;

a1_0=(ydata(gdzie(1))-ydata(end))/(xdata(gdzie(1))-xdata(end));
b1_0=ydata(end)-a1_0*xdata(end);
b1_0=2*b1_0;
p0=[a1_0 b1_0 a2_0 b2_0 0 breakpoint0];
%LB=[-inf -inf -inf -inf -inf breakpoint0-breakpoint0*1/100];
%UB=[inf inf inf inf inf breakpoint0+breakpoint0*1/100];
LB=[];UB=[];
[fit0]=afmaproachfun01(p0,xdata,ydata);
pause
p=lsqcurvefit('afmaproachfun01',p0,xdata,ydata,LB,UB,[],ydata);
[fit]=afmaproachfun01(p,xdata,ydata);