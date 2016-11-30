

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
room = map('comsyshall2test.png');
imshow(room.get_pic);
handles.room = room;

%prompt = {'Enter number of tags'};
%dlg_title = 'Input';
%num_lines = 1;
%defaultans = {'20','hsv'};
%answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

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

if isfield(handles,'room')
     room = handles.room;
     room.tag_list = [circle('red',5)];
    
end


if(get(handles.togglebutton1,'value'))
%% for testing GUI   
posx = 0;
posy = 385/2;
%posvector = zeros(2,100000);
%%
handles.start = 1;  %Update the GUI data
i = 1;

end
while(get(handles.togglebutton1,'value'))
[posx, posy] = start_track(posx,posy); % change to get data from processing module
%posvector(:,i) = [posx ; posy];
handles = guidata(hObject);

room.set_tag_pos(posx,(385 - posy),1);
%plot(posvector,'r','Linewidth',3,'parent',handles.axes2)
drawnow %Give the button callback a chance to interrupt the opening fucntion
%i = i + 1;
%if(i == length(posvector))
%i = 1;
%end


pause(0.2)


end






% Hint: get(hObject,'Value') returns toggle state of togglebutton1

