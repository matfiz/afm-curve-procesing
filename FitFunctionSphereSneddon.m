function result=FitFunctionSphereSneddon(const, xData, yData)% Implicit function: sphere in Sneddon model
    %start by fitting simpler Hertz for sphere to get initial starting
    %parameters
    initParams = FitFunctionSphereHertz(const, xData, yData);


    params0 = [initParams(1) initParams(2)];
    R = const(1);
    aData = FunctionSphereSneddonIndentation(R, xData);
    %force=FunctionSphereSneddon(const, params, aData)
    func= @(params, aData) FunctionSphereSneddon(const, params, aData); 
    params = nlinfit(aData,yData,func,params0);
    %x = lsqcurvefit(@(params, aData) FunctionSphereSneddon(const, params, aData),300, aData, yData) 
    El = params(1);
    y0 = params(2);
    result = [El y0];
end % close the function
%---------------------------------------------------------------------------------------