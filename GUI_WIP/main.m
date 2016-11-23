%% Settings

% Scaling factor of the map image file (meters per pixel)
scale = 0.029;
% Rotating of the map (angles)
rotation = 180;
% Offset of the origin from the left bottom of the map (meters)
Xoffset = 2;
Yoffset = 4.5;

%% Create window
f = figure('Position', [30, 30, 600, 600]);

%% Create map panel
mapPanel = uipanel();
mapPanel.Parent = f;
mapPanel.Title = 'Map';
mapPanel.Position = [0 0.1 1 0.88];
% Create map axes
mapAxes = axes();
mapAxes.Parent = mapPanel;
mapAxes.Position =  [0 0 1 1];
pbaspect(mapAxes, [1 1 1]);
hold(mapAxes,'on');
% Draw image of the corrior
imageData = imread('test.png');
imageData = flip(imageData,1);
imageData = imrotate(imageData, rotation);
image = imshow(imageData);
image.Parent = mapAxes;
image.XData = [0*scale-Xoffset size(imageData,2)*scale-Xoffset];
image.YData = [0*scale-Yoffset size(imageData,1)*scale-Yoffset];
mapAxes.YDir = 'normal';

%% Create option panel
optionPanel = uipanel();
optionPanel.Parent = f;
optionPanel.Title = 'Options';
optionPanel.Position = [0 0 1 0.12];

% Create filter menu text
filterMenuText = uicontrol('Style', 'text');
filterMenuText.Parent = optionPanel;
filterMenuText.String = 'Filter Type:';
filterMenuText.HorizontalAlignment = 'Right';
filterMenuText.Position = [3 0 75 21];

% Create filter menu
filterMenu = uicontrol('Style','popup');
filterMenu.Parent = optionPanel;
filterMenu.Position = [80 0 180 25];
filterMenu.String = {'No Filter','Kalman Filter','Extended Kalman Filter'};

% Create start button
startButton = uicontrol('Style','pushbutton');
startButton.Parent = optionPanel;
startButton.Position = [80 30 180 25];
startButton.String = 'Start';

% Create pause button
pauseButton = uicontrol('Style','pushbutton');
pauseButton.Parent = optionPanel;
pauseButton.Position = [260 30 180 25];
pauseButton.String = 'Pause';

% Create clear button
clearButton = uicontrol('Style','pushbutton');
clearButton.Parent = optionPanel;
clearButton.Position = [440 30 180 25];
clearButton.String = 'Clear';

%% Plot some test data
t = TestFile('20161114commsyscorridor1.mat');
f.DeleteFcn = @(~,~)t.delete;
startButton.Callback = @(~,~)t.plot(mapAxes);
pauseButton.Callback = @(~,~)t.togglePlotting;
clearButton.Callback = @(~,~)t.clearPlot;
axis(mapAxes, [-5 20 -5 8]);
