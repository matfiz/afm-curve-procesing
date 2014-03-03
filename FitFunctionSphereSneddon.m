function El=FitFunctionSphereSneddon(const, xData, yData)% Implicit function: sphere in Sneddon model
    params0 = [300];
    R = const(1);
    aData = FunctionSphereSneddonIndentation(R, xData);
    %force=FunctionSphereSneddon(const, params, aData)
    func= @(params, aData) FunctionSphereSneddon(const, params, aData); 
    params = nlinfit(aData,yData,func,params0);
    %x = lsqcurvefit(@(params, aData) FunctionSphereSneddon(const, params, aData),300, aData, yData) 
    El = params(1);
end % close the function
%---------------------------------------------------------------------------------------