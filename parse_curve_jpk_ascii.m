function curve=parse_curve_jpk_ascii(hObject,pathname,fname)
    curve = Curve;
    handles = guidata(hObject);
    try
        tfile = fopen(fullfile(pathname,fname),'r');
        Output_array = textscan(tfile, '%f %f %f %f %f %f', 'CommentStyle', '#');
        curve.dataHeight = Output_array{1};
        curve.dataDeflection = Output_array{2};
        curve.dataHeightMeasuredSmoothed = Output_array{3};
        curve.dataHeightMeasured = Output_array{4};
        curve.dataSeriesTime = Output_array{5};
        curve.dataSegmentTime = Output_array{1};
        fclose(tfile);
        tfile = fopen(fullfile(pathname,fname),'r');
        file_content_array = textscan(tfile,'%s','delimiter', '\n', 'whitespace', '');
        lines = file_content_array{1};
        fclose(tfile);
        curve.name = fname;
        %xPos
        IndexC = strfind(lines, 'xPosition:');
        Index = find(~cellfun('isempty', IndexC), 1);
        curve.xPos =  sscanf(lines{Index},'# xPosition: %f');
        %yPos
        IndexC = strfind(lines, 'yPosition:');
        Index = find(~cellfun('isempty', IndexC), 1);
        curve.yPos =  sscanf(lines{Index},'# yPosition: %f');
        %mode
        IndexC = strfind(lines, 'force-settings.z-start-pause-option.type:');
        Index = find(~cellfun('isempty', IndexC), 1);
        curve.mode =  sscanf(lines{Index},'# force-settings.z-start-pause-option.type: %s');
        %tutaj chyba jaki� b��d?
        if curve.mode == 'constant-height'
            curve.mode = 'constant-force';
        else
            curve.mode == 'constant-height';
        end
        %closed loop
        IndexC = strfind(lines, 'force-settings.closed-loop:');
        Index = find(~cellfun('isempty', IndexC), 1);
        curve.closedLoop =  sscanf(lines{Index},'# force-settings.closed-loop: %s');
        %sensitivity
        IndexC = strfind(lines, 'sensitivity:');
        Index = find(~cellfun('isempty', IndexC), 1);
        curve.sensitivity =  sscanf(lines{Index},'# sensitivity: %f');
        %springConstant
        IndexC = strfind(lines, 'springConstant:');
        Index = find(~cellfun('isempty', IndexC), 1);
        curve.springConstant =  sscanf(lines{Index},'# springConstant: %f');
        %scalingFactor
        curve.scalingFactor = curve.springConstant;
        %extendTime
        IndexC = strfind(lines, 'force-settings.extend-scan-time:');
        Index = find(~cellfun('isempty', IndexC), 1);
        curve.extendTime =  sscanf(lines{Index},'# force-settings.extend-scan-time: %f');
        %retractTime
        IndexC = strfind(lines, 'force-settings.retract-scan-time:');
        Index = find(~cellfun('isempty', IndexC), 1);
        curve.retractTime =  sscanf(lines{Index},'# force-settings.retract-scan-time: %f');
        %extendPauseTime
        IndexC = strfind(lines, 'force-settings.extended-pause-time:');
        Index = find(~cellfun('isempty', IndexC), 1);
        curve.extendPauseTime =  sscanf(lines{Index},'# force-settings.extended-pause-time: %f');
        %extendLength
        IndexC = strfind(lines, 'force-settings.extend-k-length:');
        Index = find(~cellfun('isempty', IndexC), 1);
        curve.extendLength =  sscanf(lines{Index},'# force-settings.extend-k-length: %f');
        %retractLength
        IndexC = strfind(lines, 'force-settings.retract-k-length:');
        Index = find(~cellfun('isempty', IndexC), 1);
        curve.retractLength =  sscanf(lines{Index},'# force-settings.retract-k-length: %f');
        %pauseLength
        IndexC = strfind(lines, 'force-settings.extended-pause-k-length:');
        Index = find(~cellfun('isempty', IndexC), 1);
        curve.pauseLength =  sscanf(lines{Index},'# force-settings.extended-pause-k-length: %u');
        %fancyNames
        IndexC = strfind(lines, 'fancyNames:');
        Index = find(~cellfun('isempty', IndexC), 1);
        [curve.fancyNames] =  sscanf(lines{Index},'# fancyNames: "%s" "%s" "%s" "%s" "%s" "%s"');
        %units
        IndexC = strfind(lines, 'units:');
        Index = find(~cellfun('isempty', IndexC), 1);
        [curve.units] =  sscanf(lines{Index},'# units: %c %c %c %c %c %c');
        %stress relaxation
        %fit stress relaxation
        if ~isempty(curve.dataSeriesTime)
            curve.StressRelaxationFitLength = floor(curve.pauseLength*handles.stress_fit_length/100);
            switch curve.mode
                case 'constant-height'
                        [StressRelaxationFit, parameters] = fit_stress_relaxation_params(curve);
                        curve.dataStressRelaxation = parameters;
                case 'constant-force'
                        [StressRelaxationFit, parameters] = fit_creep_compliance_params(curve);
                        curve.dataStressRelaxation = parameters;
            end
        end

    catch err
        ws=['File ' fname ' not found or in bad format'];
        uiwait(warndlg(ws,'Warning','modal'));
        success_flag=0;
        rethrow(err)
    end
