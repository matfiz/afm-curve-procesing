clc;
fid = fopen(fullfile('dane_di','komorka00014.021'),'r');
%pos = di_header_find_by_fid( fid ,  '\Trigger mode');
param = di_read_param(fid, '\Trigger mode')
fclose(fid);