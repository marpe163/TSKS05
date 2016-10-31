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

% Print each line we get
while true
    d = fscanf(s, '%s');
    fprintf('%s\n',d);
end

% Close the serial port
fclose(s);