function logforce=FunctionFungHyperelasticLog(c, p, a)% Implicit function: sphere in Sneddon model
% assign the parameters ...

%p(1);%20*E/(9*(1-nu^2))
%p(2);b

R=c(1); %radius
nu=c(2); %poisson ratio

logforce=zeros(size(a)); % define a vector to allocate the magnetization values
NN=length(a); % total length of the field vector x, i.e. B
if a(1) == 0
    a(1) = 10^(-9);
end
%a = FunctionSphereSneddonIndentation(R, abs(delta) );
for i=1:NN    
   logforce(i)= p(1)+log((a(i)^5-15*R*a(i)^4+75*R^2*a(i)^3)/(5*R*a(i)^2-50*R^2*a(i)+125*R^3)) + p(2)*((a(i)^3-15*R*a(i)^2)/(25*R^2*a(i)-125*R^3));
end
if ~all(isfinite(logforce(:)))
   disp('something bad')
end
logforce = real(logforce);
end % close the function
%---------------------------------------------------------------------------------------