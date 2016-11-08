
trk=tracker('cvcc',1,1,1,0.2,'butter');
trk1=tracker('cvcc',1,1,1,0.2,'cheby1');
trk2=tracker('cvcc',1,1,1,0.2,'cheby2');


t=0:0.01:pi;

traj=[10+5*cos(t);5*sin(t)];
traj=[traj [5*cos(t);-5*sin(t)]];
traj=data
truetraj=[0:-1:-2000; zeros(1,length(0:-1:-2000))];
truetraj=[truetraj [-2000*ones(1,length(0:-1:-6000));0:-1:-6000]];
truetraj=[truetraj [-2000:1:-500;-6000*ones(1,length(-2000:1:-500))]];
truetraj=[truetraj [-500*ones(1,length(-6000:1:-4500));-6000:1:-4500]];
truetraj=[truetraj [-500:1:0;-4500*ones(1,length(-500:1:0))]];
truetraj=[truetraj [zeros(1,length(-4500:1:0));-4500:1:0]];
truetraj=truetraj*0.001;

meas=traj+0.3*randn(2,length(traj));
estimate_covariances=[];

for it=1:length(meas)
   trk=trk.add_data(meas(:,it));
   trk1=trk1.add_data(meas(:,it));
   trk2=trk2.add_data(meas(:,it));
   pos=trk.getPos()*0.001;
   traje=trk.getTraj()*0.001;
   traje1=trk1.getTraj()*0.001;
   traje2=trk2.getTraj()*0.001;
 
   
   clf
   plot(pos(1),pos(2),'r*');
   plot(truetraj(1,:),truetraj(2,:),'--k')
   hold on
   if  length(traje) > 0
   tmp=trk.filterTraj*0.001;
   plot(tmp(1,:),tmp(2,:),'r:')
   plot(traje(1,:),traje(2,:),'b')
   plot(traje1(1,:),traje1(2,:),'y')
   plot(traje2(1,:),traje2(2,:),'g')
   legend('true trajectory','KF estimated trajectory','butter','cheby1','cheby2');
   %legend('Raw KF trajectory','Smoothed trajectory','Location','SouthEast')
   end
   pause
end


legend('Actual trajectory','Actual measurements','Estimated trajectory','Smoothed trajectory','Location','SouthWest')
xlabel('x-pos')
ylabel('y-pos')
title('Verification Kalman filter implementation')