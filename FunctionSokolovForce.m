function force=FunctionSokolovForce(p, c, Z)% Implicit function: sphere in Sneddon model
R=c(1); %radius
nu=c(2); %poisson ratio
k = c(3); %spring constant

El = p(1);
Z0 = p(2);

force=zeros(size(Z)); % define a vector to allocate the magnetization values
NN=length(Z); % total length of the field vector x, i.e. B

opt = optimset('display','none','TolFun',10^(-12),'TolX',10^(-12));
% I out off all the messages coming from fzero. If something goes wrong, change this option to 'off' 
% to see at which x values fzero failed.
%warning ('off','all');
for i=1:NN    
   %original equation
   func = @(F) Z0 - F/k - Z(i) - F^(2/3) * (9/16 * 1/El * sqrt(1/R))^(2/3);
   force(i)=fsolve(func, 1*10^(-11), opt);
end
force = real(force);
warning ('on','all');
end % close the function
%---------------------------------------------------------------------------------------