function a=FunctionSphereSneddonIndentation(R, delta)% Implicit function: sphere in Sneddon model
% delta = a/2 * Log((R+a)/(R-a))
% R - radius
% delta - indentation vector
% a - contact radius vector

a=zeros(size(delta)); % define a vector to allocate the magnetization values
NN=length(delta); % total length of the field vector x, i.e. B

opt = optimset('display','none','TolFun',10^(-12),'TolX',10^(-12));
% I out off all the messages coming from fzero. If something goes wrong, change this option to 'off' 
% to see at which x values fzero failed.
%warning ('off','all');
R=R;
for i=1:NN    
   %original equation
   indentation = @(p) abs(delta(i)) - 0.5 * p * log((R+p)/(R-p));
   %Taylor series around 0 up to 20 range
   %indentation_taylor_20 = @(a) abs(delta(i))-a^2/R+a^4/(3*R^3)+a^6/(5*R^5)+a^8/(7*R^7)+a^10/(9*R^9)+a^12/(11*R^11)+a^14/(13*R^13)+a^16/(15*R^15)+a^18/(17*R^17)+a^20/(19*R^19);
   a(i)=fsolve(indentation, 1.58*10^(-7), opt);
   %a(i)=fsolve(indentation_taylor_20, 1.58*10^(-7), opt)
   % a(i)=fzero(@(a) delta - 0.5 * a * log((R+a)/(R-a)), 0.0001, opt); 
   % Here 0.0001 is our starting point to find the solution around 0.
end
a = real(a);
warning ('on','all');
end % close the function
%---------------------------------------------------------------------------------------