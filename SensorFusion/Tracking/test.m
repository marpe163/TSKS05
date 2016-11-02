x0=[15;0;0;2];
p0=0.1*diag([15 15 2 2]);
F=[1 0 x0(3) 0; 0 1 0 x0(4);0 0 1 0;0 0 0 1];
Q=0.005*diag([1 1 10 10]);
H=[1 0 0 0;0 1 0 0];
R=2*[1,0;0,1];
G=[1 0 1/2 0;0 1 0 1/2;0 0 1 0; 0 0 0 1];
kf=kalmantracker(F,H,Q,R,x0,p0,G);
trj=trajectory();

t=0:0.01:pi;

traj=[10+5*cos(t);5*sin(t)];
traj=[traj [5*cos(t);-5*sin(t)]];
%traj=data


meas=traj+1*randn(2,length(traj));
estimate_covariances=[];
for it=1:length(meas)
   kf=kf.measurementupdate(meas(:,it));
   trj=trj.add_data(kf.xk);
   disp('meas')
   kf.Pk
   tmp=kf.Pk; %Save the current estimate uncertainty
   tmp1=kf.xk %Save the current state estimate
   kf=kf.timeupdate();
   disp('time')
   tmp3=trj.traj;
   tmp4=kf.trajectory;
   clf
   
   
   plot(traj(1,:),traj(2,:),'k--');
   hold on
   if length(tmp3)>10
       tmp5=smooth_trajectory(5,0.1,tmp4);
       plot(tmp5(1,:),tmp5(2,:),'r^-')
       plot(tmp3(1,:),tmp3(2,:),'bv-')
   end
   plot(tmp4(1,:),tmp4(2,:),'g')
   pause
   
   if(mod(it,2)==1)
        estimate_covariances(:,:,it)=tmp1(1:2)+confidence_ellipse(tmp(1:2,1:2));
        
   end
end

close all
tst=kf.trajectory;
tic
smoothed_trajectory=smooth_trajectory(5,0.1,tst);
toc
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