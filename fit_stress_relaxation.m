function fit_stress_relaxation(hObject,mainObj,curve_number)
%read handles
handles=guidata(hObject);
handlesMain = guidata(mainObj);
curve = handlesMain.curves(curve_number);
%fit params
switch curve.mode
    case 'constant-height'
        if strcmpi(get(get(handles.uipanel_curve_type,'SelectedObject'),'Tag'),'radio_force_time')
            [StressRelaxationFit, parameters] = fit_stress_relaxation_params(curve);
            time_pause=curve.force_time_pause;
        end
    case 'constant-force'
        if strcmpi(get(get(handles.uipanel_curve_type,'SelectedObject'),'Tag'),'radio_distance_time')
            [StressRelaxationFit, parameters] = fit_creep_compliance_params(curve);
            time_pause=curve.distance_time_pause;
        end
end
if exist('parameters')
    params = parameters;
    axes(handles.axes_force_time);
    hold on;
    x_time_data=time_pause(1,:);
    y_time_data=time_pause(2,:);
    axis([min(x_time_data) max(x_time_data) min(y_time_data) max(y_time_data)]);
    try %delete previous graph, if exists
       delete(handles.current_stress_relaxation_plot);
    catch err
    end
    wykres = plot(StressRelaxationFit);
    set(wykres,'LineWidth',2,'LineStyle','-.','Color',[.2 .8 0]);
    axis auto;
    hold off;
    curve.dataStressRelaxation = params;
    handles.current_stress_relaxation = params;
    handles.current_stress_relaxation_plot = wykres;
    handlesMain.curves(curve_number) = curve;
    handlesMain.current_curve = curve;
end
%show results
switch curve.mode
    case 'constant-height'
        set(handles.pause_relaxation,'Title','Dynamic relaxation parameters');
        set(handles.checkbox_relaxation,'String','Analyze stress relaxation');
        imshow('stress_relaxation_equation.jpg','Parent',handles.axes_equation);
        axes(handles.axes_equation);
        set(handles.axes_equation,'color','none');
        axis image;
        set(handles.pause_relaxation,'Visible','on');
        set(handles.table_relaxation,'Data',curve.dataStressRelaxation');
        set(handles.table_relaxation,'RowName',{'a0','a1','a2','tau1','tau2'});
    case 'constant-force'
        set(handles.pause_relaxation,'Title','Dynamic creep parameters');
        set(handles.checkbox_relaxation,'String','Analyze creep compliance');
        imshow('creep_compliance_equation.jpg','Parent',handles.axes_equation);
        axes(handles.axes_equation);
        set(handles.axes_equation,'color','none');
        axis image;
        set(handles.pause_relaxation,'Visible','on');
        set(handles.table_relaxation,'Data',curve.dataStressRelaxation');
        set(handles.table_relaxation,'RowName',{'c0','c1','c2','x1','x2'});
end
%sava params
guidata(mainObj, handlesMain);
guidata(hObject, handles);
end