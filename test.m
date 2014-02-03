close all;
clear all;
clc;
curve = parse_curve('./','jpk.txt');
approach_curve = curve.force_distance_approach;
retract_curve = curve.force_distance_retract;
time_pause=curve.force_time_pause;

x_time_data=time_pause(1,:);
y_time_data=time_pause(2,:);


StressRelaxationFunction =  fittype('a0+a1*exp(-x/tau1)+a2*exp(-x/tau2)',...
    'coefficients',{'a0','a1','a2','tau1','tau2'},...
    'dependent','y',...
    'independent','x');
Exp2Fit = fit(x_time_data',y_time_data','Exp2')            
StressRelaxationFit = fit(x_time_data',y_time_data', StressRelaxationFunction,...
    'StartPoint',[0 Exp2Fit.a Exp2Fit.c -1/Exp2Fit.b -1/Exp2Fit.d],...
    'MaxIter',1000,...
    'Robust','LAR');

plot(StressRelaxationFit,x_time_data,y_time_data);