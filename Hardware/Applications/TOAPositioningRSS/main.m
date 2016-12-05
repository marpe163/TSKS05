addpath('../../../SensorFusion/Positioning');
addpath('../../../SensorFusion/Tracking');
addpath('../Arduino');
tic

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
sampling_freq = 2;
t1=tracker('cvcc',1,1,sampling_freq,0.4,'butter');
t2=tracker('cvcc',1,1,sampling_freq,10,'movingAvg');
count = 0;
while true
    count = count+1;
    if count > 20
        a.delete;
        a = Arduino('/dev/ttyS99','%d %d %d %d %d %d %d %d %d %d %d %d');
        count = 0;
    end
    % Get a data point
    data = a.readLatest;
    distance = data(1:6) / 1000;
    RSS = data(7:12);
    sensor_index = 1:6;
    % Position reported by Pozyx
    % pos = [pos [data(13);data(14);data(15)]/1000];

    % Filter out the outlier values
    tmp = [distance'; RSS'; sensor_index];
    tmp = tmp(:,tmp(1,:)<50);
    tmp = tmp(:,tmp(2,:)<0);
    tmp = tmp(:,tmp(2,:)>-200);

    % Break if we have less than four data points
    if(size(tmp,2) < 3)
        fprintf('Not enough data points\n');
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
        best_anchors_pos = senspos(sensor_index_sorted(1:4),:);
        xpos=[xpos toa_positioning(best_anchors_pos,d',[-5  10])];
        info_mode = sprintf('More than three anchors\n');
    elseif length(distance_sorted) == 3
        d = distance_sorted(1:3);
        best_anchors_pos = senspos(sensor_index_sorted(1:3),:);
        xpos=[xpos [toa_positioning2D(best_anchors_pos,d',[-5  10]); 0]];
        info_mode = sprintf('Three anchors\n');
    end

    % Report some information in command window
    info_data = sprintf('%d %d %d %d %d %d\n',...
        data(1), data(2), data(3), data(4), data(5), data(6));
    info_xpos = sprintf('  TOA: %6.3f %6.3f\n', xpos(1,end), xpos(2,end));
    % info_pos  = sprintf('Pozyx: %6.3f %6.3f\n', pos(1,end), pos(2,end));
    % fprintf('\n\n%s%s%s%s', info_mode, info_data, info_xpos, info_pos);
    fprintf('\n\n%s%s%s', info_mode, info_data, info_xpos);
    fprintf('Delta time: %f Seconds\n', toc);
    tic
    for i=1:length(sensor_index_sorted)
        fprintf('%s ', sensname(sensor_index_sorted(i),:));
    end

    c = 1000;
    exp = 3;
    % Calculate the delta x and delta y between selected anchors
    dx = max(best_anchors_pos(:,1))-min(best_anchors_pos(:,1));
    dy = max(best_anchors_pos(:,2))-min(best_anchors_pos(:,2));
    fprintf('\ndx=%6.3f dy=%6.3f', dx, dy);
    % Change variance according to the anchors with best signal
    t1 = t1.measurementNoiseUpdate(dx,dy,c,exp);
    t2 = t2.measurementNoiseUpdate(dx,dy,c,exp);
    % Do filtering
    t1=t1.add_data([xpos(1,end);xpos(2,end)]);
    t2=t2.add_data([xpos(1,end);xpos(2,end)]);
    position = t1.getPos();
    trajectory_butter = t1.getTraj();
    trajectory_ma = t2.getTraj();

    % Plot data
    clf
    plot(xpos(1,:),xpos(2,:),'x');
    hold on
    % plot(pos(1,:),pos(2,:),'o');
    plot(position(1),position(2),'*');
    if(~isempty(trajectory_butter))
        plot(trajectory_butter(1,:),trajectory_butter(2,:),'r');
    end
    if(~isempty(trajectory_ma))
        plot(trajectory_ma(1,:),trajectory_ma(2,:),'g');
    end
%     legend('TOA','Filtered position',...
%         'Trajectory(Butterworth)','Trajectory(Moving Average)');
    xlim([-5 25]);
    ylim([0 10]);
    title(sprintf('c=%d exp=%d', c, exp));
    drawnow;
end
