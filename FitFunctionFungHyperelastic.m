function param=FitFunctionFungHyperelastic(const, xData, yData)% Implicit function: sphere in Sneddon model
    R=const(1); %radius
    nu=const(2); %poisson ratio    
    params0 = [7 1];
    aData = FunctionFungHyperelasticIndentation(R, xData);
    if aData(1) == 0
       aData = aData(2:end);
       yData = yData(2:end);
    end
    yDataLog = log(yData);
    %A = dataset(X(:,1),X(:,2),yDataLog','VarNames',{'X1','X2','yDataLog'});
    %params = FunctionFungHyperelasticLog(const, params, aData);
    func = @(params, aData) FunctionFungHyperelasticLinear(const, params, aData);
    opt = optimset('display','off','TolFun',10^(-9),...
        'TolX',10^(-9),...
        'FunValCheck','Off');
    params = nlinfit(aData,yDataLog,func,params0,opt)
    %fitParams = lsqcurvefit(func,params0, aData, yDataLog); 
    %El = params(1);
    %hyper = params(2);
    El = exp(fitParams(1))*9*(1-nu.^2)/20;
    b = fitParams(2);
    param = [El, b];
end % close the function
%---------------------------------------------------------------------------------------