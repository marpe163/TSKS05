x0=[15;0;0;2];
p0=0.1*diag([15 15 2 2]);
F=[1 0 x0(3) 0; 0 1 0 x0(4);0 0 1 0;0 0 0 1];
Q=0.05*diag([1 1 10 10]);
H=[1 0 0 0;0 1 0 0];
R=1*[1,0;0,1];
G=[1 0 1/2 0;0 1 0 1/2;0 0 1 0; 0 0 0 1];
kf=kalmantracker(F,H,Q,R,x0,p0,G);


t=0:0.05:pi;

traj=[10+5*cos(t);5*sin(t)];
traj=[traj [5*cos(t);-5*sin(t)]]


meas=traj+0.3*randn(2,length(traj));
estimate_covariances=[];
for it=1:length(meas)
   kf=kf.measurementupdate(meas(:,it));
   disp('meas')
   kf.Pk
   tmp=kf.Pk; %Save the current estimate uncertainty
   tmp1=kf.xk %Save the current state estimate
   kf=kf.timeupdate();
   disp('time')
  
   
   if(mod(it,2)==1)
        estimate_covariances(:,:,it)=tmp1(1:2)+confidence_ellipse(tmp(1:2,1:2));
        
   end
end

close all
tst=kf.trajectory;
smoothed_trajectory=smooth_trajectory(5,0.3,tst);

plot(traj(1,:),traj(2,:),'r-')
hold on
 plot(meas(1,:),meas(2,:),'ko')
% 
plot(tst(1,:),tst(2,:),'g-')
plot(smoothed_trajectory(1,:),smoothed_trajectory(2,:),'b-')

%  for it=1:length(estimate_covariances)
%      plot(estimate_covariances(1,:,it),estimate_covariances(2,:,it),'g'); 
%  end



legend('Actual trajectory','Actual measurements','Estimated trajectory','Smoothed trajectory','Location','SouthWest')
xlabel('x-pos')
ylabel('y-pos')
title('Verification Kalman filter implementation')