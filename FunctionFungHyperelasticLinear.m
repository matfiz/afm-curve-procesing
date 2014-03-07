function y=FunctionFungHyperelasticLinear(const, p, aData)% Implicit function: sphere in Sneddon model
% assign the parameters ...

%p(1);%ln(20*E/(9*(1-nu^2)))
%p(2);b


X = FunctionFungHyperelasticLog(const, aData);
xSize = size(X);
if ~all(isnan(p))
    y = p(1) + X(1,:) + p(2)*X(2,:);
else
    y = X(1,:);
end
if ~all(isfinite(y(:)))
   disp('something bad')
end

if all(isnan(y(:)))
   disp('something bad')
end
%y = real(y);
end % close the function
%---------------------------------------------------------------------------------------