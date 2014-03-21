function curve=parse_curve_jpk_raw(pathname,fname)
    curve = Curve;
    try
        %unpack curve to tmp folder
        mkdir('./tmp','curve');
        t = unzip(fullfile(pathname,fname),'./tmp/curve');
        folder = './tmp/curve';
        %read number of segments
        numberOfSegments = str2num(jpk_read_param(fullfile(folder, 'header.properties'),'force-scan-series.force-segments.count'));
        curve.name = fname;
        curve.xPos = str2num(jpk_read_param(fullfile(folder, 'header.properties'),'force-scan-series.header.position.x'));
        curve.yPos = str2num(jpk_read_param(fullfile(folder, 'header.properties'),'force-scan-series.header.position.y'));
        %read mode of 2nd segment (pause)
        mode = jpk_read_param(fullfile(folder, 'segments','1','segment-header.properties'),'force-segment-header.settings.segment-settings.type');
        switch mode 
            case 'constant-force-pause'
                curve.mode = 'constant-force';
            case 'constant-height-pause'
                curve.mode = 'constant-height';
            otherwise
                curve.mode = 'no-pause';
        end
        curve.closedLoop = jpk_read_param(fullfile(folder, 'header.properties'),'force-scan-series.header.force-settings.closed-loop');
        curve.sensitivity = str2num(jpk_read_param(fullfile(folder,'shared-data', 'header.properties'),'lcd-info.1.conversion-set.conversion.distance.scaling.multiplier'));
        curve.springConstant = str2num(jpk_read_param(fullfile(folder,'shared-data', 'header.properties'),'lcd-info.1.conversion-set.conversion.force.scaling.multiplier'));
        curve.extendTime = str2num(jpk_read_param(fullfile(folder, 'header.properties'),'force-scan-series.header.force-settings.extend-scan-time'));
        curve.retractTime = str2num(jpk_read_param(fullfile(folder, 'header.properties'),'force-scan-series.header.force-settings.retract-scan-time'));
        curve.extendPauseTime = str2num(jpk_read_param(fullfile(folder, 'header.properties'),'force-scan-series.header.force-settings.extended-pause-time'));
        curve.scalingFactor = curve.springConstant;
        %read Other Params
        if numberOfSegments == 2
            curve.extendLength = str2num(jpk_read_param(fullfile(folder, 'header.properties'),'force-scan-series.header.force-settings.extend-k-length'));
            curve.retractLength = str2num(jpk_read_param(fullfile(folder, 'header.properties'),'force-scan-series.header.force-settings.retract-k-length'));
            [hExtend dExtend] = jpk_read_segment_raw(folder,0,curve.extendLength);
            [hRetract dRetract] = jpk_read_segment_raw(folder,1,curve.retractLength);
            %we have to correct no points to the real numbers (sometimes
            %points are missing in data)
                curve.extendLength = length(hExtend);
                curve.retractLength = length(hRetract);
            curve.dataHeight = [hExtend; hRetract];
            curve.dataDeflection = [dExtend; dRetract];
            curve.dataHeightMeasuredSmoothed = curve.dataHeight;
            curve.dataHeightMeasured = curve.dataHeight;
            curve.dataSeriesTime = [linspace(0,curve.extendTime,curve.extendLength) linspace(curve.extendTime,curve.extendTime+curve.retractTime,curve.retractLength)];
            curve.dataSegmentTime = [linspace(0,curve.extendTime,curve.extendLength) linspace(0,curve.retractTime,curve.retractLength)]';
        else
            curve.extendLength = str2num(jpk_read_param(fullfile(folder, 'header.properties'),'force-scan-series.header.force-settings.extend-k-length'));
            curve.pauseLength = str2num(jpk_read_param(fullfile(folder, 'header.properties'),'force-scan-series.header.force-settings.extended-pause-k-length'));
            curve.retractLength = str2num(jpk_read_param(fullfile(folder, 'header.properties'),'force-scan-series.header.force-settings.retract-k-length'));
            [hExtend dExtend] = jpk_read_segment_raw(folder,0,curve.extendLength);
            [hPause dPause] = jpk_read_segment_raw(folder,1,curve.pauseLength);
            [hRetract dRetract] = jpk_read_segment_raw(folder,2,curve.retractLength);
            %we have to correct no points to the real numbers (sometimes
            %points are missing in data)
                curve.extendLength = length(hExtend);
                curve.retractLength = length(hRetract);
            curve.dataHeight = [hExtend; hPause; hRetract];
            curve.dataDeflection = [dExtend; dPause; dRetract];
            curve.dataHeightMeasuredSmoothed = curve.dataHeight;
            curve.dataHeightMeasured = curve.dataHeight;
            curve.dataSeriesTime = [linspace(0,curve.extendTime,curve.extendLength) linspace(curve.extendTime,curve.extendTime+curve.extendPauseTime,curve.pauseLength) linspace(curve.extendTime+curve.extendPauseTime,curve.extendTime+curve.extendPauseTime+curve.retractTime,curve.retractLength)]';
            curve.dataSegmentTime = [linspace(0,curve.extendTime,curve.extendLength) linspace(0,curve.extendPauseTime,curve.pauseLength) linspace(0,curve.retractTime,curve.retractLength)]';
            curve.pauseLength = length(hPause);
        end
        %fit stress relaxation
        if ~isempty(curve.dataSeriesTime)
            curve.StressRelaxationFitLength = floor(curve.pauseLength*0.75);
            switch curve.mode
                case 'constant-height'
                        [StressRelaxationFit, parameters] = fit_stress_relaxation_params(curve);
                case 'constant-force'
                        [StressRelaxationFit, parameters] = fit_creep_compliance_params(curve);
            end
            curve.dataStressRelaxation = parameters;
        end
        try
            rmdir('tmp/curve','s');
        catch err
        end;
    catch err
        ws=['File ' fname ' not found or in bad format'];
        uiwait(warndlg(ws,'Warning','modal'));
        success_flag=0;
        rethrow(err)
    end
