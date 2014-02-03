function plot_curve(hObject,handles)
    approach=handles.current_curve.force_distance_approach;
    pause=handles.current_curve.force_distance_pause;
    retract=handles.current_curve.force_distance_retract;
    time=handles.current_curve.force_time;
    time_approach=handles.current_curve.force_time_approach;
    time_pause=handles.current_curve.force_time_pause;
    time_retract=handles.current_curve.force_time_retract;
    switch handles.view_mode
        case 1  % view both
            x_distance_data=[approach(1,:); pause(1,:); retract(1,:)]';
            y_distance_data=[approach(2,:); pause(2,:); retract(2,:)]';
            x_time_data=[time_approach(1,:); time_pause(1,:); time_retract(1,:)]';
            y_time_data=[time_approach(2,:); time_pause(2,:); time_retract(2,:)]';
            pcol(1)='r';
            pcol(2)='b';
            pcol(3)='k';
            legend_fd_text = {'approach', 'pause', 'retract'};
            %pcol(4)='g';
        case 2   % view approach

        case 3   % view retract 

    end
    axes(handles.axes_force_distance);
    hold off;
    fd_plot = plot(handles.axes_force_distance,x_distance_data,y_distance_data);
    %set(handles.fd_plot,fd_plot);
    xlabel(handles.axes_force_distance,'Distance [m]');
    ylabel(handles.axes_force_distance,'Force [N]');
    title(handles.axes_force_distance, ['Force-distance for curve ' handles.current_curve.name]);
    
    ft_plot = plot(handles.axes_force_time,x_time_data,y_time_data);
    %set(handles.ft_plot,ft_plot);
    ylabel(handles.axes_force_time,'Force [N]');
    xlabel(handles.axes_force_time,'Time [s]');
    title(handles.axes_force_time, ['Force-time for curve ' handles.current_curve.name]);
    %establsish plot colours
    for i=1:length(pcol)
     set(fd_plot(i),'Color',pcol(i));
     set(ft_plot(i),'Color',pcol(i));
    end
    legend_fd = legend(fd_plot,legend_fd_text);
    legend_ft = legend(ft_plot,legend_fd_text);
    
    %set curve parameters
    set(handles.f_spring_constant,'String',handles.current_curve.springConstant);
    set(handles.f_sensitivity,'String',handles.current_curve.sensitivity);
    if handles.current_curve.closedLoop == true
        set(handles.f_closed_loop,'String','On');
        set(handles.f_closed_loop,'Enable','On');
    else
        set(handles.f_closed_loop,'String','Off');
        set(handles.f_closed_loop,'Enable','Off');
    end
    set(handles.f_extend_time,'String',handles.current_curve.extendTime);
    set(handles.f_extend_length,'String',handles.current_curve.extendLength);
    set(handles.f_pause_time,'String',handles.current_curve.extendPauseTime);
    set(handles.f_pause_length,'String',handles.current_curve.pauseLength);
    set(handles.f_retract_time,'String',handles.current_curve.retractTime);
    set(handles.f_retract_length,'String',handles.current_curve.retractLength);
    set(handles.f_mode,'String',handles.current_curve.mode);
    guidata(hObject, handles);
end