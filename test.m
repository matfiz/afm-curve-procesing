close all;
clear all;
clc;
load('D:\Brzezinka\Dokumenty\doktoranckie\JPK\curve_processing\tmp\indentation_data.mat')
const = [2.5*10^(-6) 0.5];
aData = FunctionFungHyperelasticIndentation(const(1), xData);
if aData(1) == 0
   aData = aData(2:end);
   yData = yData(2:end);
end
yDataLog = log(yData);

params0 = [150 0.1];
func = @(params, aData) FunctionFungHyperelasticLinear(const, params, aData);
%params = nlinfit(aData,yDataLog,func,params0)
%plot(aData, yDataLog, aData, func(params0, aData))

%draw native function
func_orig = @(params, aData)FunctionFungHyperelastic(const, params, aData);

params = nlinfit(aData,yData,func_orig,params0)
plot(aData, yData, aData, func_orig(params0, aData),aData,func_orig(params, aData))