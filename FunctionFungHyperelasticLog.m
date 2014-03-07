function X=FunctionFungHyperelasticLog(c, a)% Implicit function: sphere in Sneddon model
% assign the parameters ...

%p(1);%20*E/(9*(1-nu^2))
%p(2);b

R=c(1); %radius
nu=c(2); %poisson ratio

X=zeros([2,size(a)]); % define a vector to allocate the magnetization values
NN=length(a); % total length of the field vector x, i.e. B

for i=1:NN    
   X(1,i)= log((a(i)^5-15*R*a(i)^4+75*R^2*a(i)^3)/(5*R*a(i)^2-50*R^2*a(i)+125*R^3));
   X(2,i)= ((a(i)^3-15*R*a(i)^2)/(25*R^2*a(i)-125*R^3));
end
if ~all(isfinite(X(:)))
   disp('something bad')
end
X = real(X);
end % close the function
%---------------------------------------------------------------------------------------