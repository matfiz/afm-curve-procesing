function force=FunctionFungHyperelastic(c, p, a)% Implicit function: sphere in Sneddon model
% assign the parameters ...

El=p(1);%elasticity parameter
hyp=p(2);%hyperelastic parameter
y0=p(3);

R=c(1); %radius
nu=c(2); %poisson ratio


force=zeros(size(a)); % define a vector to allocate the magnetization values
NN=length(a); % total length of the field vector x, i.e. B
%a = FunctionSphereSneddonIndentation(R, abs(delta) );
for i=1:NN    
   force(i)= y0 + 20*El/(9*(1-nu^2)) * ((a(i)^5-15*R*a(i)^4+75*R^2*a(i)^3)/(5*R*a(i)^2-50*R^2*a(i)+125*R^3))*exp(hyp*((a(i)^3-15*R*a(i)^2)/(25*R^2*a(i)-125*R^3)));
end

end % close the function
%---------------------------------------------------------------------------------------