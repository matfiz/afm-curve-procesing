function plot_time_curve(hObject,handles)
%read params
relaxationPanel = findobj('tag','cps_stress_relaxation');
if isempty(relaxationPanel)
   %handles.relaxationPanel = cps_stress_relaxation('cps',handles.output);
   set(handles.toggle_stress_relaxation,'State','On');
   relaxationPanel = findobj('tag','cps_stress_relaxation');
   %relaxationPanel = handles.relaxationPanel;
    %cps('toggle_stress_relaxation_OnCallback',handles.output,1,guidata(handles.output))
   %guidata(hObject, handles);
end
relaxationHandles = guidata(relaxationPanel);
curve = handles.current_curve;
if (~isempty(relaxationPanel) && ~isempty(curve.dataSeriesTime))
    switch curve.mode
        case 'constant-height'
           plot_force_time_curve(hObject,handles); 
        case 'constant-force'
           plot_distance_time_curve(hObject,handles);
    end
    
end %end if
end