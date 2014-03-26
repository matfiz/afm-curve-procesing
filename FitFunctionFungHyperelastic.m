function param=FitFunctionFungHyperelastic(const, xData, yData)
    R=const(1); %radius
    nu=const(2); %poisson ratio    
    params0 = [150 0.1 0];
    aData = FunctionFungHyperelasticIndentation(R, xData);
    %fitowanie po linearyzacji
    %if aData(1) == 0
    %   aData = aData(2:end);
    %   yData = yData(2:end);
    %end
    %yDataLog = log(yData);
    %func = @(params, aData) FunctionFungHyperelasticLinear(const, params, aData);
    opt = optimset('display','off','TolFun',10^(-9),...
        'TolX',10^(-9),...
        'FunValCheck','Off');
    %params = nlinfit(aData,yDataLog,func,params0,opt)
    %fitParams = lsqcurvefit(func,params0, aData, yDataLog); 
    %El = params(1);
    %hyper = params(2);
    %El = exp(fitParams(1))*9*(1-nu.^2)/20;
    %b = fitParams(2);
    %fitowanie zwykle
    func = @(params, aData)FunctionFungHyperelastic(const, params, aData);
    fitParams = nlinfit(aData,yData,func,params0,opt);
    El = fitParams(1);
    b = fitParams(2);
    y0 = fitParams(3);
    param = [El, b, y0];
end % close the function
%---------------------------------------------------------------------------------------