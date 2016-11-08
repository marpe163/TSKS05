% If serial port has been opened, try closing it
if exist('s','var')
    fclose(s);
end

clear all;

trk=tracker('cvcc',1,1,10,0.05);

truetraj=[[0;0],[-2;0], [-2;-6],[-0.5;-6],[-0.5;-4.5],[0;-4.5],[0; 0]];

% This port should be created using the following command as root:
%     ln -s /dev/ttyACM0 /dev/ttyS99
serialPort = '/dev/ttyS99';

% Open the serial port with the baud rate
s = serial(serialPort,'BaudRate',115200);
fopen(s);

estimate_covariances=[];
for i = 1:10000
    d = fscanf(s, '%d %d %d');
    if norm([d(1);d(2)]) > 10000
        % Remove outlier
        continue;
    end
    trk=trk.add_data([d(1); d(2)]);
    pos=trk.getPos()*0.001;
    traje=trk.getTraj()*0.001;
    if mod(i,5)==0
    clf
    plot(truetraj(1,:),truetraj(2,:),'--k');
    axis([-5 5 -8 6])
    hold on
    plot(pos(1),pos(2),'r*');
    if length(traje) > 0
        tmp=trk.filterTraj*0.001;
        plot(tmp(1,:),tmp(2,:),'r:')
        plot(traje(1,:),traje(2,:),'b')
        axis([-5 5 -8 6])
    end
    
    drawnow
    end
    
end


legend('Actual trajectory','Actual measurements','Estimated trajectory','Smoothed trajectory','Location','SouthWest')
xlabel('x-pos')
ylabel('y-pos')
title('Verification Kalman filter implementation')