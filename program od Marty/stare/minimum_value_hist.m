function [xhist_min_val,nhist_min_val]=minimum_value_hist(handles,nbins)
krzywe=handles.krzywe;
n=krzywe.n;
for i=1:n,
   
   minvaluei_od(i)=min(krzywe.F_od(i,:));
end

[nhist_min_val,xhist_min_val]=hist(minvaluei_od,nbins);
