function [height dfl]=jpk_read_segment_raw(folder,segmentNumber,segmentLength)
    %read calibration parameters
        %height calibration
        calibration_file = fullfile(folder,'shared-data','header.properties');
        f_calibration = fopen(calibration_file);
        if f_calibration == -1
           calibration_file = fullfile(folder,'../../','shared-data','header.properties'); 
        else
            fclose(f_calibration)
        end
        HchannelName = jpk_read_param(calibration_file,'lcd-info.0.channel.name');
        HoffsetV = str2num(jpk_read_param(calibration_file,'lcd-info.0.encoder.scaling.offset'));
        HmultiplayerV = str2num(jpk_read_param(calibration_file,'lcd-info.0.encoder.scaling.multiplier'));
        HoffsetM = str2num(jpk_read_param(calibration_file,'lcd-info.0.conversion-set.conversion.nominal.scaling.offset'));
        HmultiplayerM = str2num(jpk_read_param(calibration_file,'lcd-info.0.conversion-set.conversion.nominal.scaling.multiplier'));
        
        %deflection  calibration
        Dcalibration_file = fullfile(folder,'shared-data','header.properties');
        DchannelName = jpk_read_param(calibration_file,'lcd-info.1.channel.name');
        DoffsetV = str2num(jpk_read_param(calibration_file,'lcd-info.1.encoder.scaling.offset'));
        DmultiplayerV = str2num(jpk_read_param(calibration_file,'lcd-info.1.encoder.scaling.multiplier'));
        DoffsetM = str2num(jpk_read_param(calibration_file,'lcd-info.1.conversion-set.conversion.distance.scaling.offset'));
        DmultiplayerM = str2num(jpk_read_param(calibration_file,'lcd-info.1.conversion-set.conversion.distance.scaling.multiplier'));
        DoffsetN = str2num(jpk_read_param(calibration_file,'lcd-info.1.conversion-set.conversion.force.scaling.offset'));
        DmultiplayerN = str2num(jpk_read_param(calibration_file,'lcd-info.1.conversion-set.conversion.force.scaling.multiplier'));
    
    %read height
        fid = fopen(fullfile(folder,'segments', num2str(segmentNumber), 'channels\height.dat'));
        heightRAW = fread(fid,[segmentLength 1],'integer*4','ieee-be');
        fclose(fid);
        heightV = HoffsetV + heightRAW.*HmultiplayerV;%in Volts
        heightM = HoffsetM + heightV.*HmultiplayerM;%in meters
    %read deflection
        fid = fopen(fullfile(folder,'segments', num2str(segmentNumber), 'channels\vDeflection.dat'));
        dflRAW = fread(fid,[segmentLength 1],'integer*4','ieee-be');
        fclose(fid);
        dflV = DoffsetV + dflRAW.*DmultiplayerV;
        dflM = DoffsetM + dflV.*DmultiplayerM;
        dflN = DoffsetN + dflM.*DmultiplayerN;
    %assign output
        height = heightM;
        dfl = dflN;
        