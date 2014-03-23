function [stress_fit, params] = fit_creep_compliance_params(curve)
%funkcja docelowa
StressRelaxationFunction =  fittype('a0+a1*exp(x*tau1)+a2*exp(x*tau2)',...
    'coefficients',{'a0','a1','a2','tau1','tau2'},...
    'dependent','y',...
    'independent','x');
time_pause=curve.distance_time_pause;
fit_length = min([floor(curve.StressRelaxationFitLength),numel(time_pause(1,:)),8192]);
x_time_data=time_pause(1,1:fit_length);
y_time_data=time_pause(2,1:fit_length);
%suma dwóch eksponent
%najpierw dopasowuje Exp2, a uzyskane parametry wstawiam do w³aœciwej
%funkcji
Exp2Fit = fit(x_time_data',y_time_data','Exp2','TolFun',10^(-9),...
        'TolX',10^(-9),...
        'Robust','LAR',...
        'MaxIter',1000);
StressRelaxationFit = fit(x_time_data',y_time_data', StressRelaxationFunction,...
    'StartPoint',[0 Exp2Fit.a Exp2Fit.c Exp2Fit.b Exp2Fit.d],...
    'MaxIter',1000,...
    'Robust','Bisquare');

stress_fit = StressRelaxationFit;
%map results to vars
a0=StressRelaxationFit.a0;
a1=StressRelaxationFit.a1;
a2=StressRelaxationFit.a2;
tau1=StressRelaxationFit.tau1;
tau2=StressRelaxationFit.tau2;
params = [a0,a1,a2,tau1,tau2];
end