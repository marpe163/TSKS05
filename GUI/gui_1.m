

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

% Last Modified by GUIDE v2.5 31-Oct-2016 16:02:42

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

% Update handles structure
guidata(hObject, handles);

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
room = map('comsyshall2test.png'); % map class to keep track of tags and anchors
imshow(room.get_pic)

% pixelstorleken för bilden är 1771x385
for i = 1 : length(handles.tagID{1}(:,1))
    % This for loops ads the tags to the map
    % circle is the class for making tags
     room.tag_list = [room.tag_list circle('red',5,handles.tagID{1}(i,:))];
    
end

if(get(handles.togglebutton1,'value'))
%% for testing GUI   
posx = 0;
posy = 385/2;
posz = 0;
hold on 
[oldx,oldy] = start_track(posx,posy);
handles.start = 1;  %Update the GUI data
else
    imshow(room.get_pic)
end 
%% Here is where our main function goes.
testdata = [1:10:10000 ; 192*ones(1,1000)];
testdata = testdata + 15*randn(2,1000);
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
trj=trajectory();
% INIT aurduino
%if ~exist('a','var') || ~isvalid(a)
%     %Open the serial port connection
%    a = Arduino('COM3');
%end
handles.start = 1;  %Update the GUI data
%% Main loop
while(get(handles.togglebutton1,'value'))
%    data = a.read;
posx = testdata(1,temp);%data(1); %
posy = testdata(2,temp); %data(2); %
%posz = data(3);
%
kf=kf.measurementupdate(testdata(:,temp));
   trj=trj.add_data(kf.xk);
   disp('meas')
   kf.Pk;
   tmp=kf.Pk; %Save the current estimate uncertainty
   tmp1=kf.xk; %Save the current state estimate
   kf=kf.timeupdate();
   disp('time');
   tmp3=trj.traj;
   tmp4=kf.trajectory;
temp = temp + 1;

if length(tmp4)>20
tmp5=smooth_trajectory(5,0.1,tmp4);
end
   % [posx, posy] = start_track(oldx,oldy); % change to get data from processing module
room.set_tag_pos(posx,(385 - posy),1); % gives the tag its position on the map 
% todo: skale the map with the recievd data
drawnow
plot([oldx posx], [(385 - oldy) (385 - posy)],'b','parent',handles.axes6)
if length(tmp5)>0
   plot(tmp5(1,:),tmp5(2,:),'r-','parent',handles.axes6) 
end
oldx = posx;
oldy = posy;
 %Give the button callback a chance to interrupt the opening fucntion
handles = guidata(hObject);


end





% Hint: get(hObject,'Value') returns toggle state of togglebutton1

