function force=FunctionSphereSneddon(c, p, a)% Implicit function: sphere in Sneddon model
% F = El/(1-nu^2) * ((R^2 + a^2 )/2 * Log((R+a)/(R-a))- a*R)
% assign the parameters ...

El=p(1);%elasticity parameter

R=c(1); %radius
nu=c(2); %poisson ratio


force=zeros(size(a)); % define a vector to allocate the magnetization values
NN=length(a); % total length of the field vector x, i.e. B
%a = FunctionSphereSneddonIndentation(R, abs(delta) );
for i=1:NN    
   force(i)= El/(1-nu.^2) * (0.5*(R.^2 + a(i).^2 ) * log((R+a(i))/(R-a(i)))- a(i)*R);
end

end % close the function
%---------------------------------------------------------------------------------------