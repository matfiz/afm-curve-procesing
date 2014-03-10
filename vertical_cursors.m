function vertical_cursors(hObject,axes)
handles = guidata(hObject);

set(gcf, ...
   'WindowButtonDownFcn', @clickFcn, ...
   'WindowButtonUpFcn', @unclickFcn);
% Set up cursor text
allLines = findobj(axes, 'type', 'line');
hText = nan(1, length(allLines));
for id = 1:length(allLines)
   hText(id) = text(NaN, NaN, '', ...
      'Parent', get(allLines(id), 'Parent'), ...
      'BackgroundColor', 'yellow', ...
      'Color', get(allLines(id), 'Color'));
end
% Set up cursor lines
%allAxes = findobj(gcf, 'Type', 'axes');
%hCur = nan(1, length(allAxes));
hCur = nan(1, 1);
%for id = 1:length(allAxes)
%   hCur(id) = line([NaN NaN], ylim(allAxes(id)), ...
%      'Color', 'black', 'Parent', allAxes(id));
%end
hold on;
hCur(1) = line([NaN NaN], ylim(axes), ...
      'Color', 'black', 'Parent', axes, 'Tag', 'cursor');
slopeCur(1) = line([NaN NaN], ylim(axes), ...
      'Color', 'red', 'Parent', axes, 'Tag', 'cursor');
%hold off;
     function clickFcn(varargin)
        % Initiate cursor if clicked anywhere but the figure
        if strcmpi(get(gco, 'type'), 'figure')
           set(hCur, 'XData', [NaN NaN]);                % <-- EDIT
           set(hText, 'Position', [NaN NaN]);            % <-- EDIT
        else
           set(gcf, 'WindowButtonMotionFcn', @dragFcn)
           dragFcn()
        end
     end
     function dragFcn(varargin)
        % Get mouse location
        pt = get(gca, 'CurrentPoint');
        hold on;
        % Update cursor line position
        set(hCur, 'XData', [pt(1), pt(1)]);
        %update slope line pos
        yRange = get(hCur,'YData');
        %updata data
        cps_handles = guidata(handles.cps);
        curve = cps_handles.current_curve;
        approach=curve.force_distance_approach;
        xdata = approach(1,:);
        ydata = approach(2,:);
        %slope = cps_handles.current_curve.sensitivity*cps_handles.current_curve.springConstant*(-1)*64*2.5*10^(-4);
        slope = cps_handles.current_curve.scalingFactor*(-1);
        %hold off;
        % Update cursor text
        %for idx = 1:length(allLines)
           
           if pt(1) >= xdata(end) && pt(1) <= xdata(1)
              y = interp1(xdata, ydata, pt(1));
           %   set(hText(idx), 'Position', [pt(1), y], ...
           %      'String', sprintf('(%0.2f, %0.2f)', pt(1), y));
           % I search for the x data value closest to pt(1)
             [c index] = min(abs(xdata-pt(1)));
               handles.setContactPoint(handles.output, [xdata(index),ydata(index)]);
               %draw the slope on graph
                b = ydata(index)-slope*xdata(index);
                xMin = (yRange(1)-b)/slope;
                xMax = (yRange(2)-b)/slope;
                set(slopeCur, 'XData', [xMin, xMax]);
           else
              %set(hText(idx), 'Position', [NaN NaN]);
           end
        %end
     end
     function unclickFcn(varargin)
        set(gcf, 'WindowButtonMotionFcn', '');
     end
end