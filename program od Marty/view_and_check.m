function varargout = view_and_check(varargin)
% VIEW_AND_CHECK M-file for view_and_check.fig
%      VIEW_AND_CHECK, by itself, creates a new VIEW_AND_CHECK or raises the existing
%      singleton*.
%
%      H = VIEW_AND_CHECK returns the handle to a new VIEW_AND_CHECK or the handle to
%      the existing singleton*.
%
%      VIEW_AND_CHECK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEW_AND_CHECK.M with the given input arguments.
%
%      VIEW_AND_CHECK('Property','Value',...) creates a new VIEW_AND_CHECK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before view_and_check_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to view_and_check_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help view_and_check

% Last Modified by GUIDE v2.5 27-Feb-2004 18:17:57


%-----------------------------------------------------------------
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @view_and_check_OpeningFcn, ...
                   'gui_OutputFcn',  @view_and_check_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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





%-----------------------------------------------------------------
% --- Executes just before view_and_check is made visible.
function view_and_check_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to view_and_check (see VARARGIN)

% Choose default command line output for view_and_check
handles.output = hObject;

% my variables
handles.krzywe = 0;
handles.viewtype=1; %  single, approach all, retract all
handles.scaling=1;  %  contst, float
handles.viewmode=1; % both, approach, retract
handles.reference=0;
handles.referenceno=1;
handles.save=1;


% Update handles structure

set(handles.nextbutton,'Enable','Off');
set(handles.prevbutton,'Enable','Off');
set(handles.removebutton,'Enable','Off');
set(handles.gotoedit,'Enable','Off');
set(handles.curveslider,'Enable','Off');

set(handles.constantbutton,'Enable','Off');
set(handles.floatbutton,'Enable','Off');
set(handles.userbutton,'Enable','Off');


set(handles.bothbutton,'Enable','Off');
set(handles.approachbutton,'Enable','Off');
set(handles.retractbutton,'Enable','Off');

set(handles.referencebutton,'Enable','Off');
set(handles.referenceedit,'Enable','Off');

set(handles.Plot_menu,'Enable','Off');

set(handles.Add_curves_menu,'Enable','Off');
set(handles.Calc_menu,'Enable','Off');

set(handles.SMVH_menu,'Enable','Off');
set(handles.MVHver_menu,'Enable','Off');

set(handles.export_to_workspace_menu,'Enable','Off');
set(handles.Export_curve_menu,'Enable','Off');

guidata(hObject, handles);

% UIWAIT makes view_and_check wait for user response (see UIRESUME)

%uiwait(handles.figure1);




%-----------------------------------------------------------------
% --- Outputs from this function are returned to the command line.
function varargout = view_and_check_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
%varargout{2} = handles.krzywe;


%-----------------------------------------------------------------
% --- Executes on button press in (NEXT).
function nextbutton_Callback(hObject, eventdata, handles)
% hObject    handle to nextbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

krzywe=handles.krzywe;
if (handles.currkrzywa<krzywe.n)
    handles.currkrzywa=handles.currkrzywa+1;
    plotkrzywa(hObject,handles);
    guidata(hObject, handles);
end

%-----------------------------------------------------------------
% --- Executes on button press in prevbutton. (PREV)
function prevbutton_Callback(hObject, eventdata, handles)
% hObject    handle to prevbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

krzywe=handles.krzywe;
if (handles.currkrzywa>1)
    handles.currkrzywa=handles.currkrzywa-1;
    plotkrzywa(hObject,handles);
    guidata(hObject, handles);
end

%-----------------------------------------------------------------
function gotoedit_Callback(hObject, eventdata, handles) % (GOTO curve)
% hObject    handle to gotoedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gotoedit as text
%        str2double(get(hObject,'String')) returns contents of gotoedit as a double

krzywe=handles.krzywe;
itemp=str2double(get(hObject,'String'));

if (itemp<=krzywe.n) && (itemp>=1)
     i=itemp;    
     handles.currkrzywa=i;
     plotkrzywa(hObject,handles);
     set(hObject,'String','');
     guidata(hObject, handles);
end


%-----------------------------------------------------------------

% --- Executes on slider movement.
function curveslider_Callback(hObject, eventdata, handles)
% hObject    handle to curveslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

krzywe=handles.krzywe;
val=get(hObject,'Value');
vmax=get(hObject,'Max');
vmin=get(hObject,'Min');

i=round((krzywe.n-1)/(vmax-vmin)*val);
if (i<1) i=1; end
if (i>krzywe.n) i=krzywe.n; end
    

handles.currkrzywa=i;
plotkrzywa(hObject,handles);
set(hObject,'String','');
guidata(hObject, handles);


%-----------------------------------------------------------------

% --- Executes on button press in removebutton. (REMOVE)
function removebutton_Callback(hObject, eventdata, handles)
% hObject    handle to removebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

button = questdlg('Remove this curve?','Attention!','Yes','No','No');
if strcmp(button,'No')
    return
end

krzywe=handles.krzywe;

if (krzywe.n>1) 
    lista=1:krzywe.n;
    maska=lista~=handles.currkrzywa;
    gdzie=find(maska);
    t_do(:,:)=krzywe.t_do(gdzie,:);
    z_do(:,:)=krzywe.z_do(gdzie,:);
    F_do(:,:)=krzywe.F_do(gdzie,:);
    t_od(:,:)=krzywe.t_od(gdzie,:);
    z_od(:,:)=krzywe.z_od(gdzie,:);
    F_od(:,:)=krzywe.F_od(gdzie,:);
    for i=1:length(gdzie)
        fname{i}=krzywe.fname{gdzie(i)};
    end
    krzywe.t_do=t_do;
    krzywe.z_do=z_do;
    krzywe.F_do=F_do;
    krzywe.t_od=t_od;
    krzywe.z_od=z_od;
    krzywe.F_od=F_od;
    krzywe.n=krzywe.n-1;
    krzywe.fname=fname;
    handles.krzywe=krzywe;
    if handles.currkrzywa>1
        handles.currkrzywa=handles.currkrzywa-1;
    end
    handles.save=0;
    markunsave(handles);
    
    set(handles.MVHver_menu,'Enable','Off');
    set(handles.SMVH_menu,'Enable','Off');
    
    krzywe.mvh=0;
    plotkrzywa(hObject,handles);
    guidata(hObject, handles);
end

% --------------------------------------------------------------------
function File_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to File_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Import_curves_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Import_curves_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if  ~handles.save
    button = questdlg('Save it?','File not saved','Yes','No','Cancel','Yes');
    if strcmp(button,'Yes')
        [filename, pathname,filterindex] = uiputfile('*.mat', 'Save curves to MAT file');
        krzywe=handles.krzywe;
        save([pathname filename],'krzywe');
        handles.save=1;    
    end        
    if strcmp(button,'Cancel')
         return;
    end
end

krzywe=readkurwy(handles);
if (isstruct(krzywe)) 
    krzywe.mvh=0;
    handles.krzywe=krzywe;
    handles.currkrzywa=1;
    plotkrzywa(hObject,handles);
    
    set(handles.nextbutton,'Enable','On');
    set(handles.prevbutton,'Enable','On');
    set(handles.removebutton,'Enable','On');
    set(handles.gotoedit,'Enable','On');
    set(handles.curveslider,'Enable','On');

    set(handles.constantbutton,'Enable','On');
    set(handles.floatbutton,'Enable','On');
    set(handles.userbutton,'Enable','On');

    set(handles.bothbutton,'Enable','On');
    set(handles.approachbutton,'Enable','On');
    set(handles.retractbutton,'Enable','On');

    set(handles.referencebutton,'Enable','On');
    set(handles.referenceedit,'Enable','On');

    set(handles.Plot_menu,'Enable','On');

    set(handles.Add_curves_menu,'Enable','On');
    set(handles.Calc_menu,'Enable','On');
   
    set(handles.sourcetext,'String','Source: Import');

    set(handles.MVHver_menu,'Enable','Off');
    set(handles.SMVH_menu,'Enable','Off');
    
    set(handles.export_to_workspace_menu,'Enable','On');
    set(handles.Export_curve_menu,'Enable','On');
    
    handles.viewtype=1; % SINGLE
    handles.save=0;
    markunsave(handles);
    guidata(hObject, handles);
end



% --------------------------------------------------------------------
function Load_curves_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



if  ~handles.save
    button = questdlg('Save it?','File not saved','Yes','No','Cancel','Yes');
    if strcmp(button,'Yes')
        [filename, pathname,filterindex] = uiputfile('*.mat', 'Save curves to MAT file');
        krzywe=handles.krzywe;
        save([pathname filename],'krzywe');
        handles.save=1;    
    end   
    if strcmp(button,'Cancel')
         return;
    end
end


[filename, pathname,filterindex] = uigetfile('*.mat', 'Load curves from MAT file');
if (filename)
    s=load([pathname filename]);
    handles.krzywe=s.krzywe;
    if (~isfield(handles.krzywe,'mvh'))
        handles.krzywe.mvh=0;
    end
    handles.currkrzywa=1;
    plotkrzywa(hObject,handles);

    
        set(handles.nextbutton,'Enable','On');
    set(handles.prevbutton,'Enable','On');
    set(handles.removebutton,'Enable','On');
    set(handles.gotoedit,'Enable','On');
    set(handles.curveslider,'Enable','On');

    set(handles.constantbutton,'Enable','On');
    set(handles.floatbutton,'Enable','On');
    set(handles.userbutton,'Enable','On');

    
    set(handles.bothbutton,'Enable','On');
    set(handles.approachbutton,'Enable','On');
    set(handles.retractbutton,'Enable','On');

    set(handles.referencebutton,'Enable','On');
    set(handles.referenceedit,'Enable','On');

    set(handles.Plot_menu,'Enable','On');

    set(handles.Add_curves_menu,'Enable','On');
    set(handles.Calc_menu,'Enable','On');
    
    set(handles.export_to_workspace_menu,'Enable','On');
    set(handles.Export_curve_menu,'Enable','On');
   
    set(handles.sourcetext,'String',['Source:' pathname filename]);

    if (handles.krzywe.mvh)
        set(handles.MVHver_menu,'Enable','On');
        set(handles.SMVH_menu,'Enable','On');
    else 
        set(handles.MVHver_menu,'Enable','Off');
        set(handles.SMVH_menu,'Enable','Off');
    end

    handles.viewtype=1; % SINGLE
    handles.save=1;
    guidata(hObject, handles);

end
% --------------------------------------------------------------------
function Save_curves_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Save_curves_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[filename, pathname,filterindex] = uiputfile('*.mat', 'Save curves to MAT file');
if (filename)
    krzywe=handles.krzywe;
    save([pathname filename],'krzywe');
    set(handles.sourcetext,'String',['Source: ' pathname filename]);
    handles.save=1;
    marksave(handles);
end

%-------------------------------------------------------------------
function generalplot(hObject,handles)
    if (handles.viewtype==1)
        plotkrzywa(hObject,handles);
    end
    if (handles.viewtype==2)
        plotkrzyweapproach(hObject,handles);
    end
    if (handles.viewtype==3)
        plotkrzyweretract(hObject,handles);
    end


%-------------------------------------------------------------------
function plotkrzyweapproach(hObject,handles)

axprev=gca;
axes(handles.axes1);

krzywe=handles.krzywe;
plot(krzywe.z_do(1,:),krzywe.F_do);
set(handles.filetext,'String','Approach');
set(handles.curvetext,'String',['Curve No. ' '- all']);
xlabel('z [\mu m]');
ylabel('F [nN]');
grid on
set(gca,'Tag','axes1');
axes(axprev);
guidata(hObject, handles);

%-------------------------------------------------------------------
function plotkrzyweretract(hObject,handles)

axprev=gca;
axes(handles.axes1);

krzywe=handles.krzywe;
plot(krzywe.z_od(1,:),krzywe.F_od);
set(handles.filetext,'String','Retract');
set(handles.curvetext,'String',['Curve No. ' '- all']);
xlabel('z [\mu m]');
ylabel('F [nN]');
grid on
set(gca,'Tag','axes1');
axes(axprev);
guidata(hObject, handles);

%-----------------------------------------------------------------

% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


%-----------------------------------------------------------------


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if handles.save
    button = questdlg('Are you sure to EXIT','Exiting','Yes','No','No')
    if strcmp(button,'Yes')
        %uiresume(handles.figure1);
        delete(hObject);
    end
else
    button = questdlg('Save it?','File not saved','Yes','No','Cancel','Yes');
    if strcmp(button,'Yes')
        [filename, pathname,filterindex] = uiputfile('*.mat', 'Save curves to MAT file');
        krzywe=handles.krzywe;
        save([pathname filename],'krzywe');
    end
   if strcmp(button,'No')  
        %uiresume(handles.figure1);
        delete(hObject);
    end
    
    
end

%-----------------------------------------------------------------

% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%uiresume(handles.figure1);


% --------------------------------------------------------------------
function Plot_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function View_single_menu_Callback(hObject, eventdata, handles)
% hObject    handle to View_single_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.viewtype=1; % SINGLE

set(handles.nextbutton,'Enable','On');
set(handles.prevbutton,'Enable','On');
set(handles.gotoedit,'Enable','On');
set(handles.removebutton,'Enable','On');
set(handles.constantbutton,'Enable','On');
set(handles.floatbutton,'Enable','On');
set(handles.userbutton,'Enable','On');
set(handles.bothbutton,'Enable','On');
set(handles.approachbutton,'Enable','On');
set(handles.retractbutton,'Enable','On');
set(handles.referencebutton,'Enable','On');
set(handles.referenceedit,'Enable','On');

plotkrzywa(hObject,handles);
guidata(hObject, handles);


% --------------------------------------------------------------------
function View_approach_all_menu_Callback(hObject, eventdata, handles)
% hObject    handle to View_approach_all_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.viewtype=2; %

set(handles.nextbutton,'Enable','Off');
set(handles.prevbutton,'Enable','Off');
set(handles.gotoedit,'Enable','Off');
set(handles.removebutton,'Enable','Off');
set(handles.constantbutton,'Enable','Off');
set(handles.floatbutton,'Enable','Off');
set(handles.userbutton,'Enable','Off');
set(handles.referencebutton,'Enable','Off');
set(handles.referenceedit,'Enable','Off');
set(handles.bothbutton,'Enable','Off');
set(handles.approachbutton,'Enable','Off');
set(handles.retractbutton,'Enable','Off');

plotkrzyweapproach(hObject,handles);
guidata(hObject, handles);

% --------------------------------------------------------------------
function View_retract_all_menu_Callback(hObject, eventdata, handles)
% hObject    handle to View_retract_all_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles.viewtype=3; % SINGLE

set(handles.nextbutton,'Enable','Off');
set(handles.prevbutton,'Enable','Off');
set(handles.gotoedit,'Enable','Off');
set(handles.removebutton,'Enable','Off');
set(handles.constantbutton,'Enable','Off');
set(handles.floatbutton,'Enable','Off');
set(handles.userbutton,'Enable','Off');
set(handles.referencebutton,'Enable','Off');
set(handles.referenceedit,'Enable','Off');
set(handles.bothbutton,'Enable','Off');
set(handles.approachbutton,'Enable','Off');
set(handles.retractbutton,'Enable','Off');


plotkrzyweretract(hObject,handles);
guidata(hObject, handles);

%-----------------------------------------------------------------

% --- Executes on button press in zoombutton.
function zoombutton_Callback(hObject, eventdata, handles)
% hObject    handle to zoombutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

zoom;

%-----------------------------------------------------------------

% --- Executes on button press in constantbutton. (SCALING - Const)
function constantbutton_Callback(hObject, eventdata, handles)
% hObject    handle to constantbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of constantbutton
handles.scaling=1;
set(handles.constantbutton,'Value',1)
set(handles.floatbutton,'Value',0)
set(handles.userbutton,'Value',0)

guidata(hObject, handles);

if (handles.viewtype==1)
    plotkrzywa(hObject,handles);
end

%-----------------------------------------------------------------

% --- Executes on button press in floatbutton. (SCALING - float)
function floatbutton_Callback(hObject, eventdata, handles)
% hObject    handle to floatbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of floatbutton

handles.scaling=0;
set(handles.constantbutton,'Value',0)
set(handles.floatbutton,'Value',1)
set(handles.userbutton,'Value',0)

if (handles.viewtype==1)
    plotkrzywa(hObject,handles);
end
guidata(hObject, handles);


%-----------------------------------------------------------------


% --- Executes on button press in userbutton.
function userbutton_Callback(hObject, eventdata, handles)
% hObject    handle to userbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of userbutton



handles.scaling=2;
set(handles.constantbutton,'Value',0)
set(handles.floatbutton,'Value',0)
set(handles.userbutton,'Value',1)
guidata(hObject, handles);

prompt={'Z MIN:','Z MAX','F MIN','F MAX'};
tit='Set axis scaling';
answ=inputdlg(prompt,tit,[1 20]);
if (~isempty(answ))
    handles.userminz=str2num(answ{1});
    handles.usermaxz=str2num(answ{2});
    handles.userminF=str2num(answ{3});
    handles.usermaxF=str2num(answ{4});
    handles.scaling=2;
    guidata(hObject, handles);

    if (handles.viewtype==1)
        plotkrzywa(hObject,handles);
    end
end



%-----------------------------------------------------------------

% --- Executes during object creation, after setting all properties.
function gotoedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gotoedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%-----------------------------------------------------------------

% --- Executes on button press in bothbutton.
function bothbutton_Callback(hObject, eventdata, handles)
% hObject    handle to bothbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bothbutton
handles.viewmode=1;
set(handles.bothbutton,'Value',1)
set(handles.approachbutton,'Value',0)
set(handles.retractbutton,'Value',0)

if (handles.viewtype==1)
    plotkrzywa(hObject,handles);
end
guidata(hObject, handles);

%-----------------------------------------------------------------

% --- Executes on button press in approachbutton.
function approachbutton_Callback(hObject, eventdata, handles)
% hObject    handle to approachbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of approachbutton
handles.viewmode=2;
set(handles.bothbutton,'Value',0)
set(handles.approachbutton,'Value',1)
set(handles.retractbutton,'Value',0)
guidata(hObject, handles);

if (handles.viewtype==1)
    plotkrzywa(hObject,handles);
end

guidata(hObject, handles);

%-----------------------------------------------------------------

% --- Executes on button press in retractbutton.
function retractbutton_Callback(hObject, eventdata, handles)
% hObject    handle to retractbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of retractbutton

handles.viewmode=3;
set(handles.bothbutton,'Value',0)
set(handles.approachbutton,'Value',0)
set(handles.retractbutton,'Value',1)

if (handles.viewtype==1)
    plotkrzywa(hObject,handles);
end
guidata(hObject, handles);

%-----------------------------------------------------------------


% --- Executes on button press in referencebutton.
function referencebutton_Callback(hObject, eventdata, handles)
% hObject    handle to referencebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of referencebutton

if handles.reference==1
    handles.reference=0;
     plotkrzywa(hObject,handles);
else
    handles.reference=1;
    handles.referenceno=handles.currkrzywa;
    plotkrzywa(hObject,handles);
    set(handles.referenceedit,'String',num2str(handles.referenceno));
end

guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function referenceedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to referenceedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%--------------------------------------------------------------------------
function referenceedit_Callback(hObject, eventdata, handles)
% hObject    handle to referenceedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of referenceedit as text
%        str2double(get(hObject,'String')) returns contents of referenceedit as a double

krzywe=handles.krzywe;
itemp=str2double(get(hObject,'String'));
if (itemp>0) && (itemp<=krzywe.n)
    i=itemp;
    handles.referenceno=i;
end
plotkrzywa(hObject,handles);
guidata(hObject, handles);


% --- Executes on button press in measurebutton.
function measurebutton_Callback(hObject, eventdata, handles)
% hObject    handle to measurebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[x,y]=ginput(4);
z1=num2str(x(1));
z2=num2str(x(2));
F1=num2str(y(1));
F2=num2str(y(2));
dz=num2str(x(2)-x(1));
dF=num2str(y(2)-y(1));
dz0=num2str(x(1)-x(3));
spec=num2str(y(4)>0);
s=['z1=' z1 '  F1=' F1 '  dz=' dz '  dF='  dF];
mh=msgbox(s);
pause(1);
close(mh);
fid=fopen('histogram.dat','at');
fprintf(fid,'%12d %12s %12s %12s %12s\n',handles.currkrzywa,spec,dz0,dz,dF);
fclose(fid)
krzywe=handles.krzywe;
if (handles.currkrzywa<krzywe.n)
    handles.currkrzywa=handles.currkrzywa+1;
    plotkrzywa(hObject,handles);
    guidata(hObject, handles);
end


% --------------------------------------------------------------------
function Add_curves_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Add_curves_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if  ~handles.save
    button = questdlg('Save it?','File not saved','Yes','No','Cancel','Yes');
    if strcmp(button,'Yes')
        [filename, pathname,filterindex] = uiputfile('*.mat', 'Save curves to MAT file');
        krzywe=handles.krzywe;
        save([pathname filename],'krzywe');
        marksave(handles);
        handles.save=1;    
    end   
    if strcmp(button,'Cancel')
         return;
    end
end

krzyweold=handles.krzywe;
krzywenew=addkurwy(krzyweold);
handles.krzywe=krzywenew;
plotkrzywa(hObject,handles);
set(handles.sourcetext,'String',['Source: Multiple sources']);
handles.save=0;
markunsave(handles);
guidata(hObject, handles);


% --------------------------------------------------------------------
function Calc_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Calc_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Remove_vertical_offset_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_vertical_offset_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.save=0;
markunsave(handles);
krzywe=handles.krzywe;

guidata(hObject, handles);
approachbutton_Callback(hObject, eventdata, handles)
View_approach_all_menu_Callback(hObject, eventdata, handles)

uiwait(msgbox('Set the minimum linear range (one mouse click)','modal'));
[zlimit,dummy]=ginput(1);
krzywe=remove_vert_offset(krzywe,zlimit);
handles.krzywe=krzywe;


set(handles.MVHver_menu,'Enable','Off');
set(handles.SMVH_menu,'Enable','Off');
krzywe.mvh=0;
 
plotkrzyweapproach(hObject,handles)
handles.viewmode=2;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function curveslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to curveslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --------------------------------------------------------------------
function MVH_menu_Callback(hObject, eventdata, handles)
% hObject    handle to MVH_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
krzywe=handles.krzywe;


%handles.save=0;
%markunsave(handles);
krzywe.mvh=1;

ans=inputdlg('Input number of bins','Histogram',1);
nbins=str2double(ans);
if (~nbins) nbins=10; end
[xhist_min_val,nhist_min_val]=minimum_value_hist(handles,nbins);
krzywe.xhist_min_val=xhist_min_val;
krzywe.nhist_min_val=nhist_min_val;
handles.krzywe=krzywe;
set(handles.MVHver_menu,'Enable','On');
set(handles.SMVH_menu,'Enable','On');
histofig(xhist_min_val,nhist_min_val);
bar(xhist_min_val,nhist_min_val);
xlabel('F[nN]');
ylabel('Frequency');
guidata(hObject, handles);
% --------------------------------------------------------------------

function verhisto_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


h0=verminvalhisto(handles.krzywe);
data=guidata(h0);
krzywe=data.krzywe;
handles.krzywe=krzywe;
plotkrzywa(hObject,handles);
clear data
guidata(hObject,handles);

%--------------------------------------%
function markunsave(handles)

s=get(handles.sourcetext,'String');
nc=findstr(s,'*');
 
if isempty(nc)
    ss=[s '*'];
    set(handles.sourcetext,'String',ss);
end

function marksave(handles)
s=get(handles.sourcetext,'String');
nc=findstr(s,'*');
if nc
    ss=s(1:nc-1);
    set(handles.sourcetext,'String',ss);
end
 

% --------------------------------------------------------------------
function SMVH_menu_Callback(hObject, eventdata, handles)
% hObject    handle to SMVH_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


krzywe=handles.krzywe;
histofig(krzywe.xhist_min_val,krzywe.nhist_min_val);
bar(krzywe.xhist_min_val,krzywe.nhist_min_val);
xlabel('F[nN]');
ylabel('Frequency');


% --- Executes on mouse press over figure background.
function figure1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Print_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Print_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

printdlg(handles.figure1);


% --- Executes on button press in dupbutton.
function dupbutton_Callback(hObject, eventdata, handles)
% hObject    handle to dupbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hline=findobj(handles.axes1,'Type','line');
duph=figure;
handles.duph=duph;
new_hline = copyobj(hline,gca)
xlabel('z [\mu m]');
ylabel('F [nN]');
grid on
guidata(hObject,handles);


% --------------------------------------------------------------------
function Export_curve_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Export_curve_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
krzywe=handles.krzywe;
i=handles.currkrzywa
[filename, pathname,filterindex] = uiputfile('*.*', ['Export curve no.' num2str(i)]);
if filename
   fid=fopen([pathname filename],'wt');
   data(1,:)=krzywe.z_do(i,:);
   data(2,:)=krzywe.F_do(i,:);
   data(3,:)=krzywe.z_od(i,:);
   data(4,:)=krzywe.F_od(i,:);
      fprintf(fid,'%f      %f       %f      %f\n',data);
   fclose(fid);
end


% --------------------------------------------------------------------
function export_to_workspace_menu_Callback(hObject, eventdata, handles)
% hObject    handle to export_to_workspace_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

krzywe=handles.krzywe;
save krzywe krzywe


% --- Executes on button press in adddupbutton.
function adddupbutton_Callback(hObject, eventdata, handles)
% hObject    handle to adddupbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


hline=findobj(handles.axes1,'Type','line');
if  ~isfield(handles,'duph')
    duph=figure;
    handles.duph=duph;
else
    figure(handles.duph)
    new_hline = copyobj(hline,gca)
    guidata(hObject,handles);
end
xlabel('z [\mu m]');
ylabel('F [nN]');
grid on


% --------------------------------------------------------------------
function Remove_horizontal_offset_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_horizontal_offset_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

answer=inputdlg({'Inout treshold'},'Contact point',[1 10],{'1.02'});
treshold=str2double(answer);
krzywe=handles.krzywe;
h = waitbar(0,'Please wait! Calculation...','WindowStyle','modal') ;
for i=1:krzywe.n,
    x=krzywe.z_do(i,:);
    y=krzywe.F_do(i,:);
    [z0]=findcontactpoint(x,y,treshold);
    krzywe.z_do(i,:)=krzywe.z_do(i,:)-z0;
    krzywe.z_od(i,:)=krzywe.z_od(i,:)-z0;
    waitbar(i/krzywe.n,h)     
end
close(h);
handles.krzywe=krzywe;
guidata(hObject,handles);
plotkrzywa(hObject,handles);
