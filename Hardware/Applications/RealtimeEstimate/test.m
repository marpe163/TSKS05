% If serial port has been opened, try closing it
if exist('s','var')
    fclose(s);
end

clear all;

trk=tracker('cvcc',1,1,10);

% This port should be created using the following command as root:
%     ln -s /dev/ttyACM0 /dev/ttyS99
serialPort = '/dev/ttyS99';

% Open the serial port with the baud rate
s = serial(serialPort,'BaudRate',115200);
fopen(s);

estimate_covariances=[];
for i = 1:500
    d = fscanf(s, '%d %d %d');
    if norm([d(1);d(2)]) > 10000
        % Remove outlier
        continue;
    end
    trk=trk.add_data([d(1); d(2)]);
    pos=trk.getPos();
    traje=trk.getTraj();

    clf
    plot(pos(1),pos(2),'r*');
    hold on
    if length(traje) > 0
        tmp=trk.filterTraj;
        plot(tmp(1,:),tmp(2,:),'r:')
        plot(traje(1,:),traje(2,:),'b')
        axis([-3000 3000 -2000 2000])
    end
    drawnow
end


legend('Actual trajectory','Actual measurements','Estimated trajectory','Smoothed trajectory','Location','SouthWest')
xlabel('x-pos')
ylabel('y-pos')
title('Verification Kalman filter implementation')