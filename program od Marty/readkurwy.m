function [kurwy]=readkurwy(handles);


[prefix,list]=makelist;
if (prefix) 
    n=length(list);
    ii=1;
     h = waitbar(0,'Please wait! Loading ...','WindowStyle','modal') ;
    for i=1:n,
        drawnow
        fname=[prefix num2str(list(i))];
        [s,t_doi,z_doi,F_doi,t_odi,z_odi,F_odi]=readafmcurve(fname);
        if (s)  && (length(t_doi)>10) 
            kurwy.t_do(ii,:)=t_doi';
            kurwy.z_do(ii,:)=z_doi';
            kurwy.F_do(ii,:)=F_doi';
            kurwy.t_od(ii,:)=t_odi';
            kurwy.z_od(ii,:)=z_odi';
            kurwy.F_od(ii,:)=F_odi';
            kurwy.fname{ii}=fname;
            ii=ii+1;
            waitbar(i/n,h)     
        end
    end
    kurwy.n=ii-1;
    close(h)
else
    kurwy=0;
end