% This port should be created using the following command as root:
%     ln -s /dev/ttyACM0 /dev/S99
serialPort = '/dev/ttyS99';

% If serial port has been opened, try closing it
if exist('s','var')
    fclose(s);
end

% Open the serial port with the baud rate
s = serial(serialPort,'BaudRate',115200);
fopen(s);

% Get data from serial port
% Order: x, y, z, Var(X), Var(Y), Var(Z), Cov(X,Y), Cov(X,Z), Cov(Y,Z)
while true
    d = fscanf(s, '%d %d %d %d %d %d %d %d %d');
    d
end

% Close the serial port
fclose(s);