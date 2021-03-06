% Run this as root beforehands:
%   ln -s /dev/ttyACM0 /dev/ttyS99

if ~exist('a','var') || ~isvalid(a)
    % Open the serial port connection
    a = Arduino('COM3');
end

for i=1:100
    % Get a data point
    data = a.read;
    fprintf('%d %d %d %d\n',i,data(1),data(2),data(3));
end

% Get all data points up to now:
disp(a.RawData);

% If you want to use the serial port again, you have to call a.delete to
% close the serial port first:
%
% a.delete;
