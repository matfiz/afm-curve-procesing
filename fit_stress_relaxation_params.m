function [stress_fit, params] = fit_stress_relaxation_params(curve)
%funkcja docelowa
StressRelaxationFunction =  fittype('a0+a1*exp(-x/tau1)+a2*exp(-x/tau2)',...
    'coefficients',{'a0','a1','a2','tau1','tau2'},...
    'dependent','y',...
    'independent','x');
time_pause=curve.force_time_pause;
disp(curve.StressRelaxationFitLength);
fit_length = min([curve.StressRelaxationFitLength,numel(time_pause(1,:)),8192]);
x_time_data=time_pause(1,1:fit_length);
y_time_data=time_pause(2,1:fit_length);
%suma dwóch eksponent
%najpierw dopasowuje Exp2, a uzyskane parametry wstawiam do w³aœciwej
%funkcji
Exp2Fit = fit(x_time_data',y_time_data','Exp2');
StressRelaxationFit = fit(x_time_data',y_time_data', StressRelaxationFunction,...
    'StartPoint',[0 Exp2Fit.a Exp2Fit.c -1/Exp2Fit.b -1/Exp2Fit.d],...
    'MaxIter',1000,...
    'Robust','LAR');
stress_fit = StressRelaxationFit;
%map results to vars
a0=StressRelaxationFit.a0;
a1=StressRelaxationFit.a1;
a2=StressRelaxationFit.a2;
tau1=StressRelaxationFit.tau1;
tau2=StressRelaxationFit.tau2;
params = [a0,a1,a2,tau1,tau2];
end