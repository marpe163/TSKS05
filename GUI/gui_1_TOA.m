

function varargout = gui_1_TOA(varargin)
% GUI_1_TOA MATLAB code for gui_1_TOA.fig
%      GUI_1_TOA, by itself, creates a new GUI_1_TOA or raises the existing
%      singleton*.
%
%      H = GUI_1_TOA returns the handle to a new GUI_1_TOA or the handle to
%      the existing singleton*.
%
%      GUI_1_TOA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_1_TOA.M with the given input arguments.
%
%      GUI_1_TOA('Property','Value',...) creates a new GUI_1_TOA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_1_TOA_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_1_TOA_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_1_TOA

% Last Modified by GUIDE v2.5 07-Dec-2016 10:40:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @gui_1_TOA_OpeningFcn, ...
    'gui_OutputFcn',  @gui_1_TOA_OutputFcn, ...
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


% --- Executes just before gui_1_TOA is made visible.
function gui_1_TOA_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_1_TOA (see VARARGIN)

% Choose default command line output for gui_1_TOA
%init

handles.output = hObject;
if ~isempty(instrfind)
delete(instrfind)
end

%% Startup input dialog
prompt = {'Number of tags','Number of anchors','Enter the name of the serial port used'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'1','4','COM3'};
numofstuf = inputdlg(prompt,dlg_title,num_lines,defaultans);
numofanch = str2double(numofstuf(2));
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
    handles.a = Arduino(numofstuf(3),'%d %d %d %d %d %d %d %d %d %d %d %d');
end
%init tracker
handles.trk1=tracker('cvcc',[4;4;0;0],eye(4),2,0.1,handles.filter);

%
for i = 1 : length(handles.tagID{1}(:,1))
    % This for loops ads the tags to the map
    % circle is the class for making tags
    handles.room.tag_list = [handles.room.tag_list circle('red',5,handles.tagID{1}(i,:))];
    
end

% placement of anchors the first placement is the origin anchor
set(handles.text2, 'String','Place out the origin anchor');
[x y] = getpts(handles.axes6);
handles.room.Anchor_list = [handles.room.Anchor_list Anchor([x y],5,'green')];
set(handles.text2, 'String','Place out the res of the anchors');
for anch = 1:(numofanch - 1)
    [x y] = getpts(handles.axes6);
    handles.room.Anchor_list = [handles.room.Anchor_list Anchor([x y],5,'blue')];
end
%%

guidata(hObject, handles);
% Update handles structure





% UIWAIT makes gui_1_TOA wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_1_TOA_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
axes(handles.axes2)
ylim([-5 5]);
title('v_x')
axes(handles.axes3)
ylim([-5 5]);
title('v_y')
axes(handles.axes4)
title('z-pos')
ylim([0 2.5]);
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
pixpermm_x = map_size(2)/30000;
pixpermm_y = map_size(1)/12000;

% Inital value for position
data = handles.a.readLatest;
oldx = origin(1) + data(1)*pixpermm_x;
oldy = origin(2) - data(2)*pixpermm_y;
oldz = data(3);
% Below is for 3D plot
% set(handles.axes6,'view',[-37.5 30]);
%grid(handles.axes6,'on');

temp = 1;
%% for TOA
pos = [];
xpos = [];
senspos=[
    14.75 0.30 1.60;
    4.95 0.00 1.60;
    -2.10 2.30 1.95;
    25.25 2.25 1.05;
    9.75 1.90 2.40;
    -2.25 7.00 1.00];

count = 0;
clock = 0;

old = [0 0 0 0 0 0; 1 1 1 1 1 1; 1:6];

zkf=kalmantracker(1,1,0.5,1.5,1.5,0.5,1);

old_velox = 0;
    old_veloy = 0;
    oldz_pos = 0;
    
    hold(handles.axes2,'on')
    hold(handles.axes3,'on')
    hold(handles.axes4,'on')
%% Main loop
while(get(handles.togglebutton1,'value'))
    
   
   
    tic 
    data = handles.a.readLatest;
    %TOA
    distance = data(1:6) / 1000;
    RSS = data(7:12);
    sensor_index = 1:6;
    % Filter out the outlier values
    tmp = [distance'; RSS'; sensor_index];
    % First remove stale values
    tmp = tmp(:,old(1,:) ~= tmp(1,:));
    tmp = tmp(:,tmp(1,:)<50);
    tmp = tmp(:,tmp(2,:)<0);
    tmp = tmp(:,tmp(2,:)>-200);
    % Save the values for comparison next iteration
    old = [distance'; RSS'; sensor_index];
    % Break if we have less than four data points
    if(size(tmp,2) < 3)
        continue;
    end
    % Sort the data by RSS
    distance = tmp(1,:);
    RSS = tmp(2,:);
    sensor_index = tmp(3,:);
    [RSS_sorted, index] = sort(RSS,'descend');
    distance_sorted = distance(index);
    sensor_index_sorted = sensor_index(index);
    
    % Take the four measurements with the best RSS
    d = distance_sorted(1:3);
    zpos=1.5;
    if size(tmp,2) > 3
    testvar=distance_sorted(1:4);
    ba2=senspos(sensor_index_sorted(1:4),:);
    xpos2=toa_positioning(ba2,testvar,[-5 10]);
    zpos=xpos2(3);
    zkf=zkf.measurementupdate(zpos);
    zkf=zkf.timeupdate();
    zpos=zkf.xk;
    end
    
    best_anchors_pos = senspos(sensor_index_sorted(1:3),:);
    
    xpos=[xpos [toa_positioning2D(best_anchors_pos,d',[-5  10]); 0]];
    info_mode = sprintf('Three anchors\n');
    
    c = 1000;
    exp = 3;
    % Calculate the delta x and delta y between selected anchors
    dx = max(best_anchors_pos(:,1))-min(best_anchors_pos(:,1));
    dy = max(best_anchors_pos(:,2))-min(best_anchors_pos(:,2));
   % fprintf('\ndx=%6.3f dy=%6.3f', dx, dy);
    
    posx = origin(1) + xpos(1,end)*pixpermm_x*1000;%testdata(1,temp);
    posy = origin(2) - xpos(2,end)*pixpermm_y*1000;%testdata(2,temp);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    handles.trk1.measurementNoiseUpdate(dx,dy,c,exp);

    handles.trk1.add_data([xpos(1,end);xpos(2,end)]);
    temp = temp + 1;
    traje1=handles.trk1.getTraj()*1000;
    
    posmm = data; % trk1.getPos;
    % posx = origin(1) + posmm(1)*pixpermm_x;%testdata(1,temp);% %
    % posy = origin(2) - posmm(2)*pixpermm_y;%testdata(2,temp); % %
    % posz = origin(3) + testdata(3,temp);%data(3);
    %
    handles.room.set_tag_pos(posx,posy,1); % gives the tag its position on the map
    %%%%%%%%%%%%%%%% plotting axes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    if temp > 20
    xlim(handles.axes2,[temp - 20 temp]);
    xlim(handles.axes3,[temp - 20 temp]);
      xlim(handles.axes4,[temp - 20 temp]);
    end
      velo =  handles.trk1.getVelocities;
   % hold(handles.axes2,'on')
    plot([(temp - 1) temp],[old_velox velo(1)],'r-','parent',handles.axes2)
    % hold(handles.axes2,'off')
    %hold(handles.axes3,'on')
    plot([(temp - 1) temp],[old_veloy velo(2)],'r-','parent',handles.axes3)
    %hold(handles.axes3,'off')
    %hold(handles.axes4,'on')
    plot([(temp - 1) temp],[oldz_pos zpos],'r-','parent',handles.axes4)
    %hold(handles.axes4,'off')
   
    old_velox = velo(1);
    old_veloy = velo(2);
    oldz_pos = zpos;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if size(traje1,2)>2
        % add if statement for moving avg   
        lineshandle = findobj(handles.axes6,'type','line');
              if ~isempty(lineshandle)
                 delete(lineshandle)
            end
        
        plot(origin(1) + traje1(1,:)*pixpermm_x, origin(2) - traje1(2,:)*pixpermm_y,'r-','parent',handles.axes6)
        %disp('plotting traje1')
        %traje1
    end
    
    drawnow limitrate
    oldx = posx;
    oldy = posy;
    clock = toc;
    text = sprintf('sample time: %d\nx_pos: %d  x_data: %d\ny_pos: %d y_data: %d',clock,posx,distance(1),posy,distance(2));
    set(handles.text2, 'String',text);
    %Give the button callback a chance to interrupt the opening fucntion
    guidata(hObject, handles);
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
        handles.trk1.change_smoothing(handles.filter,0.1);
        
    case 2
        handles.filter = 'cheby1';
        handles.trk1.change_smoothing(handles.filter,0.1);
    case 3
        handles.filter = 'cheby2';
        handles.trk1.change_smoothing(handles.filter,0.1);
    case 4
      
         handles.filter = 'movingAvg';
        handles.trk1.change_smoothing(handles.filter,10);
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


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
lineshandle = findobj(handles.axes6,'type','line');
              if ~isempty(lineshandle)
                 delete(lineshandle)
              end
            handles.trk1.resetTrajectory();
guidata(hObject,handles);
