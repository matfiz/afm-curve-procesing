function [minvalue_do,minvalue_od,maxvalue_do,maxvalue_od,t_do,t_od,z_do,z_od,F_do,F_od]=readkurwy;



[FileName1,PathName] = uigetfile('*.*');
[FileName1,PathName] = uigetfile('*.*');



n=length(list);

figure 
ii=1;
for i=1:n,
   
    fname=[prefix num2str(list(i))]
    
    [s,t_doi,z_doi,F_doi,t_odi,z_odi,F_odi]=readafmcurve(fname);
    
    if (s)  && (length(t_doi)>10) 
    tlo=F_doi(1);
    F_doi=F_doi-tlo;
    F_odi=F_odi-tlo;

    t_do(ii,:)=t_doi';
    z_do(ii,:)=z_doi';
    F_do(ii,:)=F_doi';
    t_od(ii,:)=t_odi';
    z_od(ii,:)=z_odi';
    F_od(ii,:)=F_odi';
     
   
     minvaluei_od=min(F_odi);
    minvaluei_do=min(F_doi);
    maxvaluei_od=max(F_odi);
    maxvaluei_do=max(F_doi);
    
   
   
   plot(z_odi,F_odi,'r');
   hold on
   plot(z_doi,F_doi,'b');
   plot( [min(z_doi) max(z_doi)],[minvaluei_od minvaluei_od],'k');
   minvaluei_od
   
   drawnow
   pause
   minvalue_od(i)=minvaluei_od;
   minvalue_do(i)=minvaluei_do;
   maxvalue_od(i)=maxvaluei_od;
   maxvalue_do(i)=maxvaluei_do;
   
   hold off   
   ii=ii+1;
end
end