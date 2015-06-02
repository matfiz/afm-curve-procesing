function plot_curve(hObject,handles)
    curve = handles.current_curve;
    approach=curve.force_distance_approach;
    
    if curve.pauseLength > 0
        pause=handles.current_curve.force_distance_pause;
    end
    retract=handles.current_curve.force_distance_retract;
    axes(handles.axes_force_distance);
    hold off;
    switch handles.view_mode
        case 1  % view both
            if curve.pauseLength > 0
                set(handles.axes_force_distance,'Visible','On');
                fd_plot = plot(handles.axes_force_distance,...
                    approach(1,:),approach(2,:),...
                    pause(1,:),pause(2,:),...
                    retract(1,:),retract(2,:));
            else
                set(handles.axes_force_distance,'Visible','On');
                fd_plot = plot(handles.axes_force_distance,...
                    approach(1,:),approach(2,:),...
                    retract(1,:),retract(2,:));
            end
            pcol(1)='r';
            pcol(2)='b';
            
            if curve.pauseLength == 0
                legend_fd_text = {'approach', 'retract'};
            else    
                legend_fd_text = {'approach', 'pause', 'retract'};
                pcol(3)='k';
            end
            %pcol(4)='g';
        case 2   % view approach
             if curve.pauseLength > 0
                set(handles.axes_force_distance,'Visible','On');
                fd_plot = plot(handles.axes_force_distance,...
                    approach(1,:),approach(2,:),...
                    pause(1,:),pause(2,:));
            else
                set(handles.axes_force_distance,'Visible','On');
                fd_plot = plot(handles.axes_force_distance,...
                    approach(1,:),approach(2,:));
            end
            pcol(1)='r';
            
            if curve.pauseLength == 0
                legend_fd_text = {'approach'};
            else    
                legend_fd_text = {'approach', 'pause'};
                pcol(2)='k';
            end

        case 3   % view retract 
            set(handles.axes_force_distance,'Visible','On');
            fd_plot = plot(handles.axes_force_distance,...
                      retract(1,:),retract(2,:));
            pcol(1)='b';
            legend_fd_text = {'retract'};
    end
   
    %fd_plot = plot(handles.axes_force_distance,x_distance_data,y_distance_data);
    %set(handles.fd_plot,fd_plot);
    xlabel(handles.axes_force_distance,'Distance [m]','FontWeight','bold','FontSize',12,'FontName','SansSerif');
    ylabel(handles.axes_force_distance,'Force [N]','FontWeight','bold','FontSize',12,'FontName','SansSerif');
    title(handles.axes_force_distance, ['Force-distance for curve ' handles.current_curve.name],'interpreter','none');
    
    for i=1:length(pcol)
     set(fd_plot(i),'Color',pcol(i));
    end
    legend_fd = legend(fd_plot,legend_fd_text);
    set(handles.axes_force_distance,'FontSize',12,'FontName','SansSerif');
    
    %set curve parameters in Curve Parameters window
    curveParametersHandles = guidata(handles.curveParameters);
    curveParametersHandles.refreshParams(handles.curveParameters, handles.current_curve);

    guidata(hObject, handles);
end