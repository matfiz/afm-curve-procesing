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

    time=handles.current_curve.force_time;
    time_approach=handles.current_curve.force_time_approach;
    time_pause=handles.current_curve.force_time_pause;
    time_retract=handles.current_curve.force_time_retract;
    switch handles.view_mode
        case 1  % view both
            if curve.pauseLength > 0
                set(relaxationHandles.axes_force_time,'Visible','On');
                ft_plot = plot(relaxationHandles.axes_force_time,...
                    time_approach(1,:),time_approach(2,:),...
                    time_pause(1,:),time_pause(2,:),...
                    time_retract(1,:),time_retract(2,:));
            else
                set(relaxationHandles.axes_force_time,'Visible','Off');
                ft_plot = plot(relaxationHandles.axes_force_time,...
                    time_approach(1,:),time_approach(2,:),...
                    time_retract(1,:),time_retract(2,:));
            end
            pcol(1)='r';
            pcol(2)='b';

            if isempty(curve.dataSeriesTime)
                legend_fd_text = {'approach', 'retract'};
            else    
                legend_fd_text = {'approach', 'pause', 'retract'};
                pcol(3)='k';
            end
            %pcol(4)='g';
        case 2   % view approach

        case 3   % view retract 

    end
   
  
    ylabel(relaxationHandles.axes_force_time,'Force [N]','FontWeight','bold','FontSize',12,'FontName','SansSerif');
    xlabel(relaxationHandles.axes_force_time,'Time [s]','FontWeight','bold','FontSize',12,'FontName','SansSerif');
    title(relaxationHandles.axes_force_time, ['Force-time for curve ' handles.current_curve.name]);
    %establsish plot colours
    for i=1:length(pcol)
        set(ft_plot(i),'Color',pcol(i));
    end
    legend_ft = legend(ft_plot,legend_fd_text);
    set(relaxationHandles.axes_force_time,'FontSize',12,'FontName','SansSerif');
    
    guidata(relaxationPanel, relaxationHandles);
end %end if
end