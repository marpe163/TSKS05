x0=[15;0;0;0.2];
p0=diag([0 0 2 2]);
F=[1 0 x0(3) 0; 0 1 0 x0(4);0 0 1 0;0 0 0 1];
Q=0.05*diag([1 1 2 2]);
H=[1 0 0 0;0 1 0 0];
R=10*eye(2);
kf=kalmantracker(F,H,Q,R,x0,p0);


traj=[10+5*cos(0:0.01:6);0:0.01:6]
meas=traj+0.8*randn(2,length(0:0.01:6));

for it=1:length(meas)
   kf=kf.measurementupdate(meas(:,it));
   kf=kf.timeupdate();
   
end
figure
tst=kf.trajectory;


plot(traj(1,:),traj(2,:),'r--')
hold on
plot(meas(1,:),meas(2,:),'go')

plot(tst(1,:),tst(2,:),'b-')
legend('Actual trajectory','Actual measurements','Estimated trajectory')
xlabel('x-pos')
ylabel('y-pos')
title('Verification Kalman filter implementation')