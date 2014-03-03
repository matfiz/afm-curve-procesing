function El=FitFunctionSphereHertz(const, xData, yData)% Implicit function: sphere in Sneddon model
    params0 = [1000];
    func= @(params, xData) FunctionSphereHertz(const, params, xData); 
    params = nlinfit(xData,yData,func,params0);
    %x = lsqcurvefit(@(params, aData) FunctionSphereSneddon(const, params, aData),300, aData, yData) 
    El = params(1);
end % close the function
%---------------------------------------------------------------------------------------