function varargout = cps_brush_deformation(varargin)
% CPS_BRUSH_DEFORMATION MATLAB code for cps_brush_deformation.fig
%      CPS_BRUSH_DEFORMATION, by itself, creates a new CPS_BRUSH_DEFORMATION or raises the existing
%      singleton*.
%
%      H = CPS_BRUSH_DEFORMATION returns the handle to a new CPS_BRUSH_DEFORMATION or the handle to
%      the existing singleton*.
%
%      CPS_BRUSH_DEFORMATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CPS_BRUSH_DEFORMATION.M with the given input arguments.
%
%      CPS_BRUSH_DEFORMATION('Property','Value',...) creates a new CPS_BRUSH_DEFORMATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cps_brush_deformation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cps_brush_deformation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cps_brush_deformation

% Last Modified by GUIDE v2.5 16-Apr-2014 15:09:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cps_brush_deformation_OpeningFcn, ...
                   'gui_OutputFcn',  @cps_brush_deformation_OutputFcn, ...
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


% --- Executes just before cps_brush_deformation is made visible.
function cps_brush_deformation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cps_brush_deformation (see VARARGIN)

%remeber the main window handles for later
handles.cps = [];
cpsInput = find(strcmp(varargin, 'cps'));
if ~isempty(cpsInput)
   handles.cps = varargin{cpsInput+1};
   cps_handles = guidata(handles.cps);
end

% Choose default command line output for cps_brush_deformation
handles.output = hObject;
handles.main = hObject;

% Update handles structure
guidata(hObject, handles);
calculate_height_distance(hObject);
plot_data(hObject);
% UIWAIT makes cps_brush_deformation wait for user response (see UIRESUME)
% uiwait(handles.cps_brush_deformation);


% --- Outputs from this function are returned to the command line.
function varargout = cps_brush_deformation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in b_confirm.
function b_confirm_Callback(hObject, eventdata, handles)
% hObject    handle to b_confirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.main);

% --- Executes on button press in b_cancel.
function b_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to b_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.main);

% --- Executes on button press in radio_sharp.
function radio_sharp_Callback(hObject, eventdata, handles)
% hObject    handle to radio_sharp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_sharp


% --- Executes on button press in radio_sphere.
function radio_sphere_Callback(hObject, eventdata, handles)
% hObject    handle to radio_sphere (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_sphere


% --- Executes when user attempts to close cps_brush_deformation.
function cps_brush_deformation_CloseRequestFcn(hObject, eventdata, handles)
delete(hObject)

function calculate_height_distance(hObject)
    %h(d) = Z(d) - Z0 + i + d
%read data
    handles = guidata(hObject);
    cps_handles = guidata(handles.cps);
    curve = cps_handles.current_curve;
if curve.hasElasticityFit == true
   elasticityParams = curve.elasticityParams;
    stiffnessParams = curve.stiffnessParams;
    %CP fitted from the model
    Z0 = elasticityParams.Z0;
    El = elasticityParams.E;
    k = curve.scalingFactor;
    R = elasticityParams.radius;
    %I search for index of Z0
    data = elasticityParams.force_indentation;%assuming a wide enough range was selected
    zData = data(1,:);
    fData = data(2,:);
    Min = findClosestPoint(Z0,0,zData,fData);
    index = Min(3);
    %it returns to values (for approach and retrace), I take the first
    %(approach)
    Z0Index = index(1);
    dMax = fData(Z0Index);
    %dMax = fData(end);
    zDataReduced = zData(1:Z0Index);
    fDataReduced = fData(1:Z0Index);
    force = [];
    dataH2 = [];
    for i=1:length(zDataReduced),
         indentation(i) = (9/16 * 1/El * sqrt(1/R) * fData(i))^(2/3);
         stiffnessParams.dataH(i) = zData(i) - Z0 + indentation(i) + fData(i)/k;
         dataH2(i) = zDataReduced(i) - ((9/16 * k/El * sqrt(1/R))^(2/3) * (dMax^(2/3)-(fDataReduced(i)/k)^(2/3)) - (dMax - fDataReduced(i)/k))-Z0;
         force(i) = k*(stiffnessParams.dataH(i)-zDataReduced(i)+Z0-indentation(i));
         %dModel(i) = 
    end
    %save variables
    curve.stiffnessParams = stiffnessParams;
    cps_handles.current_curve = curve;
    guidata(hObject, handles);
    guidata(handles.cps,cps_handles);
else
    disp('nie dopasowano elastycznosci!');
end

function plot_data(hObject)
%read data
    handles = guidata(hObject);
    cps_handles = guidata(handles.cps);
    curve = cps_handles.current_curve;
    elasticityParams = curve.elasticityParams;
    stiffnessParams = curve.stiffnessParams;
%CP fitted from the model
    Z0 = elasticityParams.Z0;
    %I search for index of Z0
    data = elasticityParams.force_indentation;%assuming a wide enough range was selected
    zData = data(1,:);
    fData = data(2,:);
    Min = findClosestPoint(Z0,0,zData,fData);
    index = Min(3);
    %it returns to values (for approach and retrace), I take the first
    %(approach)
    Z0Index = index(1);
    dMax = fData(Z0Index);
    %dMax = fData(end);
    zDataReduced = zData(1:Z0Index);
    fDataReduced = fData(1:Z0Index);
%plot data
    hPlot = plot(handles.axes, stiffnessParams.dataH*10^9, fDataReduced*10^9);
    ylabel(handles.axes,'Force [nN]','FontWeight','bold','FontSize',12,'FontName','SansSerif');
    xlabel(handles.axes,'h [nm]','FontWeight','bold','FontSize',12,'FontName','SansSerif');
    title(handles.axes, ['Force vs brush height'],'interpreter','none');
