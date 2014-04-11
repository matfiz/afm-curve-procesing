function param=FitFunctionSokolovHertzSphere(const, xData, yData)
    params0 = [1000 xData(1)];
    func = @(params,xData) FunctionSokolovForceReduced(params, const, xData);
    %fit options
    opt = optimset('TolX',1e-12,...
                    'TolFun',1e-12);
    fitParams = nlinfit(xData,yData,func,params0,opt);
    %x = lsqcurvefit(@(params, aData) FunctionSphereSneddon(const, params, aData),300, aData, yData) 
    param = fitParams;
    
end % close the function
%---------------------------------------------------------------------------------------