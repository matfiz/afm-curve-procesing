function read_to_gui(hObject,handles,curve_index)
    guidata(hObject, handles);
    plot_curve(hObject,handles);
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
    guidata(hObject, handles);
end