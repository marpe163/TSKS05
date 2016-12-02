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
    14.75 0.30 1.60;
     4.95 0.00 1.60;
    -2.10 2.30 1.95;
    25.25 2.25 1.05;
     9.75 1.90 2.40;
    -2.25 7.00 1.00];

if ~exist('a','var') || ~isvalid(a)
    % Open the serial port connection
    a = Arduino('/dev/ttyS99','%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d');
end

pos = [];
xpos = [];

while true
    % Get a data point
    data = a.readLatest;
    distance = data(1:6) / 1000;
    RSS = data(7:12);
    sensor_index = 1:6;
    % Position reported by Pozyx
    pos = [pos [data(13);data(14);data(15)]/1000];

    % Filter out the outlier values
    tmp = [distance'; RSS'; sensor_index];
    tmp = tmp(:,tmp(1,:)<50);
    tmp = tmp(:,tmp(2,:)<0);
    tmp = tmp(:,tmp(2,:)>-200);

    % Break if we have less than four data points
    if(size(tmp,2) < 3)
        continue;
    end

    % Sort the data by RSS
    distance = tmp(1,:);
    RSS = tmp(2,:);
    sensor_index = tmp(3,:);
    [RSS_sorted, index] = sort(RSS,'descend');
    distance_sorted = distance(index);
    sensor_index_sorted = sensor_index(index);

    % Take the four measurements with the best RSS
    if length(distance_sorted) > 3
        d = distance_sorted(1:4);
        xpos=[xpos toa_positioning(senspos(sensor_index_sorted(1:4),:),d',[-5  10])];
        info_mode = sprintf('More than three anchors\n');
    elseif length(distance_sorted) == 3
        d = distance_sorted(1:3);
        xpos=[xpos [toa_positioning2D(senspos(sensor_index_sorted(1:3),:),d',[-5  10]); 0]];
        info_mode = sprintf('Three anchors\n');
    end

    % Report some information in command window
    info_data = sprintf('%d %d %d %d %d %d\n',...
        data(1), data(2), data(3), data(4), data(5), data(6));
    info_xpos = sprintf('  TOA: %6.3f %6.3f\n', xpos(1,end), xpos(2,end));
    info_pos  = sprintf('Pozyx: %6.3f %6.3f\n', pos(1,end), pos(2,end));
    fprintf('\n\n%s%s%s%s', info_mode, info_data, info_xpos, info_pos);
    for i=1:length(sensor_index_sorted)
        fprintf('%s ', sensname(sensor_index_sorted(i),:));
    end

    % Plot data
    clf
    plot(xpos(1,:),xpos(2,:),'x');
    hold on
    plot(pos(1,:),pos(2,:),'o');
    legend('TOA', 'Pozyx');
    xlim([-5 30]);
    ylim([-5 10]);
    drawnow;
end