function varargout = cps_write_to_file(varargin)
% CPS_WRITE_TO_FILE MATLAB code for cps_write_to_file.fig
%      CPS_WRITE_TO_FILE, by itself, creates a new CPS_WRITE_TO_FILE or raises the existing
%      singleton*.
%
%      H = CPS_WRITE_TO_FILE returns the handle to a new CPS_WRITE_TO_FILE or the handle to
%      the existing singleton*.
%
%      CPS_WRITE_TO_FILE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CPS_WRITE_TO_FILE.M with the given input arguments.
%
%      CPS_WRITE_TO_FILE('Property','Value',...) creates a new CPS_WRITE_TO_FILE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cps_write_to_file_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cps_write_to_file_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cps_write_to_file

% Last Modified by GUIDE v2.5 11-Mar-2014 12:55:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cps_write_to_file_OpeningFcn, ...
                   'gui_OutputFcn',  @cps_write_to_file_OutputFcn, ...
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


% --- Executes just before cps_write_to_file is made visible.
function cps_write_to_file_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cps_write_to_file (see VARARGIN)

% Choose default command line output for cps_write_to_file
handles.output = hObject;

%remeber the main window handles for later
handles.cps = [];

cpsInput = find(strcmp(varargin, 'cps'));
if ~isempty(cpsInput)
   handles.cps = varargin{cpsInput+1};
   cps_handles = guidata(handles.cps);
end

% Publish the functions
handles.write_stiffness = @write_stiffness;
handles.write_elasticity = @write_elasticity;

handles.file_name = fullfile(cps_handles.current_dir, [regexprep(datestr(clock),'[: ]','-') 'results.txt']);
set(handles.s_file_name,'String',handles.file_name);
set(handles.t_output,'UserData',0);
handles.header_written = false;



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cps_write_to_file wait for user response (see UIRESUME)
% uiwait(handles.cps_write_to_file_output);


% --- Outputs from this function are returned to the command line.
function varargout = cps_write_to_file_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close cps_write_to_file_output.
function cps_write_to_file_output_CloseRequestFcn(hObject, eventdata, handles)
%can be closed only from CPS window
delete(hObject);
disp('ble');
function write_stiffness(hObject)
    %read
    handles = guidata(hObject);
    cps_handles = guidata(handles.cps);
    curve = cps_handles.current_curve;
    %open file
    f = fopen(handles.file_name,'at+');
    %write header if new file
    if ~handles.header_written
        fprintf(f,'%s\t%s\t\t%s\t%s\t%s\t%s\t%s\n',...
            'Curve name',...
            'Stiffness - slope 1 [pN/nm]',...
            'Stiffness - slope 2 [pN/nm]',...
            'Stiffness - slope 3 [pN/nm]',...
            'Length - slope 1 [nm]',...
            'Length - slope 2 [nm]',...
            'Length - slope 3 [nm]');
        %set table headers
        set(handles.t_output,'ColumnFormat',{'char' 'numeric' 'numeric' 'numeric' 'numeric' 'numeric' 'numeric'});
        set(handles.t_output,'ColumnName',{'Name' 'Stiffness1' 'Stiffness2' 'Stiffness3' 'Length1' 'Length2' 'Length3'});
        handles.header_written = true;
    end
    for i=1:3,
        stiffness(i) = 0;
        length(i) = 0;
    end
    for i=1:curve.stiffnessParams.numberOfSegments,
        segment = curve.stiffnessParams.stiffnessSegments{i};
        stiffness(i) = segment.slope*10^3*(-1);
        length(i) = segment.xLength*10^9;
    end
    
    %write data
    fprintf(f,'%s\t%f\t%f\t%f\t%f\t%f\t%f\n',...
        curve.name,...
        stiffness(1), stiffness(2), stiffness(3),...
        length(1),length(2), length(3));
    %write data to table
    data = get(handles.t_output,'Data');
    row = get(handles.t_output,'UserData')+1;
    data_row = {curve.name, stiffness(1), stiffness(2), stiffness(3), length(1), length(2), length(3)};
    %concat 'Data', if first row, then substitute
    try
        data = [data; data_row];
    catch
        data = data_row;
    end
    set(handles.t_output,'Data',data);
    set(handles.t_output,'UserData',row);
    
    fclose(f);
    %save handles
    guidata(hObject, handles);
    
function write_elasticity(hObject)
    %read
    handles = guidata(hObject);
    cps_handles = guidata(handles.cps);
    curve = cps_handles.current_curve;
    %open file
    f = fopen(handles.file_name,'at+');
    %write header if new file
    if ~handles.header_written
        fprintf(f,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n',...
            'Curve name',...
            'Model',...
            'Radius [nm]',...
            'E [Pa]',...
            'b',...
            'Z0 [nm]',...
            'Skip initial [nm]',...
            'Shift CP [nm]',...
            'CP position [nm]');
        %set table headers
        set(handles.t_output,'ColumnFormat',{'char' 'char' 'numeric' 'numeric' 'numeric' 'numeric' 'numeric' 'numeric' 'numeric'});
        set(handles.t_output,'ColumnName',{'Name' 'Model' 'Radius [nm]' 'E [Pa]' 'b' 'Z0 [nm]' 'Skip initial' 'Shift CP' 'CP position [nm]'});
        handles.header_written = true;
    end
    
    if curve.hasElasticityFit
        elasticityParams = curve.elasticityParams;
        %write data
        fprintf(f,'%s\t%s\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n',...
            curve.name,...
            elasticityParams.model, elasticityParams.radius*10^9, elasticityParams.E,...
            elasticityParams.b, elasticityParams.Z0*10^9, elasticityParams.excludeInitial,...
            elasticityParams.xShiftCP,elasticityParams.xContactPoint*10^9);
        %write data to table
        data = get(handles.t_output,'Data');
        row = get(handles.t_output,'UserData')+1;
        data_row = {curve.name, elasticityParams.model, elasticityParams.radius*10^9, elasticityParams.E,...
            elasticityParams.b, elasticityParams.Z0*10^9, elasticityParams.excludeInitial,...
            elasticityParams.xShiftCP,elasticityParams.xContactPoint*10^9};
        %concat 'Data', if first row, then substitute
        try
            data = [data; data_row];
        catch
            data = data_row;
        end
        set(handles.t_output,'Data',data);
        set(handles.t_output,'UserData',row);
    end
    fclose(f);
    %save handles
    guidata(hObject, handles);
