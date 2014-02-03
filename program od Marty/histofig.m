function varargout = histofig(varargin)
% HISTOFIG M-file for histofig.fig
%      HISTOFIG, by itself, creates a new HISTOFIG or raises the existing
%      singleton*.
%
%      H = HISTOFIG returns the handle to a new HISTOFIG or the handle to
%      the existing singleton*.
%
%      HISTOFIG('Property','Value',...) creates a new HISTOFIG using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to histofig_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      HISTOFIG('CALLBACK') and HISTOFIG('CALLBACK',hObject,...) call the
%      local function named CALLBACK in HISTOFIG.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help histofig

% Last Modified by GUIDE v2.5 22-Feb-2004 12:42:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @histofig_OpeningFcn, ...
                   'gui_OutputFcn',  @histofig_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before histofig is made visible.
function histofig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for histofig
handles.output = hObject;

x=varargin{1};
n=varargin{2};
handles.x=x;
handles.n=n;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes histofig wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = histofig_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function AUX_MENU_Callback(hObject, eventdata, handles)
% hObject    handle to AUX_MENU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Export_MENU_Callback(hObject, eventdata, handles)
% hObject    handle to Export_MENU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

x=handles.x;
n=handles.n;

[filename, pathname,filterindex] = uiputfile('*.*', 'Save histogram.');
if filename
   fid=fopen([pathname filename],'wt');
   data(1,:)=x;
   data(2,:)=n;
   fprintf(fid,'%f      %f\n',data);
   fclose(fid);
end


% --------------------------------------------------------------------
function Title_MENU_Callback(hObject, eventdata, handles)
% hObject    handle to Title_MENU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ans=inputdlg('Input histogram title','Title',1);
title(ans);

%------------------------------------------------------------------------
% --------------------------------------------------------------------
function Normalize_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Export_MENU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

x=handles.x;
n=handles.n;
n=n/sum(n);

bar(x,n);
xlabel('F[nN]');
ylabel('Frequency');

handles.x=x;
handles.n=n;

