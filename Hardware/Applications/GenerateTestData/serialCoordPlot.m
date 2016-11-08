% If serial port has been opened, try closing it
if exist('s','var')
    fclose(s);
end

clear all;

% This port should be created using the following command as root:
%     ln -s /dev/ttyACM0 /dev/S99
serialPort = '/dev/ttyS99';

% Open the serial port with the baud rate
s = serial(serialPort,'BaudRate',115200);
fopen(s);

h = animatedline('Color','Blue','Marker','o');
% axis([0,1600,0,600])

i = 1;

while true
    d = fscanf(s, '%d %d %d');
    addpoints(h,d(1),d(2));
    drawnow
    data(:,i) = [d(1), d(2)];
    time(:,i) = clock;
    i = i+1;
end


% Close the serial port
fclose(s);