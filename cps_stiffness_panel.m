function varargout = cps_stiffness_panel(varargin)
% CPS_STIFFNESS_PANEL MATLAB code for cps_stiffness_panel.fig
%      CPS_STIFFNESS_PANEL, by itself, creates a new CPS_STIFFNESS_PANEL or raises the existing
%      singleton*.
%
%      H = CPS_STIFFNESS_PANEL returns the handle to a new CPS_STIFFNESS_PANEL or the handle to
%      the existing singleton*.
%
%      CPS_STIFFNESS_PANEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CPS_STIFFNESS_PANEL.M with the given input arguments.
%
%      CPS_STIFFNESS_PANEL('Property','Value',...) creates a new CPS_STIFFNESS_PANEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cps_stiffness_panel_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cps_stiffness_panel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cps_stiffness_panel

% Last Modified by GUIDE v2.5 12-Feb-2014 16:03:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cps_stiffness_panel_OpeningFcn, ...
                   'gui_OutputFcn',  @cps_stiffness_panel_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before cps_stiffness_panel is made visible.
function cps_stiffness_panel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cps_stiffness_panel (see VARARGIN)

% Choose default command line output for cps_stiffness_panel
handles.output = hObject;

%remeber the main window handles for later
handles.cps = [];

cpsInput = find(strcmp(varargin, 'cps'));
if ~isempty(cpsInput)
   handles.cps = varargin{cpsInput+1};
   cps_handles = guidata(handles.cps);
end

% Publish the functions
handles.setContactPoint = @setContactPoint;
handles.calculateForceIndentation = @calculateForceIndentation;

%Create labels in stiffness panel
handles.l_stiffness = uicontrol('Parent',handles.panel_stiffness_segments,...
                'Style','text',...
                'String','Stiffness [pN/nm]',...
                'FontSize',8,...
                'FontWeight','bold',...
                'Position',[20 185 90 15]);
handles.l_length = uicontrol('Parent',handles.panel_stiffness_segments,...
                'Style','text',...
                'String','Length [nm]',...
                'FontSize',8,...
                'FontWeight','bold',...
                'Position',[110 185 70 15]);
handles.l_length = uicontrol('Parent',handles.panel_stiffness_segments,...
                'Style','text',...
                'String','R^2',...
                'FontSize',8,...
                'FontWeight','bold',...
                'Position',[180 185 100 15]);



% Update handles structure
guidata(hObject, handles);
%draw force-indentation and segments if already analysed
try
    calculateForceIndentation(hObject);
    if cps_handles.current_curve.stiffnessParams.numberOfSegments > 0
        for i=1:curve.stiffnessParams.numberOfSegments,
            displaySegmentParams(hObject,i);
            plotSegment(hObject,i);
        end
    end
catch err
end

% UIWAIT makes cps_stiffness_panel wait for user response (see UIRESUME)
% uiwait(handles.cps_stiffness_panel);

function setContactPoint(hObject, contactPoint)
    %read
    handles = guidata(hObject);
    cps_handles = guidata(handles.cps);
    curve = cps_handles.current_curve;
    %set
    curve.hasStiffnessFit = true;
    params = StiffnessParams;
    curve.stiffnessParams = params;
    curve.stiffnessParams.xContactPoint = contactPoint(1);
    curve.stiffnessParams.yContactPoint = contactPoint(2);
    %save
    cps_handles.current_curve = curve;
    guidata(hObject, handles);
    guidata(handles.cps,cps_handles);
    handles.calculateForceIndentation(hObject);
    
function calculateForceIndentation(hObject)
    handles = guidata(hObject);
    cps_handles = guidata(handles.cps);
    curve = cps_handles.current_curve;
    %I search for index of contact point in Z-pos data
    index = find(curve.dataHeightMeasured == curve.stiffnessParams.xContactPoint);
    %it returns to values (for approach and retrace), I take the first
    %(approach)
    xContactPointIndex = index(1);
    curve.stiffnessParams.dataForce = curve.dataDeflection(xContactPointIndex:curve.extendLength);
    refSlope = curve.springConstant;
    refB = curve.dataDeflection(xContactPointIndex)-refSlope*curve.dataHeightMeasured(xContactPointIndex);
    for i=1:length(curve.stiffnessParams.dataForce),
      curve.stiffnessParams.dataIndentation(i) = curve.dataHeightMeasured(xContactPointIndex+i-1) - (curve.stiffnessParams.dataForce(i) - refB)/refSlope;    
    end
    curve.stiffnessParams.dataIndentation = curve.stiffnessParams.dataIndentation';
    %curve.stiffnessParams.dataIndentation = curve.dataHeightMeasured(xContactPointIndex:curve.extendLength);
    %plot FD curve in StiffnessFitPanel
    forceIndentationData = curve.stiffnessParams.force_indentation;
    indentation_plot = scatter(handles.axes_force_indentation,...
                        forceIndentationData(1,:),forceIndentationData(2,:),...
                        10,[1 0 1],'o','fill');
    %style plot                
    xlabel(handles.axes_force_indentation,'Indentation [m]','FontWeight','bold','FontSize',12,'FontName','SansSerif');
    ylabel(handles.axes_force_indentation,'Force [N]','FontWeight','bold','FontSize',12,'FontName','SansSerif');
    title(handles.axes_force_indentation, ['Force-indentation for curve ' cps_handles.current_curve.name],'interpreter','none');
    %save variables
    cps_handles.current_curve = curve;
    guidata(hObject, handles);
    guidata(handles.cps,cps_handles);
    
% --- Outputs from this function are returned to the command line.
function varargout = cps_stiffness_panel_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close cps_stiffness_panel.
function cps_stiffness_panel_CloseRequestFcn(hObject, eventdata, handles)
% the object can be deleted only from CPS window


% --- Executes on button press in b_select_contact_point.
function b_select_contact_point_Callback(hObject, eventdata, handles)
% hObject    handle to b_select_contact_point (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cps_handles = guidata(handles.cps);
axes(cps_handles.axes_force_distance);
vertical_cursors(hObject,cps_handles.axes_force_distance);
guidata(hObject, handles);


% --- Executes on button press in b_add_segment.
function b_add_segment_Callback(hObject, eventdata, handles, segmentNumber)
% hObject    handle to b_add_segment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    %read variables
    handles = guidata(hObject);
    cps_handles = guidata(handles.cps);
    curve = cps_handles.current_curve;
    
    %check segment number
    if (~exist('segmentNumber', 'var'))
        segmentNumber = curve.stiffnessParams.numberOfSegments;
        %increment number of segments
        if curve.stiffnessParams.numberOfSegments > 0
           curve.stiffnessParams.numberOfSegments = curve.stiffnessParams.numberOfSegments + 1;
        else
           curve.stiffnessParams.numberOfSegments = 1;
        end
        segmentNumber = curve.stiffnessParams.numberOfSegments;
    end
    
    
    
    
    %Add Segment To Curve instance
    curve.stiffnessParams.stiffnessSegments{segmentNumber} = StiffnessSegment;
    current_segment = curve.stiffnessParams.stiffnessSegments{segmentNumber};
    current_segment.slope = 0;
   
    %save variables
    curve.stiffnessParams.stiffnessSegments{segmentNumber} = current_segment;
    cps_handles.current_curve = curve;
    guidata(hObject, handles);
    guidata(handles.cps,cps_handles);
    selectPoints(hObject,segmentNumber);
    
function selectPoints(hObject,segment_number)
    segmentNumber = segment_number;
    %read variables
    handles = guidata(hObject);
    cps_handles = guidata(handles.cps);
    curve = cps_handles.current_curve;
    current_segment = curve.stiffnessParams.stiffnessSegments{segmentNumber};
    %select_points
    set(handles.status_bar,'String','Left click on the first point of the slope, right click on the end point.')
    set(handles.status_bar,'Visible','On');
    but = 1;
    axes(handles.axes_force_indentation);
    hold on;
    %wait for left, then right mouse button press
    while but == 1
        [x,y,but] = ginputax(handles.axes_force_indentation,1);
        if but == 1
            Min = findClosestPoint(x,y,curve.stiffnessParams.dataIndentation,curve.stiffnessParams.dataForce);
            current_segment.xStartPos = Min(1);
            current_segment.yStartPos = Min(2);
        end
    end
    Min = findClosestPoint(x,y,curve.stiffnessParams.dataIndentation,curve.stiffnessParams.dataForce);
    current_segment.xEndPos = Min(1);
    current_segment.yEndPos = Min(2);
    set(handles.status_bar,'Visible','Off');
    %fit line
    indexStart = find(curve.stiffnessParams.dataIndentation == current_segment.xStartPos);
    indexEnd = find(curve.stiffnessParams.dataIndentation == current_segment.xEndPos);
    %forceIndentationData = curve.stiffnessParams.force_indentation;
    yData = curve.stiffnessParams.dataForce(indexStart:indexEnd);
    xData = curve.stiffnessParams.dataIndentation(indexStart:indexEnd);
    [p,S] = polyfit(xData,yData,1);
    %calculate R^2 (Pearson correlation)
    %yResidual = yData - polyval(p,xData);
    SSxx=sum((xData-mean(xData)).^2);
    SSyy=sum((yData-mean(yData)).^2);
    SSxy=sum((xData-mean(xData)).*(yData-mean(yData)));
    yResidual = yData - p(1)*xData-p(2);
    SSresid = sum(yResidual.^2)*10^6;
    SStotal = (length(yData)-1)*var(yData)*10^6;
    %resq = 1 - SSresid/SStotal;
    resq = SSxy^2/(SSxx*SSyy);
    current_segment.slope = p(1);
    current_segment.freeCoef = p(2);
    current_segment.correlation = resq;
    %save variables
    curve.stiffnessParams.stiffnessSegments{segmentNumber} = current_segment;
    cps_handles.current_curve = curve;
    guidata(hObject, handles);
    guidata(handles.cps,cps_handles);
    %plot
    plotSegment(hObject,segmentNumber);
    displaySegmentParams(hObject,segmentNumber);
        
function Min = findClosestPoint(x,y,xData,yData)
    [a,index]=min((xData-x).^2+(yData-y).^2);
    Min = [xData(index(1)),yData(index(1)),index(1)];
    
function displaySegmentParams(hObject,segmentNumber)
    %read variables
    handles = guidata(hObject);
    cps_handles = guidata(handles.cps);
    curve = cps_handles.current_curve;
    current_segment = curve.stiffnessParams.stiffnessSegments{segmentNumber};
    
    %create buttons&labels
    handles.stiffnessControl_lStiffness{segmentNumber} = uicontrol('Parent',handles.panel_stiffness_segments,...
                'Style','text',...
                'String',current_segment.slope*10^3*(-1),...
                'FontSize',8,...
                'FontWeight','bold',...
                'Position',[30 200-50*segmentNumber 80 15]);
    handles.stiffnessControl_lLength{segmentNumber} = uicontrol('Parent',handles.panel_stiffness_segments,...
                'Style','text',...
                'String',current_segment.xLength*10^9,...
                'FontSize',8,...
                'FontWeight','bold',...
                'Position',[110 200-50*segmentNumber 80 15]);
    handles.stiffnessControl_lCorr{segmentNumber} = uicontrol('Parent',handles.panel_stiffness_segments,...
                'Style','text',...
                'String',current_segment.correlation,...
                'FontSize',8,...
                'FontWeight','bold',...
                'Position',[190 200-50*segmentNumber 70 15]);
    handles.stiffnessControl_bRemove{segmentNumber} = uicontrol('Parent',handles.panel_stiffness_segments,...
                'Style','pushbutton',...
                'String','Remove',...
                'FontSize',8,...
                'FontWeight','bold',...
                'Position',[260 200-50*segmentNumber 70 30],...
                'Backgroundcolor', [1 0 0],...
                'Callback', {@removeSegment,segmentNumber,hObject});
    %remove add segment button, if exists
    try
        delete(handles.stiffnessControl_bAdd{segmentNumber});
    catch err
    end
    
    %save variables
    curve.stiffnessParams.stiffnessSegments{segmentNumber} = current_segment;
    cps_handles.current_curve = curve;
    guidata(hObject, handles);
    guidata(handles.cps,cps_handles);
    
function removeSegment(hObj,event,segmentNumber,hObject)
    %read variables
    handles = guidata(hObject);
    cps_handles = guidata(handles.cps);
    curve = cps_handles.current_curve;
    current_segment = curve.stiffnessParams.stiffnessSegments{segmentNumber};
    
    %get objects and delete them
    lStiffness = handles.stiffnessControl_lStiffness{segmentNumber};
    lLength = handles.stiffnessControl_lLength{segmentNumber};
    lCorr = handles.stiffnessControl_lCorr{segmentNumber};
    bRemove = handles.stiffnessControl_bRemove{segmentNumber};
    gPoints = handles.graph_points{segmentNumber};
    gLine = handles.graph_segments{segmentNumber};
    gThinLine = handles.graph_segment_lines{segmentNumber};
    delete(lStiffness);
    delete(lLength);
    delete(lCorr);
    delete(bRemove);
    delete(gPoints);
    delete(gLine);
    delete(gThinLine);
    
    %if segment number is equal to total numbers of segments, then
    %decrement it
    if segmentNumber == curve.stiffnessParams.numberOfSegments
        curve.stiffnessParams.numberOfSegments = curve.stiffnessParams.numberOfSegments - 1;
    end
    
    %add button to create segment
    handles.stiffnessControl_bAdd{segmentNumber} = uicontrol('Parent',handles.panel_stiffness_segments,...
                'Style','pushbutton',...
                'String','Add',...
                'FontSize',8,...
                'FontWeight','bold',...
                'Position',[260 200-50*segmentNumber 60 30],...
                'Backgroundcolor', [0 1 0],...
                'Callback', {@addSegment,segmentNumber,hObject});
    
    %save variables
    curve.stiffnessParams.stiffnessSegments{segmentNumber} = current_segment;
    cps_handles.current_curve = curve;
    guidata(hObject, handles);
    guidata(handles.cps,cps_handles);
    
function addSegment(hObj,event,segmentNumber,hObject)
    %read variables
    handles = guidata(hObject);
    b_add_segment_Callback(hObject, event, handles, segmentNumber)
    
function plotSegment(hObject,segmentNumber)
    %read variables
    handles = guidata(hObject);
    cps_handles = guidata(handles.cps);
    curve = cps_handles.current_curve;
    current_segment = curve.stiffnessParams.stiffnessSegments{segmentNumber};
    
    %draw points
    points = plot(current_segment.xStartPos,current_segment.yStartPos,'gx',...
            current_segment.xEndPos,current_segment.yEndPos,'gx',...
            'MarkerSize',13,...
            'LineWidth',2);
    handles.graph_points{segmentNumber} = points;
    
    %select fragment
    indexStart = find(curve.stiffnessParams.dataIndentation == current_segment.xStartPos);
    indexEnd = find(curve.stiffnessParams.dataIndentation == current_segment.xEndPos);
    
    %select Data
    yData = curve.stiffnessParams.dataForce;
    xData = curve.stiffnessParams.dataIndentation;
    yFit = current_segment.slope*xData+current_segment.freeCoef;
    segment = plot(handles.axes_force_indentation,xData(indexStart:indexEnd),yFit(indexStart:indexEnd),...
        'LineWidth',2);
    line = plot(handles.axes_force_indentation,xData(indexStart:end),yFit(indexStart:end),...
        'LineWidth',0.5);
    handles.graph_segments{segmentNumber} = segment;
    handles.graph_segment_lines{segmentNumber} = line;
    
    %save variables
    curve.stiffnessParams.stiffnessSegments{segmentNumber} = current_segment;
    cps_handles.current_curve = curve;
    guidata(hObject, handles);
    guidata(handles.cps,cps_handles);
        


% --- Executes on button press in b_write_to_file.
function b_write_to_file_Callback(hObject, eventdata, handles)
% hObject    handle to b_write_to_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function b_write_to_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to b_write_to_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
[x,map]=imread('lib/pencil_40.png');
%I2=imresize(x, [120 72]);
set(hObject,'cdata',x);
