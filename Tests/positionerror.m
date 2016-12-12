%position error
C=15;
kalleman=kalmantracker(eye(2),eye(2),zeros(2,2),C*eye(2),[0;0],10*eye(2),eye(2));

pos=[3;2];
error_vec=[];
for jt=1:1000
    kalleman=kalmantracker(eye(2),eye(2),zeros(2,2),C*eye(2),[0;0],10*eye(2),eye(2));
    for it=1:1000
       kalleman=kalleman.measurementupdate(pos+5*randn(2,1));
       kalleman=kalleman.timeupdate();
    end
    error_vec=[error_vec ,norm(pos-kalleman.xk)];
end
histogram(error_vec','BinMethod','auto')