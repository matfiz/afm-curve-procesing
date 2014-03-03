function param=FitFunctionFungHyperelastic(const, xData, yData)% Implicit function: sphere in Sneddon model
    R=const(1); %radius
    nu=const(2); %poisson ratio    
    params0 = [log(20*300/4.5) 1];
    yDataLog = log(yData);
    aData = FunctionFungHyperelasticIndentation(R, xData);
    if aData(1) == 0
       aData = aData(2:end);
       yDataLog = yData(2:end);
    end
    func= @(params, aData) FunctionFungHyperelasticLog(const, params, aData); 
    params = nlinfit(aData,yDataLog,func,params0);
    %x = lsqcurvefit(@(params, aData) FunctionSphereSneddon(const, params, aData),300, aData, yData) 
    %El = params(1);
    %hyper = params(2);
    El = exp(params(1))*9*(1-nu.^2)/20;
    b = params(2);
    param = [El, b];
end % close the function
%---------------------------------------------------------------------------------------