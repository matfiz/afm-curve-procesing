function varargout = cps(varargin)
% CPS MATLAB code for cps.fig
%      CPS, by itself, creates a new CPS or raises the existing
%      singleton*.
%
%      H = CPS returns the handle to a new CPS or the handle to
%      the existing singleton*.
%
%      CPS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CPS.M with the given input arguments.
%
%      CPS('Property','Value',...) creates a new CPS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cps_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cps_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cps

% Last Modified by GUIDE v2.5 20-Mar-2014 21:09:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cps_OpeningFcn, ...
                   'gui_OutputFcn',  @cps_OutputFcn, ...
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


% --- Executes just before cps is made visible.
function cps_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cps (see VARARGIN)

% Choose default command line output for cps
handles.output = hObject;

%call curve_parameters
handles.curveParameters = cps_curve_parameters('cps',hObject);

% set(hObject,'toolbar','figure');

%set variables

handles.save = 1; %is 0, if opened curves were not saved
handles.view_mode = 1;
%1 - approach&retract
%2 - approach only
%3 - retract only

%stress relaxation
handles.current_steps = []; %matrix for storing current adhesion steps
%give names to columns
cnames = {'<html><center />&delta;z</html>','<html><center />&delta;F</html>'};
set(handles.adhesion_table,'ColumnName',cnames);


%info about last processed directory
handles.current_dir = '';

%hide elements
set(handles.previous_button,'Visible','Off');
set(handles.next_button,'Visible','Off');
set(handles.curve_list,'Visible','Off');
set(handles.curve_info,'Visible','Off');
set(handles.axes_force_distance,'Visible','Off');
set(handles.adhesion_panel,'Visible','off');

%publish function
handles.drawPreviousContactPoint = @draw_previous_contact_point;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cps wait for user response (see UIRESUME)
% uiwait(handles.cps);

function save_to_fig(axes)
 F=getframe(axes); %select axes in GUI
    figure(); %new figure
    image(F.cdata); %show selected axes in new figure
    saveas(gcf, 'force-distance', 'fig'); %save figure
    close(gcf); %and close it


% --- Outputs from this function are returned to the command line.
function varargout = cps_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function CurveMenu_Callback(hObject, eventdata, handles)
% hObject    handle to CurveMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function LoadSingleCurveMenu_Callback(hObject, eventdata, handles)
% hObject    handle to LoadSingleCurveMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if  ~handles.save
    button = questdlg('Save opened curves?','File not saved','Yes','No','Cancel','Yes');
    if strcmp(button,'Yes')
        [filename, pathname,filterindex] = uiputfile('*.mat', 'Save curves to MAT file');
        krzywe=handles.curves;
        save(fullfile(pathname,filename),'krzywe');
        handles.save=1;    
    end        
    if strcmp(button,'Cancel')
         return;
    end
end
[FileName1,PathName,FilterIndex] = uigetfile(OpenFileFilter,'Choose curve to open');
if (FileName1)
    h = waitbar(0,'Please wait! Loading ...','WindowStyle','modal') ;
    handles.current_dir = PathName;
    if FilterIndex == 4 % jpk-force-map
        guidata(hObject, handles);
        parse_jpk_force_map(hObject, PathName, FileName1);
        handles = guidata(hObject);
        handles.current_curve_index = 1;
        handles.current_curve = handles.curves(1);
    else
        curve_info = ['Single curve loaded: ' FileName1];
        set(handles.curve_info,'String',curve_info);
        set(handles.curve_info,'Visible','On');
        handles.current_curve_index = 1;
        handles.curves(1) = parse_curve(PathName,FileName1,FilterIndex);
        handles.current_curve = handles.curves(handles.current_curve_index);
        read_to_gui(hObject,handles,1);
        handles.no_of_curves = 1;
    end
    close(h);
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function LoadDirectoryMenu_Callback(hObject, eventdata, handles)
% hObject    handle to LoadDirectoryMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if  ~handles.save
    button = questdlg('File not saved','Save opened curves?','Yes','No','Cancel','Yes');
    if strcmp(button,'Yes')
        [filename, pathname,filterindex] = uiputfile('*.mat', 'Save curves to MAT file');
        krzywe=handles.curves;
        save([pathname filename],'krzywe');
        handles.save=1;    
    end        
    if strcmp(button,'Cancel')
         return;
    end
end
[PathName] = uigetdir(handles.current_dir,'Choose dir to open');
handles.current_dir = PathName;
list = OpenFileFilter;
[selection,button] = listdlg('PromptString','Select files type:',...
                'Name','File type selection',...
                'SelectionMode','single',...
                'ListSize',[250 100],...
                'ListString',list(:,2));
FilterIndex = selection;
%read all txt files
files = dir(fullfile(PathName,OpenFileFilter(FilterIndex)));
%d(~[d.isdir])= [];
if FilterIndex == 2
%eliminate image data
    wrong = [];
    for i=1:size(files)
        if files(i).bytes > 60000
            wrong(end+1) = i;
        end
    end
    files(wrong) = [];
end

handles.no_of_curves = size(files);
handles.no_of_curves = handles.no_of_curves(1);
 h = waitbar(0,'Please wait! Loading ...','WindowStyle','modal') ;
  for i=1:handles.no_of_curves
      disp(['\' files(i).name]);
      handles.curves(i) = parse_curve(PathName,['\' files(i).name],FilterIndex);
      waitbar(i/handles.no_of_curves);
      file_names{i} = files(i).name;
  end
 handles.current_curve_index = 1;
 handles.current_curve = handles.curves(1);
 read_to_gui(hObject,handles,1); 
 handles.save = 0;
 set(handles.curve_list,'String', file_names);
 set(handles.previous_button,'Visible','On');
set(handles.next_button,'Visible','On');
set(handles.curve_list,'Visible','On');
 close(h);
guidata(hObject, handles);


% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PrintCurveMenu_Callback(hObject, eventdata, handles)
% hObject    handle to PrintCurveMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in curve_list.
function curve_list_Callback(hObject, eventdata, handles)
% hObject    handle to curve_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns curve_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from curve_list
handles.current_curve_index = get(hObject,'Value');
handles.current_curve = handles.curves(handles.current_curve_index);
set(handles.curve_list,'Value',handles.current_curve_index);
handles.current_steps = [];
read_to_gui(hObject,handles,handles.current_curve_index);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function curve_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to curve_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in previous_button.
function previous_button_Callback(hObject, eventdata, handles)
% hObject    handle to previous_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.current_curve_index > 1
     handles.curves(handles.current_curve_index) = handles.current_curve;
     handles.current_curve_index = handles.current_curve_index-1;
     handles.current_curve = handles.curves(handles.current_curve_index);
     set(handles.curve_list,'Value',handles.current_curve_index);
     handles.current_steps = [];
     read_to_gui(hObject,handles,handles.current_curve_index);
end
guidata(hObject, handles);


% --- Executes on button press in next_button.
function next_button_Callback(hObject, eventdata, handles)
% hObject    handle to next_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.current_curve_index < handles.no_of_curves
     handles.curves(handles.current_curve_index) = handles.current_curve;
     guidata(hObject, handles);
     handles.current_curve_index = handles.current_curve_index+1;
     handles.current_curve = handles.curves(handles.current_curve_index);
     set(handles.curve_list,'Value',handles.current_curve_index);
     handles.current_steps = [];
     read_to_gui(hObject,handles,handles.current_curve_index);
end
guidata(hObject, handles);


function f_spring_constant_Callback(hObject, eventdata, handles)
% hObject    handle to f_spring_constant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f_spring_constant as text
%        str2double(get(hObject,'String')) returns contents of f_spring_constant as a double


% --- Executes during object creation, after setting all properties.
function f_spring_constant_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_spring_constant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function f_sensitivity_Callback(hObject, eventdata, handles)
% hObject    handle to f_sensitivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f_sensitivity as text
%        str2double(get(hObject,'String')) returns contents of f_sensitivity as a double


% --- Executes during object creation, after setting all properties.
function f_sensitivity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_sensitivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function f_closed_loop_Callback(hObject, eventdata, handles)
% hObject    handle to f_closed_loop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f_closed_loop as text
%        str2double(get(hObject,'String')) returns contents of f_closed_loop as a double


% --- Executes during object creation, after setting all properties.
function f_closed_loop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_closed_loop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function f_extend_time_Callback(hObject, eventdata, handles)
% hObject    handle to f_extend_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f_extend_time as text
%        str2double(get(hObject,'String')) returns contents of f_extend_time as a double


% --- Executes during object creation, after setting all properties.
function f_extend_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_extend_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function f_extend_length_Callback(hObject, eventdata, handles)
% hObject    handle to f_extend_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f_extend_length as text
%        str2double(get(hObject,'String')) returns contents of f_extend_length as a double


% --- Executes during object creation, after setting all properties.
function f_extend_length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_extend_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function f_retract_time_Callback(hObject, eventdata, handles)
% hObject    handle to f_retract_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f_retract_time as text
%        str2double(get(hObject,'String')) returns contents of f_retract_time as a double


% --- Executes during object creation, after setting all properties.
function f_retract_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_retract_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function f_retract_length_Callback(hObject, eventdata, handles)
% hObject    handle to f_retract_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f_retract_length as text
%        str2double(get(hObject,'String')) returns contents of f_retract_length as a double


% --- Executes during object creation, after setting all properties.
function f_retract_length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_retract_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function f_pause_length_Callback(hObject, eventdata, handles)
% hObject    handle to f_pause_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f_pause_length as text
%        str2double(get(hObject,'String')) returns contents of f_pause_length as a double


% --- Executes during object creation, after setting all properties.
function f_pause_length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_pause_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function f_pause_time_Callback(hObject, eventdata, handles)
% hObject    handle to f_pause_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f_pause_time as text
%        str2double(get(hObject,'String')) returns contents of f_pause_time as a double


% --- Executes during object creation, after setting all properties.
function f_pause_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_pause_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function f_mode_Callback(hObject, eventdata, handles)
% hObject    handle to f_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f_mode as text
%        str2double(get(hObject,'String')) returns contents of f_mode as a double


% --- Executes during object creation, after setting all properties.
function f_mode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --------------------------------------------------------------------
function toggle_adhesion_OnCallback(hObject, eventdata, handles)
% hObject    handle to toggle_adhesion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.adhesion_panel,'Visible','on');


% --------------------------------------------------------------------
function toggle_adhesion_OffCallback(hObject, eventdata, handles)
% hObject    handle to toggle_adhesion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.adhesion_panel,'Visible','off');


% --------------------------------------------------------------------
function toolbar_toggle_curve_parameters_OnCallback(hObject, eventdata, handles)
% hObject    handle to toolbar_toggle_curve_parameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.curveParameters = cps_curve_parameters('cps',hObject);
guidata(hObject, handles);

% --------------------------------------------------------------------
function toolbar_toggle_curve_parameters_OffCallback(hObject, eventdata, handles)
% hObject    handle to toolbar_toggle_curve_parameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.curveParameters);
guidata(hObject, handles);

% --- Executes on button press in b_get_step.
function b_get_step_Callback(hObject, eventdata, handles)
% hObject    handle to b_get_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Loop, picking up the points.
set(handles.status_bar,'Visible','On');
set(handles.status_bar,'String','Left click on the first point of the step, right click on the second one.');
but = 1;
z1=0;
F1=0;
axes(handles.axes_force_distance);
hold on;
while but == 1
    [x,y,but] = ginputax(handles.axes_force_distance,1);
    if but == 1
        z1=x;
        F1=y;
    end
end
z2=x;
F2=y;
last_point = plot(z1,F1,'gx',z2,F2,'gx','MarkerSize',13,'LineWidth',2);
handles.last_step_plotted = last_point;
dz = abs(z1-z2);
dF = abs(F1-F2);
[wierszy,kolumn] = size(handles.current_steps);
handles.current_steps(wierszy+1,:) = [z1,F1,z2,F2,dz,dF];
set(handles.adhesion_table,'Data',handles.current_steps(:,5:6));
curve = Curve;
curve = handles.curves(handles.current_curve_index);
curve.dataSteps = handles.current_steps;
handles.curves(handles.current_curve_index) = curve;
handles.current_curve = curve;
set(handles.b_delete_last_step,'Enable','On');
guidata(hObject, handles);

    


% --- Executes on button press in b_delete_last_step.
function b_delete_last_step_Callback(hObject, eventdata, handles)
% hObject    handle to b_delete_last_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes_force_distance);
delete(handles.last_step_plotted);
[wierszy,kolumn] = size(handles.current_steps);
steps = handles.current_steps(1:wierszy-1,:);
handles.current_steps = steps;
set(handles.adhesion_table,'Data',handles.current_steps(:,5:6));
set(handles.b_delete_last_step,'Enable','Off');
guidata(hObject, handles);


% --------------------------------------------------------------------
function save_data_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to save_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button = questdlg('Save it?','The processed curves are not saved','Yes','No','Cancel','Yes');
    if strcmp(button,'Yes')
        [filename, pathname,filterindex] = uiputfile('*.mat', 'Save curves to MAT file');
        krzywe=handles.curves;
        save([pathname filename],'krzywe');
        handles.save=1;    
    end   
    if strcmp(button,'Cancel')
         return;
    end


% --------------------------------------------------------------------
function OpenSavedCurves_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to OpenSavedCurves (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.mat','Select the file with curves to load');
h = waitbar(0,'Please wait! Loading ...','WindowStyle','modal') ;
load([pathname filename]);
handles.curves = krzywe;
[no_of_curves len] = size(krzywe);
%curve_info = [no_of_curves 'curves loaded'];
%set(handles.curve_info,'String',curve_info);
%set(handles.curve_info,'Visible','On');
handles.no_of_curves = numel(krzywe);
handles.current_curve_index = 1;
handles.current_curve = handles.curves(handles.current_curve_index);
handles.current_steps = handles.current_curve.dataSteps;
read_to_gui(hObject,handles,1);
set(handles.axes_force_time,'Visible','On');
set(handles.axes_force_distance,'Visible','On');
 handles.save = 0;
 %set(handles.curve_list,'String', file_names);
 set(handles.previous_button,'Visible','On');
set(handles.next_button,'Visible','On');
set(handles.curve_list,'Visible','On');
handles.current_dir = [pathname];
close(h);
guidata(hObject, handles);


% --- Executes on button press in export_steps_txt.
function export_steps_txt_Callback(hObject, eventdata, handles)
% hObject    handle to export_steps_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

header = {'File name', 'z1 [m]', 'F1 [N]', 'z2 [m]', 'F2 [N]', 'dz [m]', 'dF [N]'};
all_step_data = header;
for i=1:handles.no_of_curves
    data_length = size(handles.curves(i).dataSteps);
    for j=1:data_length(1)
        row = [handles.curves(i).name, num2cell(handles.curves(i).dataSteps(j,:))];
        all_step_data(end+1,:) = row;
    end
end
[filename, pathname,filterindex] = uiputfile('*.xls', 'Save step data to Excel');
h = waitbar(0,'Please wait! Loading ...','WindowStyle','modal') ;
xlswrite([pathname filename],all_step_data);
close(h);


% --------------------------------------------------------------------
function load_test_data_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to load_test_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
curve_info = ['Single curve loaded: jpk.txt'];
set(handles.curve_info,'String',curve_info);
set(handles.curve_info,'Visible','On');
handles.current_curve_index = 1;
handles.curves(1) = parse_curve('./test_data/','jpk.txt',1);
handles.current_curve = handles.curves(handles.current_curve_index);
read_to_gui(hObject,handles,1);
handles.no_of_curves = 1;
guidata(hObject, handles);

% --------------------------------------------------------------------
function load_test_data_di_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to load_test_data_di (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
curve_info = ['Single curve loaded: komorka00000.021'];
set(handles.curve_info,'String',curve_info);
set(handles.curve_info,'Visible','On');
handles.current_curve_index = 1;
handles.curves(1) = parse_curve('./test_data/','komorka00000.021',2);
handles.current_dir = [pwd '/test_data/'];
handles.current_curve = handles.curves(handles.current_curve_index);
read_to_gui(hObject,handles,1);
handles.no_of_curves = 1;
guidata(hObject, handles);


% --- Executes when user attempts to close cps.
function cps_CloseRequestFcn(hObject, eventdata, handles)
delete(handles.curveParameters);
try
 delete(handles.stiffnessPanel);
catch
 disp('Stiffness panel inactive');
end
try
 elasticity_handles = guidata(handles.elasticityPanel);
 delete(elasticity_handles.fileOutputElasticity);
 delete(handles.elasticityPanel);
catch
 disp('Elasticity panel inactive.');
end
try
 delete(handles.fileOutput);
 panels = findobj('Tag','elasticity_file_output');
 delete(panels);
catch
 disp('File output panel inactive');
end
try 
 relaxationPanel = findobj('tag','cps_stress_relaxation');
 delete(relaxationPanel);
catch err
end;
delete(hObject);


% --------------------------------------------------------------------
function toggle_stiffness_panel_OnCallback(hObject, eventdata, handles)
% hObject    handle to toggle_stiffness_panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%call curve_parameters
handles.fileOutput = cps_write_to_file('cps',hObject);
handles.stiffnessPanel = cps_stiffness_panel('cps',hObject);
handles.b_create_line_fit = uicontrol('Parent',handles.output,...
                'Style','pushbutton',...
                'String','Fit line ---',...
                'FontSize',8,...
                'FontWeight','bold',...
                'ForegroundColor', [1 1 1],...
                'Position',[560 10 100 30],...
                'Backgroundcolor', [0 0.4 0.4],...
                'Callback', {@createLineFit,hObject});
guidata(hObject, handles);


% --------------------------------------------------------------------
function toggle_stiffness_panel_OffCallback(hObject, eventdata, handles)
% hObject    handle to toggle_stiffness_panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.stiffnessPanel);
delete(handles.fileOutput);
delete(handles.b_create_line_fit);
%remove callbacks
set(handles.output, ...
   'WindowButtonDownFcn', '', ...
   'WindowButtonUpFcn', '',...
   'WindowButtonMotionFcn','');
%delete cursor lines
cursorLines = findobj(handles.axes_force_distance, 'type', 'line', 'Tag', 'cursor');
for i=1:length(cursorLines)
    delete(cursorLines(i));
end
guidata(hObject, handles);

          
function createLineFit(hObj,event,hObject)
    handles = guidata(hObject);
    %select_points
    set(handles.status_bar,'String','Left click on the first point, right click on the end point.')
    set(handles.status_bar,'Visible','On');
    but = 1;
    axes(handles.axes_force_distance);
    hold on;
    handles.auxiliary_line = StiffnessSegment;
    %get graph data
    xData = handles.current_curve.dataHeightMeasured(1:handles.current_curve.extendLength);
    yData = handles.current_curve.dataDeflection(1:handles.current_curve.extendLength);
    %wait for left, then right mouse button press
    while but == 1
        [x,y,but] = ginputax(handles.axes_force_distance,1);
        if but == 1
            Min = findClosestPoint(x,y,xData,yData);
            handles.auxiliary_line.xStartPos = Min(1);
            handles.auxiliary_line.yStartPos = Min(2);
        end
    end
    Min = findClosestPoint(x,y,xData,yData);
    handles.auxiliary_line.xEndPos = Min(1);
    handles.auxiliary_line.yEndPos = Min(2);
    set(handles.status_bar,'Visible','Off');
    %fit line
    indexStart = find(xData == handles.auxiliary_line.xStartPos);
    indexEnd = find(xData == handles.auxiliary_line.xEndPos);
    %if points clicked in the oposite order, switch them
    if indexStart > indexEnd
        temp = indexStart;
        indexStart = indexEnd;
        indexEnd = temp;
    end
    yData = handles.current_curve.dataDeflection(indexStart:indexEnd);
    xData = handles.current_curve.dataHeightMeasured(indexStart:indexEnd);
    [p,S] = polyfit(xData,yData,1);
    handles.auxiliary_line.slope = p(1);
    handles.auxiliary_line.freeCoef = p(2);
    %save
    guidata(hObject, handles);
    %plot
    plotAuxiliaryLine(hObj,handles);
    
function plotAuxiliaryLine(hObject,handles)
    if ~(length(get(handles.axes_force_distance, 'UserData')) == 0)
       graph_handles = get(handles.axes_force_distance, 'UserData');
    end
    %delete old line
    try
        for j=1:3,
            delete(graph_handles{j});
        end
    catch err
    end
    %draw points
    hold(handles.axes_force_distance,'on');
    current_segment = handles.auxiliary_line;
    points = plot(handles.axes_force_distance,...
            current_segment.xStartPos,current_segment.yStartPos,'gx',...
            current_segment.xEndPos,current_segment.yEndPos,'gx',...
            'MarkerSize',13,...
            'LineWidth',2,...
            'Color', [0, 1.0, 0.0]);
    graph_handles{1} = points;
    
    %select fragment
    indexStart = find(handles.current_curve.dataHeightMeasured == handles.auxiliary_line.xStartPos);
    indexEnd = find(handles.current_curve.dataHeightMeasured == handles.auxiliary_line.xEndPos);
    
    %select Data
    yData = handles.current_curve.dataDeflection;
    xData = handles.current_curve.dataHeightMeasured;
    yFit = current_segment.slope*xData+current_segment.freeCoef;
    
    segment = plot(handles.axes_force_distance,xData(indexStart:indexEnd),yFit(indexStart:indexEnd),...
        'LineWidth',2,...
        'Color', [0.46, 0.65, 0.2]);
    line = plot(handles.axes_force_distance,xData(indexStart:end),yFit(indexStart:end),...
        'LineWidth',0.5,...
        'Color', [0.46, 0.65, 0.2]);
    graph_handles{2} = segment;
    graph_handles{3} = line;
    %save
   	set(handles.axes_force_distance, 'UserData',graph_handles);
    guidata(hObject, handles);
    
function draw_previous_contact_point(hObject, handles)
    try
        x_contact_point = handles.current_curve.stiffnessParams.xContactPoint;
        y_contact_point = handles.current_curve.stiffnessParams.xContactPoint;
        yRange = ylim(handles.axes_force_distance);
        line([x_contact_point x_contact_point],...
            yRange,...
            'LineWidth',2,...
            'Color', [0, 1.0, 0.0],...
            'Parent',handles.axes_force_distance);
    catch err
    end


% --------------------------------------------------------------------
function toggle_elasticity_panel_OnCallback(hObject, eventdata, handles)
% hObject    handle to toggle_elasticity_panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles.fileOutput = cps_write_to_file('cps',hObject);
handles.elasticityPanel = cps_elasticity_panel('cps',hObject);
guidata(hObject, handles);


% --------------------------------------------------------------------
function toggle_elasticity_panel_OffCallback(hObject, eventdata, handles)
% hObject    handle to toggle_elasticity_panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.elasticityPanel);
guidata(hObject, handles);


% --------------------------------------------------------------------
function toggle_context_menu_OnCallback(hObject, eventdata, handles)
% hObject    handle to toggle_context_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Define a context menu; it is not attached to anything
hcmenu = uicontextmenu;
% Define callbacks for context menu items that change linestyle
hcb1 = ['saveas(gca,''force-distance'',''jpg'')'];
%hcb2 = ['saveas(gca,''force-time'',''pdf'')'];
hcb2 = ['printpreview(gcf)'];
hcb3 = ['plotedit(gcf, ''plotedittoolbar'', ''toggle'')'];
% Define the context menu items and install their callbacks
item1 = uimenu(hcmenu, 'Label', 'Save as fig', 'Callback', hcb1);
item2 = uimenu(hcmenu, 'Label', 'Print preview', 'Callback', hcb2);
item3 = uimenu(hcmenu, 'Label', 'Edit plot', 'Callback', hcb3);
% Locate line objects
set(handles.axes_force_distance,'uicontextmenu',hcmenu);
set(handles.axes_force_time,'uicontextmenu',hcmenu);

% --------------------------------------------------------------------
function toggle_context_menu_OffCallback(hObject, eventdata, handles)
% hObject    handle to toggle_context_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(get(get(handles.axes_force_distance,'UIContextMenu'),'Children'),'Visible','off')


% --------------------------------------------------------------------
function toggle_stress_relaxation_OnCallback(hObject, eventdata, handles)
% hObject    handle to toggle_stress_relaxation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.relaxationPanel = cps_stress_relaxation('cps',hObject);
guidata(hObject, handles);

% --------------------------------------------------------------------
function toggle_stress_relaxation_OffCallback(hObject, eventdata, handles)
% hObject    handle to toggle_stress_relaxation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.relaxationPanel);
guidata(hObject, handles);
