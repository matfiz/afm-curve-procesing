function curve=parse_raw_curve_multi_mode(pathname,fname)
%parameters:
%   params
%       xPos
%       yPos
%       mode(constant-height,...)
%       closedLoop (true/false)
%       sensitivity
%       springConstant
%       extendTime
%       retractTime
%       extendPauseTime
%   data
%       height
%       deflection
%       time

success_flag=1;
curve = Curve; %initiate Curve object from class
try
    if di_version(fullfile(pathname,fname)) == 6
        Output_array = di_open_fd(fullfile(pathname,fname));
        curve.dataHeight = [Output_array(:,1);Output_array(:,2)];
        curve.dataHeightMeasured = [Output_array(:,1);Output_array(:,2)];
        curve.dataDeflection = [Output_array(:,3);Output_array(:,4)]*10^(-9);
        curve.name = fname;     

        %pos_spl = di_header_find(file_name,'\Samps/line');
        %pos_data = di_header_find(file_name,'\Data offset');
        %scal_data = di_header_find(file_name,'\@4:Z scale: V [Sens.');
        fid = fopen(fullfile(pathname,fname),'r');
        %xPos
        curve.xPos =  0;
        %yPos
        curve.yPos =  0;
        %mode 
        curve.mode =  di_read_param(fid,'\Trigger mode');
        %closed loop
        z_closed_loop = di_read_param(fid,'\Z Closed Loop');
        if (strcmpi(z_closed_loop,'off'))
            curve.closedLoop =  'false';
        else
            curve.closedLoop =  'true';
        end
        %sensitivity
        curve.sensitivity =  di_read_param(fid,'\@Sens. DeflSens');
        %springConstant 
        curve.springConstant =  di_read_param(fid,'\Spring Constant');
        %extendTime
        curve.extendTime =  1;
        %retractTime
        curve.retractTime =  1;
        %extendPauseTime
        curve.extendPauseTime =  0;
        %extendLength 
        %curve.extendLength =  di_read_param(fid,'\Samps/line, retrace');
        curve.extendLength = length(curve.dataDeflection)/2;
        %retractLength
        
        %curve.retractLength =  di_read_param(fid,'\Samps/line, retrace');
        curve.retractLength = curve.extendLength;
        %pauseLength
        curve.pauseLength =  0;
        curve.hasStressRelaxation = 0;
        
        fclose(fid);
    end
    
catch err
    ws=['File ' fname ' not found or in bad format'];
    uiwait(warndlg(ws,'Warning','modal'));
    success_flag=0;
    rethrow(err);
end