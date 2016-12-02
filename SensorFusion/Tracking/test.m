
trk=tracker('ekfctcc',1,1,1,0.05,'butter');
trk1=tracker('cvcc',1,1,1,0.05,'butter');
trk2=tracker('cvcc',1,1,1,0.05,'butter');



t=0:0.01:pi;

traj=[10+5*cos(t);5*sin(t)];
traj=[traj [5*cos(t);-5*sin(t)]];
traj=data
truetraj=[[0;0],[-2;0], [-2;-6],[-0.5;-6],[-0.5;-4.5],[0;-4.5],[0; 0]];

meas=traj+0.3*randn(2,length(traj));
estimate_covariances=[];
meas=data;
counter=0
for it=1:length(meas)
    tic
   trk=trk.add_data(meas(:,it));
   toc
   trk1=trk1.add_data(meas(:,it));
   trk2=trk2.add_data(meas(:,it));
   pos=trk.getPos()*0.001;
   pos1=trk1.getPos()*0.001;
   traje=trk.getTraj()*0.001;
   traje1=trk1.getTraj()*0.001;
   traje2=trk2.getTraj()*0.001;
 
   
   
   if  length(traje) > 0
   tmp=trk.filterTraj*0.001;
   tmp1=trk1.filterTraj*0.001;
   counter=counter+1;
   if mod(counter,5)==0
       clf
   plot(pos(1),pos(2),'r*');
   plot(truetraj(1,:),truetraj(2,:),'--k')
   hold on
   plot(tmp(1,:),tmp(2,:),'r:')
   plot(tmp1(1,:),tmp1(2,:),'k:')
   plot(traje(1,:),traje(2,:),'r-')
   plot(traje1(1,:),traje1(2,:),'k-')
   legend('True trajectory','EKF-CT estimated trajectory','KF estimated trajectory','EKF-CT butter','KF butter');
   %legend('Raw KF trajectory','Smoothed trajectory','Location','SouthEast')
   end
   end
   pause
end


%legend('Actual trajectory','Actual measurements','Estimated trajectory','Smoothed trajectory','Location','SouthWest')
xlabel('x-pos')
ylabel('y-pos')
title('Verification Kalman filter implementation')


%%

clear all; clc

trk=tracker('ekfctcc',1,1,1,0.05,'butter');
trk1=tracker('cvcc',1,1,1,12,'movingAvg');
trk2=tracker('cvcc',1,1,1,0.05,'butter');

load('20161107_02_java.mat');

t=0:0.01:pi;

traj=[10+5*cos(t);5*sin(t)];
traj=[traj [5*cos(t);-5*sin(t)]];
traj=data
truetraj=[[0;0],[-2;0], [-2;-6],[-0.5;-6],[-0.5;-4.5],[0;-4.5],[0; 0]];

meas=traj+0.3*randn(2,length(traj));
estimate_covariances=[];
meas=data;
counter=0
traje1 = [];
traje1_old = [];
bytt = 0;
for it=1:length(meas)
    tic
   trk=trk.add_data(meas(:,it));
   toc
   trk1=trk1.add_data(meas(:,it));
   trk2=trk2.add_data(meas(:,it));
   pos=trk.getPos()*0.001;
   pos1=trk1.getPos()*0.001;
   traje=trk.getTraj()*0.001;
   trajectory1=trk1.getTraj()*0.001;
   traje2=trk2.getTraj()*0.001;
 
   if (~isempty(trajectory1) && bytt == 1)
        traje1 = [traje1_old trajectory1];
   elseif ~isempty(trajectory1)
        traje1 = [traje1 trajectory1(:,end)];
   end
   
    if  length(traje) > 0 && length(traje1)>0
       tmp=trk.filterTraj*0.001;
       tmp1=trk1.filterTraj*0.001;
       counter=counter+1;

        if 1%mod(counter,5)==0
           clf
       plot(pos(1),pos(2),'r*');
       plot(truetraj(1,:),truetraj(2,:),'--k')
       hold on
       plot(tmp(1,:),tmp(2,:),'r:')
       plot(tmp1(1,:),tmp1(2,:),'k:')
       plot(traje(1,:),traje(2,:),'r-')
       plot(traje1(1,:),traje1(2,:),'k-')
       legend('True trajectory','EKF-CT estimated trajectory','KF estimated trajectory','EKF-CT butter','KF movingAvg');
       %legend('Raw KF trajectory','Smoothed trajectory','Location','SouthEast')
       end
   end
   
   
    if counter == 60
       
       pause(1)
       trk1.trj.filtertype
        trk1 = trk1.change_smoothing('butter',0.1);
        trk1.trj.filtertype
        pause(1)
        counter = counter + 1;
        traje1_old = traje1;
        bytt = 1;
    end
   
   
    if (bytt == 1)
        traje1 = [];
    end
    
    pause(1/5)
end


%legend('Actual trajectory','Actual measurements','Estimated trajectory','Smoothed trajectory','Location','SouthWest')
xlabel('x-pos')
ylabel('y-pos')
title('Verification Kalman filter implementation')

