function [kurwyout]=remove_vert_offset(kurwy,zinput);


 
n=kurwy.n;
kurwyout=kurwy;


z=mean(kurwy.z_do);
mask=z<=zinput;
gdzie=find(mask);
nz=gdzie(1);


for i=1:n,
    tlo=0.5*mean(kurwy.F_do(i,1:nz)+kurwy.F_od(i,1:nz));
    kurwyout.F_do(i,:)=(kurwy.F_do(i,:)-tlo);
    kurwyout.F_od(i,:)=(kurwy.F_od(i,:)-tlo);

end