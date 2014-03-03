function param=FitFunctionFungHyperelastic(const, xData, yData)% Implicit function: sphere in Sneddon model
    R=const(1); %radius
    nu=const(2); %poisson ratio    
    params0 = [1 1];
    yDataLog = log(yData);
    aData = FunctionFungHyperelasticIndentation(R, xData);
    if aData(1) == 0
       aData = aData(2:end);
       yDataLog = yData(2:end);
    end
    X = FunctionFungHyperelasticLog(const, aData);
    %A = dataset(X(:,1),X(:,2),yDataLog','VarNames',{'X1','X2','yDataLog'});
    %params = FunctionFungHyperelasticLog(const, params, aData);
    func = @(params, X) params(1) + X(1,:) + params(2)*X(1,:);
    fitParams = nlinfit(X',yDataLog,func,params0)
    %fitParams = lsqcurvefit(func,params0, aData, yDataLog'); 
    %El = params(1);
    %hyper = params(2);
    El = exp(fitParams(1))*9*(1-nu.^2)/20;
    b = fitParams(2);
    param = [El, b];
end % close the function
%---------------------------------------------------------------------------------------