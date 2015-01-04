clc;
fid = fopen(fullfile('dane_di','kontrkulka00000.000'),'r');
%pos = di_header_find_by_fid( fid ,  '\Trigger mode');
%param = di_read_param(fid, '\Trigger mode')
curve = Curve;
Output_array = di_open_fd(fullfile('dane_di','kontrkulka00000.000'));
        curve.dataHeight = [Output_array(:,1);Output_array(:,2)]*10^(-9);
        curve.dataHeightMeasured = [Output_array(:,1);Output_array(:,2)]*10^(-9);
        curve.dataDeflection = [Output_array(:,3);Output_array(:,4)]*10^(-9);     
fclose(fid);