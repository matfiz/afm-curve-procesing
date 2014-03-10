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
        curve.mode = jpk_read_param(fullfile(folder, 'header.properties'),'force-scan-series.header.force-settings.z-start-pause-option.type');
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
            curve.dataHeight = [hExtend; hPause; hRetract];
            curve.dataDeflection = [dExtend; dPause; dRetract];
            curve.dataHeightMeasuredSmoothed = curve.dataHeight;
            curve.dataHeightMeasured = curve.dataHeight;
            curve.dataSeriesTime = [linspace(0,curve.extendTime,curve.extendLength) linspace(curve.extendTime,curve.extendTime+curve.extendPauseTime,curve.pauseLength) linspace(curve.extendTime+curve.extendPauseTime,curve.extendTime+curve.extendPauseTime+curve.retractTime,curve.retractLength)]';
            curve.dataSegmentTime = [linspace(0,curve.extendTime,curve.extendLength) linspace(0,curve.extendPauseTime,curve.pauseLength) linspace(0,curve.retractTime,curve.retractLength)]';
        end
        curve.StressRelaxationFitLength = curve.pauseLength/2;
        [stress_fit, params] = fit_stress_relaxation_params(curve);
        curve.dataStressRelaxation = params;
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