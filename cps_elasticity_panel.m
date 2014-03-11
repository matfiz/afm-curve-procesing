function varargout = cps_elasticity_panel(varargin)
% CPS_ELASTICITY_PANEL MATLAB code for cps_elasticity_panel.fig
%      CPS_ELASTICITY_PANEL, by itself, creates a new CPS_ELASTICITY_PANEL or raises the existing
%      singleton*.
%
%      H = CPS_ELASTICITY_PANEL returns the handle to a new CPS_ELASTICITY_PANEL or the handle to
%      the existing singleton*.
%
%      CPS_ELASTICITY_PANEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CPS_ELASTICITY_PANEL.M with the given input arguments.
%
%      CPS_ELASTICITY_PANEL('Property','Value',...) creates a new CPS_ELASTICITY_PANEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cps_elasticity_panel_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cps_elasticity_panel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cps_elasticity_panel

% Last Modified by GUIDE v2.5 03-Mar-2014 13:28:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cps_elasticity_panel_OpeningFcn, ...
                   'gui_OutputFcn',  @cps_elasticity_panel_OutputFcn, ...
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


% --- Executes just before cps_elasticity_panel is made visible.
function cps_elasticity_panel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cps_elasticity_panel (see VARARGIN)

% Choose default command line output for cps_elasticity_panel
handles.output = hObject;


%some constants
handles.radius = 2500.0;
handles.xShiftCP = 0.0;
handles.xShiftCP_use_stiffness = false;
handles.excludeInitial = 0.0;
handles.excludeInitial_use_stiffness = false;
handles.model = 'sneddon_sphere';
handles.excludeInitial = 0.0;



%publish functions
handles.setEndPoint = @setEndPoint;

%remeber the main window handles for later
handles.cps = [];    
cpsInput = find(strcmp(varargin, 'cps'));
if ~isempty(cpsInput)
   handles.cps = varargin{cpsInput+1};
   cps_handles = guidata(handles.cps);
end

%open file output
handles.fileOutput = cps_write_to_file('cps',handles.cps);
set(handles.fileOutput, 'Name', 'Elasticity file output');

% Update handles structure
guidata(hObject, handles);
%draw force-indentation and fit
plotToGui(hObject);

% UIWAIT makes cps_elasticity_panel wait for user response (see UIRESUME)
% uiwait(handles.elasticity);


% --- Outputs from this function are returned to the command line.
function varargout = cps_elasticity_panel_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function e_shift_cp_Callback(hObject, eventdata, handles)
    %read data
    handles = guidata(hObject);
    cps_handles = guidata(handles.cps);
    curve = cps_handles.current_curve;
    %change param in handles
    handles.xShiftCP = str2double(get(hObject,'String'));
    %check if elasticity params already exist
    if curve.hasElasticityFit == true
        curve.elasticityParams.xShiftCP = handles.xShiftCP;
    end
    %save variables
    cps_handles.current_curve = curve;
    guidata(hObject, handles);
    guidata(handles.cps,cps_handles);
    %draw force-indentation and fit
    plotToGui(hObject);        

% --- Executes during object creation, after setting all properties.
function e_shift_cp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_shift_cp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_use_value_of_first_slope.
function checkbox_use_value_of_first_slope_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of checkbox_use_value_of_first_slope
    %read data
    handles = guidata(hObject);
    cps_handles = guidata(handles.cps);
    curve = cps_handles.current_curve;
    if get(hObject,'Value') == 1
        try
            current_segment = curve.stiffnessParams.stiffnessSegments{1};
            xEndPos = current_segment.xEndPos*10^9*(-1);
            %change param in handles
            handles.xShiftCP_use_stiffness = get(hObject,'Value');
            handles.xShiftCP = xEndPos;
            set(handles.e_shift_cp,'String',xEndPos);
            %check if elasticity params already exist
            if curve.hasElasticityFit == true
                curve.elasticityParams.xShiftCP_use_stiffness = handles.xShiftCP_use_stiffness;
                curve.elasticityParams.xShiftCP = handles.xShiftCP;
            end
        catch err
            set(handles.status_bar,'Visible','on');
            set(handles.status_bar,'String', 'Nie dopasowano segmentu sztywnoœci!');
            set(hObject,'Value',0);
        end
    else
        set(handles.status_bar,'Visible','off');
        set(hObject,'Value',0);
        set(handles.e_shift_cp,'String',0.0);
        handles.xShiftCP = 0;
        handles.xShiftCP_use_stiffness = false;
        if curve.hasElasticityFit == true
            curve.elasticityParams.xShiftCP_use_stiffness = handles.xShiftCP_use_stiffness;
            curve.elasticityParams.xShiftCP = handles.xShiftCP;
        end
    end
    %save variables
    cps_handles.current_curve = curve;
    guidata(hObject, handles);
    guidata(handles.cps,cps_handles);
    %draw force-indentation and fit
    %plotToGui(hObject);        


function e_radius_Callback(hObject, eventdata, handles)
% hObject    handle to e_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_radius as text
%        str2double(get(hObject,'String')) returns contents of e_radius as a double


% --- Executes during object creation, after setting all properties.
function e_radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function e_elasticity_parameter_Callback(hObject, eventdata, handles)
% hObject    handle to e_elasticity_parameter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_elasticity_parameter as text
%        str2double(get(hObject,'String')) returns contents of e_elasticity_parameter as a double


% --- Executes during object creation, after setting all properties.
function e_elasticity_parameter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_elasticity_parameter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in b_write_to_file.
function b_write_to_file_Callback(hObject, eventdata, handles)
    handles = guidata(hObject);
    cps_handles = guidata(handles.cps);
    fileOutput_handles = guidata(handles.fileOutput);
    fileOutput_handles.write_elasticity(handles.fileOutput);

function e_exclude_Callback(hObject, eventdata, handles)
% hObject    handle to e_exclude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_exclude as text
%        str2double(get(hObject,'String')) returns contents of e_exclude as a double
    %read data
    handles = guidata(hObject);
    cps_handles = guidata(handles.cps);
    curve = cps_handles.current_curve;
    %change param in handles
    handles.excludeInitial = str2double(get(hObject,'String'));
    %check if elasticity params already exist
    if curve.hasElasticityFit == true
        curve.elasticityParams.excludeInitial = handles.excludeInitial;
    end
    %save variables
    cps_handles.current_curve = curve;
    guidata(hObject, handles);
    guidata(handles.cps,cps_handles);
    %draw force-indentation and fit
    plotToGui(hObject);        


% --- Executes during object creation, after setting all properties.
function e_exclude_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_exclude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_exclude_value_of_first_slope.
function checkbox_exclude_value_of_first_slope_Callback(hObject, eventdata, handles)
    %read data
    handles = guidata(hObject);
    cps_handles = guidata(handles.cps);
    curve = cps_handles.current_curve;
    if get(hObject,'Value') == 1
        try
            current_segment = curve.stiffnessParams.stiffnessSegments{1};
            xEndPos = current_segment.xEndPos*10^9*(-1);
            %change param in handles
            handles.excludeInitial_use_stiffness = get(hObject,'Value');
            handles.excludeInitial = xEndPos;
            set(handles.e_exclude,'String',xEndPos);
            %check if elasticity params already exist
            if curve.hasElasticityFit == true
                curve.elasticityParams.excludeInitial_use_stiffness = handles.excludeInitial_use_stiffness;
                curve.elasticityParams.excludeInitial = handles.excludeInitial;
            end
        catch err
            set(handles.status_bar,'Visible','on');
            set(handles.status_bar,'String', 'Nie dopasowano segmentu sztywnoœci!');
            set(hObject,'Value',0);
        end
    else
        set(handles.status_bar,'Visible','off');
        set(hObject,'Value',0);
        set(handles.e_exclude,'String',0.0);
        handles.excludeInitial = 0;
        handles.excludeInitial_use_stiffness = false;
        if curve.hasElasticityFit == true
            curve.elasticityParams.excludeInitial_use_stiffness = handles.excludeInitial_use_stiffness;
            curve.elasticityParams.excludeInitial = handles.excludeInitial;
        end
    end
    %save variables
    cps_handles.current_curve = curve;
    guidata(hObject, handles);
    guidata(handles.cps,cps_handles);

    
% --- Executes on button press in radio_sneddon_sphere.
function radio_sneddon_sphere_Callback(hObject, eventdata, handles)
handles.model = 'sneddon_sphere';
cps_handles = guidata(handles.cps);
cps_handles.current_curve.elasticityParams.model = 'sneddon_sphere';
guidata(hObject, handles);
guidata(handles.cps,cps_handles);


% --- Executes on button press in radio_hertz_sphere.
function radio_hertz_sphere_Callback(hObject, eventdata, handles)
handles.model = 'hertz_sphere';
cps_handles = guidata(handles.cps);
cps_handles.current_curve.elasticityParams.model = 'hertz_sphere';
guidata(hObject, handles);
guidata(handles.cps,cps_handles);

% --- Executes on button press in radio_fung_hyperelastic.
function radio_fung_hyperelastic_Callback(hObject, eventdata, handles)
handles.model = 'fung_hyperelastic';
cps_handles = guidata(handles.cps);
cps_handles.current_curve.elasticityParams.model = 'fung_hyperelastic';
guidata(hObject, handles);
guidata(handles.cps,cps_handles);


% --- Executes when user attempts to close elasticity.
function elasticity_CloseRequestFcn(hObject, eventdata, handles)
%panel can be closed only from CPS
delete(handles.fileOutput);

% --- Executes on button press in b_update.
function b_update_Callback(hObject, eventdata, handles)
% hObject    handle to b_update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plotToGui(hObject);



function plotToGui(hObject)
    %draw force-indentation and segments if already analysed
    %read
    handles = guidata(hObject);
    cps_handles = guidata(handles.cps);
    curve = cps_handles.current_curve;
    %clear current content
    cla(handles.axes_force_indentation,'reset');
    %draw segments and force-indentation
    if curve.hasStiffnessFit == true
        calculateForceIndentation(hObject);
        axes(handles.axes_force_indentation);
        elasticity_cursor(hObject,handles.axes_force_indentation);
        calculateStartPoints(hObject);
        try
            fitModel(hObject);
        catch
        end;
    else
        disp('no contact point!');
    end
   % catch err
    %end
function Min = calculateCPposition(hObject,xShiftCP) 
    %read data
    handles = guidata(hObject);
    cps_handles = guidata(handles.cps);
    curve = cps_handles.current_curve;
    %read the position of CP for stiffness
    xCPstiffness = curve.stiffnessParams.xContactPoint;
    yCPstiffness = curve.stiffnessParams.yContactPoint;
    %calculate xCP
    xCP = sign(xCPstiffness)*(abs(xCPstiffness) - xShiftCP*10^(-9));
    %define data
    xData = curve.dataHeightMeasured(1:curve.extendLength);
    yData = curve.dataDeflection(1:curve.extendLength);
    %find closes point
    Min = findClosestPoint(xCP,yCPstiffness,xData,yData);

function calculateForceIndentation(hObject)
    %read data
    handles = guidata(hObject);
    cps_handles = guidata(handles.cps);
    curve = cps_handles.current_curve;
    %check if elasticity params already exist
    if curve.hasElasticityFit == true
        set(handles.e_shift_cp,'String',curve.elasticityParams.xShiftCP);
        handles.xShiftCP = curve.elasticityParams.xShiftCP;
        set(handles.checkbox_use_value_of_first_slope,'Value',curve.elasticityParams.xShiftCP_use_stiffness);
        elasticityParams.xShiftCP_use_stiffness = curve.elasticityParams.xShiftCP_use_stiffness;
        set(handles.e_exclude,'String',curve.elasticityParams.excludeInitial);
        handles.excludeInitial = curve.elasticityParams.excludeInitial;
        set(handles.checkbox_exclude_value_of_first_slope,'Value',curve.elasticityParams.excludeInitial_use_stiffness);
        elasticityParams.excludeInitial_use_stiffness = curve.elasticityParams.excludeInitial_use_stiffness;
        set(handles.e_elasticity_parameter,'String',curve.elasticityParams.E);
        set(handles.e_radius,'String',curve.elasticityParams.radius*10^6);
        handles.model = curve.elasticityParams.model;
        set(handles.(['radio_' handles.model]), 'Value', 1);
        handles.radius = curve.elasticityParams.radius;
        elasticityParams = curve.elasticityParams;
    else
        elasticityParams = ElasticityParams;
        elasticityParams.xShiftCP = handles.xShiftCP;
        elasticityParams.xShiftCP_use_stiffness = handles.xShiftCP_use_stiffness;
        elasticityParams.excludeInitial = handles.excludeInitial;
        elasticityParams.excludeInitial_use_stiffness = handles.excludeInitial_use_stiffness;
        elasticityParams.radius = handles.radius;   
        elasticityParams.model = handles.model;
    end
    %calculate contact point position
        Min = calculateCPposition(hObject, elasticityParams.xShiftCP);
        elasticityParams.xContactPoint = Min(1);
        elasticityParams.yContactPoint = Min(2);
        index = Min(3);
    %I search for index of contact point in Z-pos data
    index = find(curve.dataHeightMeasured == elasticityParams.xContactPoint);
    %it returns to values (for approach and retrace), I take the first
    %(approach)
    xContactPointIndex = index(1);
    %show length
    %disp(curve.extendLength-xContactPointIndex);
    elasticityParams.dataForce = curve.dataDeflection(xContactPointIndex:curve.extendLength);
    refSlope = curve.scalingFactor;
    refB = curve.dataDeflection(xContactPointIndex)-refSlope*curve.dataHeightMeasured(xContactPointIndex);
    %clear the old contents of dataIndentation
    elasticityParams.dataIndentation = [0 0];
    for i=1:length(elasticityParams.dataForce),
      elasticityParams.dataIndentation(i) = curve.dataHeightMeasured(xContactPointIndex+i-1) - (elasticityParams.dataForce(i) - refB)/refSlope;    
    end 
    elasticityParams.dataIndentation = elasticityParams.dataIndentation';
    %shift to 0
    elasticityParams.dataForce = elasticityParams.dataForce - min(elasticityParams.dataForce);
    %plot FI curve 
    forceIndentationData = elasticityParams.force_indentation;
    indentation_plot = scatter(handles.axes_force_indentation,...
                        forceIndentationData(1,:),forceIndentationData(2,:),...
                        10,[1 0 1],'o','fill');
    hold on;
    %style plot                
    xlabel(handles.axes_force_indentation,'Indentation [m]','FontWeight','bold','FontSize',12,'FontName','SansSerif');
    ylabel(handles.axes_force_indentation,'Force [N]','FontWeight','bold','FontSize',12,'FontName','SansSerif');
    title(handles.axes_force_indentation, ['Force-indentation for curve ' cps_handles.current_curve.name],'interpreter','none');
    curve.hasElasticityFit = true;
    curve.elasticityParams = elasticityParams;
    %plot exclude line
    if elasticityParams.excludeInitial > 0
        try
            delete(handles.excludeInitialLine);
        catch err
        end
        xPos = -handles.excludeInitial*10^(-9);
        yRange = ylim(handles.axes_force_indentation);
        handles.excludeInitialLine = line([xPos xPos],...
            yRange,...
            'LineWidth',2,...
            'Color', [0, 1.0, 0.0],...
            'Parent',handles.axes_force_indentation);
    end
    %save variables
    cps_handles.current_curve = curve;
    guidata(hObject, handles);
    guidata(handles.cps,cps_handles);
  function calculateStartPoints(hObject)
    %read data
    handles = guidata(hObject);
    cps_handles = guidata(handles.cps);
    curve = cps_handles.current_curve;
    elasticityParams = curve.elasticityParams;
    %get initial exclude
    excludeInitial = elasticityParams.excludeInitial*10^(-9);
    xCPstiffness = curve.stiffnessParams.xContactPoint;
    yCPstiffness = curve.stiffnessParams.yContactPoint;
    xSP = -excludeInitial;
    forceIndentationData = elasticityParams.force_indentation';
    Min = findClosestPoint(xSP,0,elasticityParams.dataIndentation,elasticityParams.dataForce);
    elasticityParams.xStart = Min(1);
    elasticityParams.yStart = Min(2);
    elasticityParams.indexStart = Min(3);
    %save variables
    curve.elasticityParams = elasticityParams;
    cps_handles.current_curve = curve;
    guidata(hObject, handles);
    guidata(handles.cps,cps_handles);
function setEndPoint(hObject, point)  
    %read data
    handles = guidata(hObject);
    cps_handles = guidata(handles.cps);
    curve = cps_handles.current_curve;
    elasticityParams = curve.elasticityParams;
    %set vars
    elasticityParams.xEnd = point(1);
    elasticityParams.yEnd = point(2);
    elasticityParams.indexEnd = point(3);
    %save variables
    curve.elasticityParams = elasticityParams;
    cps_handles.current_curve = curve;
    guidata(hObject, handles);
    guidata(handles.cps,cps_handles);
    fitModel(hObject);
    
function fitModel(hObject)
    %read data
    handles = guidata(hObject);
    cps_handles = guidata(handles.cps);
    curve = cps_handles.current_curve;
    elasticityParams = curve.elasticityParams;
    %get data
    data = elasticityParams.force_indentation_to_fit;
    data_full = elasticityParams.force_indentation;
    xData = data(1,:);
    yData = data(2,:);
    %get model
    model = handles.model;
    %model = 'hertz_sphere';
    radius = str2double(get(handles.e_radius, 'String'))*10^(-9);
    elasticityParams.radius = radius;
    nu = 0.5; %poisson ratio;
    switch model 
        case 'sneddon_sphere'
          El=FitFunctionSphereSneddon([radius nu], xData, yData);
          aData = FunctionSphereSneddonIndentation(radius, data_full(1,:));
          yFit=FunctionSphereSneddon([radius nu], [El], aData);
        case 'hertz_sphere'
          El=FitFunctionSphereHertz([radius nu], xData, yData);
          yFit=FunctionSphereHertz([radius nu], [El], data_full(1,:));
        case 'fung_hyperelastic'
          param=FitFunctionFungHyperelastic([radius nu], xData, yData);
          aData = FunctionFungHyperelasticIndentation(radius, data_full(1,:));
          yFit=FunctionFungHyperelastic([radius nu], [param(1) param(2)], aData);
          %yFit=FunctionFungHyperelastic([radius nu], [-300 0.1], data_full(1,:));
          El=param(1);
          disp(param);
    end
    try
        delete(handles.plot_model);
    catch err
    end
    yLimit = ylim(handles.axes_force_indentation);
    handles.plot_model = plot(handles.axes_force_indentation,...
                        data_full(1,:),yFit,'r',...
                        'LineWidth',2);
    ylim(handles.axes_force_indentation,yLimit);
    set(handles.e_elasticity_parameter,'String',El/1000);
    elasticityParams.E = El;
    %save variables
    curve.elasticityParams = elasticityParams;
    cps_handles.current_curve = curve;
    guidata(hObject, handles);
    guidata(handles.cps,cps_handles);

