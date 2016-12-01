addpath('../../../SensorFusion/Positioning');
addpath('../Arduino');

% Order of sensors: 0x6078, 0x603F, 0x6050, 0x6000, 0x600E, 0x603B
sensname=[
    '0x6078';
    '0x603F';
    '0x6050';
    '0x6000';
    '0x600E';
    '0x603B';
];
senspos=[
    14.75  0.3  1.6;
     4.95    0  1.6;
     -2.1  2.3 1.95;
    25.25 2.25 1.05;
     9.75 0.85  2.4;
    -2.25    7    1];

if ~exist('a','var') || ~isvalid(a)
    % Open the serial port connection
    a = Arduino('/dev/ttyS99','%d %d %d %d %d %d %d %d %d %d %d %d');
end

xpos = [];

while true
    % Get a data point
    data = a.readLatest;
    fprintf('%d %d %d %d %d %d\n\n',...
        data(1), data(2), data(3), data(4), data(5), data(6));
    distance = data(1:6) / 1000;
    RSS = data(7:12);
    sensor_index = 1:6;

    % Filter out the outlier values
    tmp = [distance'; RSS'; sensor_index];
    tmp = tmp(:,tmp(1,:)<50);
    tmp = tmp(:,tmp(2,:)<0);
    tmp = tmp(:,tmp(2,:)>-200);

    % Break if we have less than four data points
    if(size(tmp,2) < 3)
        continue;
    end

    distance = tmp(1,:);
    RSS = tmp(2,:);
    sensor_index = tmp(3,:);
    [RSS_sorted, index] = sort(RSS,'descend');
    distance_sorted = distance(index);
    sensor_index_sorted = sensor_index(index);

    % Take the four measurements with the best RSS
    if length(distance_sorted) > 3
        d = distance_sorted(1:4);
%         sensor_index_sorted(1:4)
        xpos=[xpos toa_positioning(senspos(sensor_index_sorted(1:4),:),d',[-5  10])];
    fprintf('%s %s %s %s\n',...
        sensname(sensor_index_sorted(1),:),...
        sensname(sensor_index_sorted(2),:),...
        sensname(sensor_index_sorted(3),:),...
        sensname(sensor_index_sorted(4),:));
    elseif length(distance_sorted) == 3
        fprintf('3oiuytre\n');
        d = distance_sorted(1:3);
%         sensor_index_sorted(1:3)
        xpos=[xpos [toa_positioning2D(senspos(sensor_index_sorted(1:3),:),d',[-5  10]); 0]];
    fprintf('%s %s %s\n',...
        sensname(sensor_index_sorted(1),:),...
        sensname(sensor_index_sorted(2),:),...
        sensname(sensor_index_sorted(3),:));
    end
    fprintf('%d %d\n', xpos(1,end), xpos(2,end));

    clf
    plot(xpos(1,:),xpos(2,:));
    hold on
    drawnow;
end