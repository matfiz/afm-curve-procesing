function a=FunctionFungHyperelasticIndentation(R, delta)% Implicit function: sphere in Sneddon model
% delta = a/2 * Log((R+a)/(R-a))
% R - radius
% delta - indentation vector
% a - contact radius vector

a=zeros(size(delta)); % define a vector to allocate the magnetization values
NN=length(delta); % total length of the field vector x, i.e. B

for i=1:NN    
   a(i)=sqrt(R*abs(delta(i)));
end
end % close the function
%---------------------------------------------------------------------------------------