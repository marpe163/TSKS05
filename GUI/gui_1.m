

function varargout = gui_1(varargin)
% GUI_1 MATLAB code for gui_1.fig
%      GUI_1, by itself, creates a new GUI_1 or raises the existing
%      singleton*.
%
%      H = GUI_1 returns the handle to a new GUI_1 or the handle to
%      the existing singleton*.
%
%      GUI_1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_1.M with the given input arguments.
%
%      GUI_1('Property','Value',...) creates a new GUI_1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_1

% Last Modified by GUIDE v2.5 01-Dec-2016 14:50:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @gui_1_OpeningFcn, ...
    'gui_OutputFcn',  @gui_1_OutputFcn, ...
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


% --- Executes just before gui_1 is made visible.
function gui_1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_1 (see VARARGIN)

% Choose default command line output for gui_1
%init

handles.output = hObject;



%% Startup input dialog
prompt = {'Number of tags','Number of anchors'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'1','4'};
numoftags = inputdlg(prompt,dlg_title,num_lines,defaultans);
%%
prompt = {'Enter the tag ID (one ID per line)','Enter the Anchor ID (one ID per line)',};
dlg_title = 'Input';
num_lines = 1;%str2double(numoftags(2));
defaultans = {'tagID','id1','id2'};
tagID = inputdlg(prompt,dlg_title,num_lines,defaultans);
%% Settup objects as fields within handles
handles.tagID = tagID;
handles.room = map('comsyshall2test3.png'); % ojbect for the map
imshow(handles.room.get_pic)
handles.filter = 'butter';
% Init aurduino
if ~exist('a','var') || ~isvalid(a)
     %Open the serial port connection
    handles.a = Arduino('COM3','%d %d %d %d %d %d %d');
end
%init tracker
handles.trk1=tracker('cvcc',1,1,2,0.1,handles.filter);
for i = 1 : length(handles.tagID{1}(:,1))
    % This for loops ads the tags to the map
    % circle is the class for making tags
    handles.room.tag_list = [handles.room.tag_list circle('red',5,handles.tagID{1}(i,:))];
    
end

% placement of anchors the first placement is the origin anchor
set(handles.text2, 'String','Place out the anchors, first anchor will be the the origin anchor');
[x y] = getpts(handles.axes6);
handles.room.Anchor_list = [handles.room.Anchor_list Anchor([x y],5,'green')];
%for anch = 1:5
%    [x y] = getpts(handles.axes6)
%handles.room.Anchor_list = [handles.room.Anchor_list Anchor([x y],5,'blue')];
%end
%%

guidata(hObject, handles);
% Update handles structure





% UIWAIT makes gui_1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_1_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
axes(handles.axes2)
title('Sensor 1')
axes(handles.axes3)
title('Sensor 2')
axes(handles.axes4)
title('Sensor 3')
axes(handles.axes6)
title('Map of the Communications Systems corridor')
lim = axis;
axis(lim)
varargout{1} = handles.output;



% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(get(handles.togglebutton1,'value'))
    % If the togglebotton is pressed down this is statement will be true
    % handles.start = 1;  %Update the GUI data
% delete lineplots on axes before starting over.
    h = findobj('type','line');
if ~isempty(h)
delete(h)
end
end 

%% Here is where our main function goes.

% Define the origin at one of the anchors
origin = handles.room.Anchor_list(1).pos;%[pixpermm_x*2100 pixpermm_y*6000];

% Skale axes
map_size = size(handles.room.get_pic);
pixpermm_x = map_size(2)/23000;
pixpermm_y = map_size(1)/10000;

% Inital value for position
data = handles.a.readLatest;
 oldx = origin(1) + data(1)*pixpermm_x;
 oldy = origin(2) - data(2)*pixpermm_y;
oldz = data(3);
% Below is for 3D plot
 % set(handles.axes6,'view',[-37.5 30]);
%grid(handles.axes6,'on');
%% testdata

% s = load('20161114commsyscorridor1.mat');
% testdata = s.data;
% testdata(1,:) = testdata(1,:)*pixpermm_x;
% testdata(2,:) = testdata(2,:)*pixpermm_y;
%% init Tracekr
%tmp5=[];
temp = 1;

%trk1=tracker('cvcc',1,1,2,0.1,handles.filter);

%% Main loop
while(get(handles.togglebutton1,'value'))
    tic
    
    data = handles.a.readLatest;
     handles.trk1.add_data(data(1:2)*0.001);
    temp = temp + 1;
    traje1=handles.trk1.getTraj()*1000;
    
    posmm = data; % trk1.getPos;
    posx = origin(1) + posmm(1)*pixpermm_x;%testdata(1,temp);% %
    posy = origin(2) - posmm(2)*pixpermm_y;%testdata(2,temp); % %
   % posz = origin(3) + testdata(3,temp);%data(3);
    %
    

    handles.room.set_tag_pos(posx,posy,1); % gives the tag its position on the map
    
    if size(traje1,2)>2
        plot(origin(1) + traje1(1,:)*pixpermm_x, origin(2) - traje1(2,:)*pixpermm_y,'r-','parent',handles.axes6)
        %traje1
    end
   
    drawnow limitrate
    oldx = posx;
    oldy = posy;
    
   text = sprintf('Update time: %d\nx_pos: %d  x_data: %d\ny_pos: %d y_data: %d',toc,posx,data(1),posy,data(2));
    set(handles.text2, 'String',text);
    %Give the button callback a chance to interrupt the opening fucntion
    handles = guidata(hObject);
    
end
%handles = guidata(hObject);
% Hint: get(hObject,'Value') returns toggle state of togglebutton1


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(handles.popupmenu1,'Value')
    case 1
        handles.filter = 'butter';
        handles.trk1.change_smoothing(handles.filter,0.1)
    case 2
        handles.filter = 'cheby1';
        handles.trk1.change_smoothing(handles.filter,0.1)
    case 3
        handles.filter = 'cheby2';
        handles.trk1.change_smoothing(handles.filter,0.1)
    case 4
        handles.filter = 'movingAvg';
        handles.trk1.change_smoothing(handles.filter,10)
    otherwise

end


guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on mouse press over axes background.
function axes6_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.togglebutton1, 'Value', 0)
delete(handles.a)
guidata(hObject,handles);
