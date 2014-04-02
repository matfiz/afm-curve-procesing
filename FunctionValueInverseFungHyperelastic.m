function indentation=FunctionValueInverseFungHyperelastic(c, p, F)
% assign the parameters ...

El=p(1);%elasticity parameter
hyp=p(2);%hyperelastic parameter
y0=p(3);

R=c(1); %radius
nu=c(2); %poisson ratio

%a = FunctionSphereSneddonIndentation(R, abs(delta) );

%func = @(a) abs(F) - y0 - 20*El/(9*(1-nu^2)) * ((abs(a)^5-15*R*abs(a)^4+75*R^2*abs(a)^3)/(5*R*abs(a)^2-50*R^2*abs(a)+125*R^3))*exp(hyp*((abs(a)^3-15*R*abs(a)^2)/(25*R^2*abs(a)-125*R^3)));
func = @(a) F - FunctionFungHyperelastic(c, p, a)+y0;
area = fzero(func, [0 5e-06]);

indentation = area^2/R;

end % close the function
%---------------------------------------------------------------------------------------