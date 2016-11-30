

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

% Last Modified by GUIDE v2.5 29-Nov-2016 19:29:39

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

% Settup objects as fields within handles
%;
%handles.room = room;

prompt = {'Enter number of tags'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'1'};
numoftags = inputdlg(prompt,dlg_title,num_lines,defaultans);
prompt = {'Enter the tag ID (one ID per line)'};
dlg_title = 'Input';
num_lines = str2double(numoftags);
defaultans = {'tagID'};
tagID = inputdlg(prompt,dlg_title,num_lines,defaultans);
handles.tagID = tagID;
handles.room = map('comsyshall2test3.png');
imshow(handles.room.get_pic)
handles.filter = 'butter';

for i = 1 : length(handles.tagID{1}(:,1))
    % This for loops ads the tags to the map
    % circle is the class for making tags
    handles.room.tag_list = [handles.room.tag_list circle('red',5,handles.tagID{1}(i,:))];
    
end

%% placement of anchors
[x y] = getpts(handles.axes6)
handles.room.Anchor_list = [handles.room.Anchor_list Anchor([x y],5,'green')];
%for anch = 1:5
%    [x y] = getpts(handles.axes6)
%handles.room.Anchor_list = [handles.room.Anchor_list Anchor([x y],5,'blue')];
%end
%%
guidata(hObject, handles);
%for anch = 1 : 6
%set(gcf, 'WindowButtonDownFcn', @getMousePositionOnImage);
%pan off % Panning will interfere with this code
%handles.room.Anchor_list(anch).set_pos([handles.cursorPoint(1) handles.cursorPoint(2)]);
%end
% Update handles structure


%function getMousePositionOnImage(src, event)

%handles = guidata(src);
%handles.cursorPoint = get(handles.axes6, 'CurrentPoint');
%guidata(hObject, handles)




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
varargout{1} = handles.output;



% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%room = map('comsyshall2test.png'); % map class to keep track of tags and anchors
%imshow(handles.room.get_pic)

% pixelstorleken för bilden är 1771x385


if(get(handles.togglebutton1,'value'))
    %% for testing GUI
    posx = 0;
    posy = 385/2;
    posz = 0;
    hold on
    [oldx,oldy] = start_track(posx,posy);
    %handles.start = 1;  %Update the GUI data
    h = findobj('type','line');
if ~isempty(h)
delete(h)
end
else
    %imshow(handles.room.get_pic)
end
%% Here is where our main function goes.
%testdata = [1:10:10000 ; 192*ones(1,1000)];
%testdata = testdata + 15*randn(2,1000);
%%skale axes
map_size = size(handles.room.get_pic);
pixpermm_x = map_size(2)/25000;
pixpermm_y = map_size(1)/14000;
% set(handles.axes6,'view',[-37.5 30]);
%grid(handles.axes6,'on');
%%
origin = handles.room.Anchor_list(1).pos;%[pixpermm_x*2100 pixpermm_y*6000];
s = load('20161114commsyscorridor1.mat');
testdata = s.data;
testdata(1,:) = testdata(1,:)*pixpermm_x;
testdata(2,:) = testdata(2,:)*pixpermm_y;
%% init filters
tmp5=[];
temp = 1;
x0=[0;192;0;2];
p0=0.1*diag([15 15 2 2]);
F=[1 0 x0(3) 0; 0 1 0 x0(4);0 0 1 0;0 0 0 1];
Q=0.005*diag([1 1 10 10]);
H=[1 0 0 0;0 1 0 0];
R=2*[1,0;0,1];
G=[1 0 1/2 0;0 1 0 1/2;0 0 1 0; 0 0 0 1];
kf=kalmantracker(F,H,Q,R,x0,p0,G);
trj=trajectory(0.1,handles.filter);
% INIT aurduino
%if ~exist('a','var') || ~isvalid(a)
%     %Open the serial port connection
%    a = Arduino('COM3');
%end
%handles.start = 1;  %Update the GUI data

%% Main loop
while(get(handles.togglebutton1,'value'))
    tic
    %   data = a.read;
    posx = origin(1) + testdata(1,temp);%data(1); %
    posy = origin(2) - testdata(2,temp); %data(2); %
   % posz = origin(3) + testdata(3,temp);%data(3);
    %
    kf=kf.measurementupdate(testdata(:,temp));
    trj=trj.add_data(kf.xk);
    %disp('meas')
    kf.Pk;
    tmp=kf.Pk; %Save the current estimate uncertainty
    tmp1=kf.xk; %Save the current state estimate
    kf=kf.timeupdate();
    %disp('time');
    tmp3=trj.traj;
    tmp4=kf.trajectory;
    temp = temp + 1;
    
    if temp >= length(testdata)
    temp = 1;
    end
    if length(tmp4)>20
        tmp5= trj.traj;%smooth_trajectory(5,0.1,tmp4);
       % tmp5 = 0;
    end
    % [posx, posy] = start_track(oldx,oldy); % change to get data from processing module
    handles.room.set_tag_pos(posx,posy,1); % gives the tag its position on the map
    % todo: skale the map with the recievd data
    
    plot([oldx posx], [oldy posy],'b','parent',handles.axes6);
    if length(tmp5)>0
       plot(origin(1) + tmp5(1,:),origin(2) - tmp5(2,:),'r-','parent',handles.axes6)
    end
    drawnow limitrate
    oldx = posx;
    oldy = posy;
    %Give the button callback a chance to interrupt the opening fucntion
   % handles = guidata(hObject);
   text = sprintf('sample time: %d\nChildren to handle: %d\nLength of trajectory: %d',toc,length(handles.axes6.Children),length(tmp5));
    set(handles.text2, 'String',text);
end
delete(kf)
delete(trj)
%h = findobj('type','line');
%delete(h)


handles = guidata(hObject);


% Hint: get(hObject,'Value') returns toggle state of togglebutton1


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(handles.popupmenu1,'Value')
    case 1
        handles.filter = 'butter';
    case 2
        handles.filter = 'cheby1';
    case 3
        handles.filter = 'cheby2';
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
