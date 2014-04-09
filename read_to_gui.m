function read_to_gui(hObject,handles,curve_index)
    plot_curve(hObject,handles);
    set(handles.output, 'WindowButtonDownFcn', '');%remove the click function from select contact point 
    if ~isempty(handles.current_curve.dataSeriesTime)
        plot_time_curve(hObject,handles);
    end

    %read adhesion steps
    [w k] = size(handles.current_curve.dataSteps);
    if k>5
        handles.current_steps = handles.current_curve.dataSteps;
        set(handles.adhesion_table,'Data',handles.current_steps(:,5:6));
        [w k] = size(handles.current_steps);
        for i=1:w
           axes(handles.axes_force_distance);
           hold on;
           z1=handles.current_steps(i,1);
           F1=handles.current_steps(i,2);
           z2=handles.current_steps(i,3);
           F2=handles.current_steps(i,4);
           plot(z1,F1,'gx',z2,F2,'gx','MarkerSize',13,'LineWidth',2);
        end
    else
        set(handles.adhesion_table,'Data',[]);
    end
    
    
    %stiffness fit
    stiffnessPanel = findobj('tag','cps_stiffness_panel');
    if ~isempty(stiffnessPanel)
        stiffness_handles = guidata(stiffnessPanel);
        stiffness_handles.plotToGui(stiffnessPanel);
        handles.drawPreviousContactPoint(hObject, handles);
    end
    guidata(hObject, handles);
    
end