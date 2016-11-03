
trk=tracker('cvcc',1,1);

t=0:0.01:pi;

traj=[10+5*cos(t);5*sin(t)];
traj=[traj [5*cos(t);-5*sin(t)]];
%traj=data


meas=traj+0.3*randn(2,length(traj));
estimate_covariances=[];
for it=1:length(meas)
   trk=trk.add_data(meas(:,it));
   pos=trk.getPos();
   traje=trk.getTraj();
   
   clf
   plot(pos(1),pos(2),'r*');
   hold on
   if  length(traje) > 0
   tmp=trk.filterTraj
   plot(tmp(1,:),tmp(2,:),'r:')
   plot(traje(1,:),traje(2,:),'b')
   end
   pause
end


legend('Actual trajectory','Actual measurements','Estimated trajectory','Smoothed trajectory','Location','SouthWest')
xlabel('x-pos')
ylabel('y-pos')
title('Verification Kalman filter implementation')