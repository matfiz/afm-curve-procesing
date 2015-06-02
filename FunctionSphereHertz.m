function force=FunctionSphereHertz(c, p, delta)% Implicit function: sphere in Sneddon model
% F = El/(1-nu^2) * ((R^2 + a^2 )/2 * Log((R+a)/(R-a))- a*R)
% assign the parameters ...

El=p(1);%elasticity parameter
y0=p(2);%vertical shift

R=c(1); %radius
nu=c(2); %poisson ratio

delta = abs(delta);

force=zeros(size(delta)); % define a vector to allocate the magnetization values
NN=length(delta); % total length of the field vector x, i.e. B
%a = FunctionSphereSneddonIndentation(R, abs(delta) );
for i=1:NN    
   force(i)= 4/3 * El/(1-nu.^2) * sqrt(R) * (delta(i)).^(3/2) + y0;
end

end % close the function
%---------------------------------------------------------------------------------------