function fit_stress_relaxation(hObject,handles,curve_index)
handles=guidata(hObject);
[StressRelaxationFit, parameters] = fit_stress_relaxation_params(handles.curves(curve_index));
params = parameters;
axes(handles.axes_force_time);
hold on;
time_pause=handles.curves(curve_index).force_time_pause;
x_time_data=time_pause(1,:);
y_time_data=time_pause(2,:);
axis([min(x_time_data) max(x_time_data) min(y_time_data) max(y_time_data)]);
wykres = plot(StressRelaxationFit,'--g');
set(wykres,'LineWidth',2);
axis auto;
 ylabel(handles.axes_force_time,'Force [N]','FontWeight','bold','FontSize',12,'FontName','SansSerif');
    xlabel(handles.axes_force_time,'Time [s]','FontWeight','bold','FontSize',12,'FontName','SansSerif');
    title(handles.axes_force_time, ['Force-time for curve ' handles.current_curve.name]);
hold off;
curve = Curve;
curve = handles.curves(handles.current_curve_index);
curve.dataStressRelaxation = params;
handles.current_stress_relaxation = params;
handles.curves(handles.current_curve_index) = curve;
%show results
imshow('stress_relaxation_equation.jpg','Parent',handles.axes_equation);
axes(handles.axes_equation);
set(handles.axes_equation,'color','none')
axis image;
set(handles.pause_relaxation,'Visible','on');
set(handles.table_relaxation,'Data',handles.curves(curve_index).dataStressRelaxation');
set(handles.table_relaxation,'RowName',{'a0','a1','a2','tau1','tau2'});
guidata(hObject, handles);
end