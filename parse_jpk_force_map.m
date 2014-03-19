function parse_jpk_force_map(hObject, pathname,fname)
    handles = guidata(hObject);
    try
        %unpack map to tmp folder
        mkdir(fullfile(pwd,'./tmp'),'map');
        t = unzip(fullfile(pathname,fname),fullfile(pwd,'./tmp/map/'));
        folder = fullfile(pwd,'tmp/map');
        %read number of curves
        no_of_curves = str2num(jpk_read_param(fullfile(folder, 'header.properties'),'force-scan-map.indexes.max'))
        handles.no_of_curves = no_of_curves;
        for i=1:no_of_curves+1
            disp(['curve ' num2str(i)]);
            handles.curves(i) = parse_jpk_force_map_curve(fullfile(folder,'index',num2str(i-1)),i-1);
            file_names{i} = ['Curve ' num2str(i)];
        end
        handles.current_curve_index = 1;
        handles.current_curve = handles.curves(1);
         
        handles.save = 0;
        set(handles.curve_list,'String', file_names);
        set(handles.previous_button,'Visible','On');
        set(handles.next_button,'Visible','On');
        set(handles.curve_list,'Visible','On');
        guidata(hObject,handles);
        read_to_gui(hObject,handles,1);
        try
            rmdir('tmp/map','s');
        catch err
        end;
    catch err
        ws=['File ' fname ' not found or in bad format'];
        uiwait(warndlg(ws,'Warning','modal'));
        success_flag=0;
        rethrow(err)
    end
