addpath('../SensorFusion/Positioning');
addpath('../SensorFusion/Tracking');
addpath('../Hardware/Applications/Arduino');
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
    a = Arduino('/dev/ttyS99','%d %d %d %d %d %d %d %d %d %d %d %d');
end

pos = [];
xpos = [];
sampling_freq = 2;


old = [0 0 0 0 0 0; 1 1 1 1 1 1; 1:6];
pos=[6.65;0.5];
counter=0;
error_vec=[];
xkvec=[];
C=1;
kalleman=kalmantracker(eye(2),eye(2),zeros(2,2),C*eye(2),[0;0],10*eye(2),eye(2));
b=datetime;
while true
    % Get a data point
    data = a.readLatest;
    distance = data(1:6) / 1000;
    RSS = data(7:12);
    sensor_index = 1:6;

    % Filter out the outlier values
    tmp = [distance'; RSS'; sensor_index];
    % First remove stale values
    tmp = tmp(:,old(1,:) ~= tmp(1,:));
    tmp = tmp(:,tmp(1,:)<50);
    tmp = tmp(:,tmp(2,:)<0);
    tmp = tmp(:,tmp(2,:)>-200);

    % Save the values for comparison next iteration
    old = [distance'; RSS'; sensor_index];

    % Break if we have less than three data points
    if(size(tmp,2) < 3)
        
        continue;
    end
    counter=counter+1;
    % Sort the data by RSS
    distance = tmp(1,:);
    RSS = tmp(2,:);
    sensor_index = tmp(3,:);
    [RSS_sorted, index] = sort(RSS,'descend');
    distance_sorted = distance(index);
    sensor_index_sorted = sensor_index(index);

    % Take the three measurements with the best RSS
    d = distance_sorted(1:3);
    best_anchors_pos = senspos(sensor_index_sorted(1:3),:);
    xpos=[xpos [toa_positioning2D(best_anchors_pos,d',[-5  10]); 0]];
    info_mode = sprintf('Three anchors\n');

   

    const = 100;
    expo = 2;
  
    % Change variance according to the anchors with best signal
    
    
    %position error





    if mod(counter,11)==10
    dx = max(best_anchors_pos(:,1))-min(best_anchors_pos(:,1));
    dy = max(best_anchors_pos(:,2))-min(best_anchors_pos(:,2));
    kalleman=kalleman.measurementNoiseUpdate(dx,xy,const,expo);
    xkvec=[xkvec kalleman.xk];
    kalleman=kalmantracker(eye(2),eye(2),zeros(2,2),C*diag([1 1]),[0;0],10*eye(2),eye(2));
    end
  
   
       kalleman=kalleman.measurementupdate([xpos(1,end);xpos(2,end)]);
       
       kalleman=kalleman.timeupdate();
       counter
    if counter > 5000
        
       break; 
    end
    
end
error_vec=xkvec(1:2,:)-repmat(pos(:),1,length(xkvec));
error_vec=sqrt(sum(error_vec.^2))


d=datetime;
d-b
histogram(error_vec','BinMethod','auto')

   

