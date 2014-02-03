function plot_curve(hObject,handles)
    approach=handles.current_curve.force_distance_approach;
    pause=handles.current_curve.force_distance_pause;
    retract=handles.current_curve.force_distance_retract;
    time=handles.current_curve.force_time;
    time_approach=handles.current_curve.force_time_approach;
    time_pause=handles.current_curve.force_time_pause;
    time_retract=handles.current_curve.force_time_retract;
    axes(handles.axes_force_distance);
    hold off;
    switch handles.view_mode
        case 1  % view both
            fd_plot = plot(handles.axes_force_distance,...
                approach(1,:),approach(2,:),...
                pause(1,:),pause(2,:),...
                retract(1,:),retract(2,:));
            ft_plot = plot(handles.axes_force_time,...
                time_approach(1,:),time_approach(2,:),...
                time_pause(1,:),time_pause(2,:),...
                time_retract(1,:),time_retract(2,:));
            %x_distance_data=[approach(1,:); pause(1,:); retract(1,:)]';
            %y_distance_data=[approach(2,:); pause(2,:); retract(2,:)]';
            %x_time_data=[time_approach(1,:); time_pause(1,:); time_retract(1,:)]';
            %y_time_data=[time_approach(2,:); time_pause(2,:); time_retract(2,:)]';
            pcol(1)='r';
            pcol(2)='b';
            pcol(3)='k';
            legend_fd_text = {'approach', 'pause', 'retract'};
            %pcol(4)='g';
        case 2   % view approach

        case 3   % view retract 

    end
   
    %fd_plot = plot(handles.axes_force_distance,x_distance_data,y_distance_data);
    %set(handles.fd_plot,fd_plot);
    xlabel(handles.axes_force_distance,'Distance [m]','FontWeight','bold','FontSize',12,'FontName','SansSerif');
    ylabel(handles.axes_force_distance,'Force [N]','FontWeight','bold','FontSize',12,'FontName','SansSerif');
    title(handles.axes_force_distance, ['Force-distance for curve ' handles.current_curve.name]);
    
    %ft_plot = plot(handles.axes_force_time,x_time_data,y_time_data);
    %set(handles.ft_plot,ft_plot);
    ylabel(handles.axes_force_time,'Force [N]','FontWeight','bold','FontSize',12,'FontName','SansSerif');
    xlabel(handles.axes_force_time,'Time [s]','FontWeight','bold','FontSize',12,'FontName','SansSerif');
    title(handles.axes_force_time, ['Force-time for curve ' handles.current_curve.name]);
    %establsish plot colours
    for i=1:length(pcol)
     set(fd_plot(i),'Color',pcol(i));
     set(ft_plot(i),'Color',pcol(i));
    end
    legend_fd = legend(fd_plot,legend_fd_text);
    legend_ft = legend(ft_plot,legend_fd_text);
    
    set(handles.axes_force_distance,'FontSize',12,'FontName','SansSerif');
    set(handles.axes_force_time,'FontSize',12,'FontName','SansSerif');
    
    %set curve parameters in Curve Parameters window
    curveParametersHandles = guidata(handles.curveParameters);
    curveParametersHandles.refreshParams(handles.curveParameters, handles.current_curve);

    guidata(hObject, handles);
end