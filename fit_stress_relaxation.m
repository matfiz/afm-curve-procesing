function fit_stress_relaxation(hObject,mainObj,curve_number)
%read handles
handles=guidata(hObject);
handlesMain = guidata(mainObj);
%fit params
curve = handlesMain.curves(curve_number);
[StressRelaxationFit, parameters] = fit_stress_relaxation_params(curve);
params = parameters;
axes(handles.axes_force_time);
hold on;
time_pause=curve.force_time_pause;
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
ylabel(handles.axes_force_time,'Force [N]','FontWeight','bold','FontSize',12,'FontName','SansSerif');
xlabel(handles.axes_force_time,'Time [s]','FontWeight','bold','FontSize',12,'FontName','SansSerif');
title(handles.axes_force_time, ['Force-time for curve ' curve.name]);
hold off;
curve.dataStressRelaxation = params;
handles.current_stress_relaxation = params;
handles.current_stress_relaxation_plot = wykres;
handlesMain.curves(curve_number) = curve;
handlesMain.current_curve = curve;
%show results
imshow('stress_relaxation_equation.jpg','Parent',handles.axes_equation);
axes(handles.axes_equation);
set(handles.axes_equation,'color','none');
axis image;
set(handles.pause_relaxation,'Visible','on');
set(handles.table_relaxation,'Data',curve.dataStressRelaxation');
set(handles.table_relaxation,'RowName',{'a0','a1','a2','tau1','tau2'});
%sava params
guidata(mainObj, handlesMain);
guidata(hObject, handles);
end