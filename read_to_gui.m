function read_to_gui(hObject,handles,curve_index)
    plot_curve(hObject,handles);

    %read adhesion steps
    [w k] = size(handles.current_curve.dataSteps);
    if k>5
        handles.current_steps = handles.current_curve.dataSteps;
        set(handles.adhesion_table,'Data',handles.current_steps(:,5:6));
        [w k] = size(handles.current_steps);
        for i=1:w
           axes(handles.axes_force_distance);
           hold on;
           z1=handles.current_steps(i,1)
           F1=handles.current_steps(i,2)
           z2=handles.current_steps(i,3);
           F2=handles.current_steps(i,4);
           plot(z1,F1,'gx',z2,F2,'gx','MarkerSize',13,'LineWidth',2);
        end
    else
        set(handles.adhesion_table,'Data',[]);
    end
    %stress relaxation fit
    %if handles.curves(curve_index).mode == 'constant-height'
        if handles.current_curve.hasStressRelaxation == true
            fit_stress_relaxation(hObject,handles,curve_index); 
            set(handles.checkbox_relaxation,'Value',1);
            set(handles.table_relaxation,'Visible','on');
            set(handles.slider_relaxation,'Visible','on');
            set(handles.slider_relaxation,'Max',handles.current_curve.pauseLength);
            set(handles.slider_relaxation,'Value',handles.curves(curve_index).StressRelaxationFitLength);
            set(handles.f_relaxation_fit_range,'String',num2str(handles.curves(curve_index).StressRelaxationFitLength/handles.current_curve.pauseLength*100,'%5.0f%%'));
        else
            set(handles.checkbox_relaxation,'Value',0);
            set(handles.table_relaxation,'Visible','off');
            set(handles.slider_relaxation,'Visible','off');
        end
    %end
    guidata(hObject, handles);
end