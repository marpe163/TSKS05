%% Settings

% Scaling factor of the map image file (meters per pixel)
scale = 0.029;
% Rotating of the map (angles)
rotation = 180;
% Offset of the origin from the left bottom of the map (meters)
Xoffset = 2;
Yoffset = 4.5;

%% Create window
f = figure;

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

%% Plot some test data
load('20161114commsyscorridor1.mat', 'data');
data = data / 1000; % convert millimiters to meters
plot(mapAxes, data(1,:), data(2,:), '-O');
axis(mapAxes, [-5 20 -5 8]);

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