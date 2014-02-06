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

% Last Modified by GUIDE v2.5 04-Feb-2014 16:51:21

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

%style axes
xlabel(handles.axes_force_indentation,'Indentation [m]','FontWeight','bold','FontSize',12,'FontName','SansSerif');
ylabel(handles.axes_force_indentation,'Force [N]','FontWeight','bold','FontSize',12,'FontName','SansSerif');
title(handles.axes_force_indentation, ['Force-indentation for curve ' cps_handles.current_curve.name],'interpreter','none');
    

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cps_stiffness_panel wait for user response (see UIRESUME)
% uiwait(handles.cps_stiffness_panel);

function setContactPoint(hObject, contactPoint)
    handles = guidata(hObject);
    cps_handles = guidata(handles.cps);
    curve = cps_handles.current_curve;
    curve.hasStiffnessFit = true;
    params = StiffnessParams;
    curve.stiffnessParams = params;
    curve.stiffnessParams.xContactPoint = contactPoint(1);
    curve.stiffnessParams.yContactPoint = contactPoint(2);
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
    %curve.stiffnessParams.dataIndentation = curve.dataHeightMeasured(xContactPointIndex:curve.extendLength);
    %plot FD curve in StiffnessFitPanel
    forceIndentationData = curve.stiffnessParams.force_indentation;
    indentation_plot = plot(handles.axes_force_indentation,...
                        forceIndentationData(1,:),forceIndentationData(2,:));
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
