function elasticity_cursor(hObject,axes)
set(gcf, ...
   'WindowButtonDownFcn', @clickFcn, ...
   'WindowButtonUpFcn', @unclickFcn);
hCur = nan(2, 1);
hCur(1) = line([NaN NaN], ylim(axes), ...
      'Color', 'black', 'Parent', axes);
hCur(2) = line([NaN NaN], ylim(axes), ...
      'Color', 'green', 'Parent', axes);
%hold off;
     function clickFcn(varargin)
        % Initiate cursor if clicked anywhere but the figure
        %disp(get(gcbf, 'SelectionType'));%shows which button is clicked
        if strcmpi(get(gco, 'type'), 'figure')
           set(hCur, 'XData', [NaN NaN]);                % <-- EDIT
        else
           %differenciate between left and right mouse click; if left, then
           %move END, if right, then move exclude initial parameter
           if strcmpi(get(gcbf, 'SelectionType'),'normal')
             set(gcf, 'WindowButtonMotionFcn', @dragFcnEnd)
             dragFcnEnd()
           else %if 'alt' (right) or 'extend' (middle)
             set(gcf, 'WindowButtonMotionFcn', @dragFcnStart)
             dragFcnStart()
           end
        end
     end
    function dragFcnStart(varargin)
        % Get mouse location
        pt = get(gca, 'CurrentPoint');
        hold on;
        
        %update slope line pos
        yRange = get(hCur,'YData');
        %updata data
        handles = guidata(hObject);
        cps_handles = guidata(handles.cps);
        curve = cps_handles.current_curve;
        %if get(handles.radio_sokolov_sphere,'Value') == 1
        approach=curve.elasticityParams.force_indentation;
        xdata = approach(1,:);
        ydata = approach(2,:);
        % Update cursor text
        %for idx = 1:length(allLines)
           
           if pt(1) >= xdata(end) && pt(1) <= xdata(1)
             % Update cursor line position
             set(hCur(2), 'XData', [pt(1), pt(1)]);
             % I search for the x data value closest to pt(1)
             [c index] = min(abs(xdata-pt(1)));
             handles.setStartPoint(hObject, [xdata(index),ydata(index),index]);
           else
              %set(hText(idx), 'Position', [NaN NaN]);
           end
        %end
     end
     function dragFcnEnd(varargin)
        % Get mouse location
        pt = get(gca, 'CurrentPoint');
        hold on;
        
        %update slope line pos
        yRange = get(hCur,'YData');
        %updata data
        handles = guidata(hObject);
        cps_handles = guidata(handles.cps);
        curve = cps_handles.current_curve;
        approach=curve.elasticityParams.force_indentation;
        xdata = approach(1,:);
        ydata = approach(2,:);
        % Update cursor text
        %for idx = 1:length(allLines)
           
           if pt(1) >= xdata(end) && pt(1) <= xdata(1)
             % Update cursor line position
             set(hCur(1), 'XData', [pt(1), pt(1)]);
             % I search for the x data value closest to pt(1)
             [c index] = min(abs(xdata-pt(1)));
             handles.setEndPoint(hObject, [xdata(index),ydata(index),index]);
           else
              %set(hText(idx), 'Position', [NaN NaN]);
           end
        %end
     end
     function unclickFcn(varargin)
        set(gcf, 'WindowButtonMotionFcn', '');
     end
end