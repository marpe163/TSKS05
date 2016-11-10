% test positioning

x0 = [1;1];

tag_pos = positioning(x0,10);

x1 = [2;2];
tag_pos = tag_pos.update_position(x1);

mean_vector = [];
for it=3:100
    x = [it;it] + 8*randn(2,1);
    tag_pos = tag_pos.update_position(x);
    mean_val = [mean(tag_pos.saved_pos(1,:)) ; mean(tag_pos.saved_pos(2,:))];
    plot(tag_pos.saved_pos(1,:),tag_pos.saved_pos(2,:),'b');
    hold on
    mean_vector(:,it-2) = tag_pos.moving_avarage();
    plot(mean_vector(1,:),mean_vector(2,:),'r*')
    hold off
    axis([0 100 0 100])
    pause(1/5)
end

%%
x0 = data(:,1);
tag_pos = positioning(x0,10);

mean_vector = [];
iter = length(data);
truetraj=[[0;0],[-2;0], [-2;-6],[-0.5;-6],[-0.5;-4.5],[0;-4.5],[0; 0]];
truetraj = 1000*truetraj;
for it=2:iter-1
    
    tag_pos = tag_pos.update_position(data(:,it));
    mean_val = [mean(tag_pos.saved_pos(1,:)) ; mean(tag_pos.saved_pos(2,:))];
    plot(tag_pos.saved_pos(1,:),tag_pos.saved_pos(2,:),'b');
    hold on
    plot(truetraj(1,:),truetraj(2,:),'--k')
    mean_vector(:,it-1) = tag_pos.moving_avarage();
    plot(mean_vector(1,:),mean_vector(2,:),'r')
    plot(mean_vector(1,it-1),mean_vector(2,it-1),'g*')
    hold off
    %axis([0 100 0 100])
    pause(1/10)
end


%% trackingsaker


%trk=tracker('cvcc',1,1,1,0.2,'butter');
trk=tracker('cvcc',1,1,1,0.2,'butter');

t=0:0.01:pi;

%traj=[10+5*cos(t);5*sin(t)];
%traj=[traj [5*cos(t);-5*sin(t)]];
traj=data;
truetraj=[[0;0],[-2;0], [-2;-6],[-0.5;-6],[-0.5;-4.5],[0;-4.5],[0; 0]];

%meas=traj+0.3*randn(2,length(traj))
meas = data;
estimate_covariances=[];

tag_pos = positioning(data(:,1)*0.001,25);
mean_vector = [];

for it=1:length(meas)
   trk=trk.add_data(meas(:,it));
   pos=trk.getPos()*0.001;
   traje=trk.getTraj()*0.001;
   
   clf
   %plot(pos(1),pos(2),'r*');
   figure(1);
   plot(truetraj(1,:),truetraj(2,:),'--k')
   hold on
   
   tmp=trk.filterTraj*0.001;
   
   if  length(traje) > 0
        tmp=trk.filterTraj*0.001;
        plot(tmp(1,:),tmp(2,:),'r:')
        plot(traje(1,:),traje(2,:),'b')
        legend('true trajectory','KF estimated trajectory','butter');
        %legend('Raw KF trajectory','Smoothed trajectory','Location','SouthEast')
   end
   
   
   figure(2);
   plot(truetraj(1,:),truetraj(2,:),'--k')
   hold on
   
   tmp=trk.filterTraj*0.001;
   tag_pos = tag_pos.update_position(tmp(1:2,it));
   current_mean = tag_pos.moving_avarage();
   mean_vector(:,it) = tag_pos.moving_avarage();
   plot(current_mean(1),current_mean(2),'g*')
   plot(mean_vector(1,:),mean_vector(2,:),'b')
   
   if  length(traje) > 0
   tmp=trk.filterTraj*0.001;
   plot(tmp(1,:),tmp(2,:),'r:')
   %plot(traje(1,:),traje(2,:),'b')
   legend('true trajectory','Merving ervch','KF estimated trajectory');
   %legend('Raw KF trajectory','Smoothed trajectory','Location','SouthEast')
   end
  
   pause(1/10)
end


%legend('Actual trajectory','Actual measurements','Estimated trajectory','Smoothed trajectory','Location','SouthWest')
%xlabel('x-pos')
%ylabel('y-pos')
%title('Verification Kalman filter implementation')



%% trackingsaker FUSION


%trk=tracker('cvcc',1,1,1,0.2,'butter');
trk=tracker('cvcc',1,1,1,0.2,'butter');

t=0:0.01:pi;

%traj=[10+5*cos(t);5*sin(t)];
%traj=[traj [5*cos(t);-5*sin(t)]];
traj=data;
truetraj=[[0;0],[-2;0], [-2;-6],[-0.5;-6],[-0.5;-4.5],[0;-4.5],[0; 0]];

%meas=traj+0.3*randn(2,length(traj))
meas = data;
estimate_covariances=[];

tag_pos = positioning(data(:,1)*0.001,10);
mean_vector = [];

for it=1:length(meas)
   trk=trk.add_data(meas(:,it));
   pos=trk.getPos()*0.001;
   traje=trk.getTraj()*0.001;
   
   clf
   %plot(pos(1),pos(2),'r*');
   figure(1);
   plot(truetraj(1,:),truetraj(2,:),'--k')
   hold on
   
   tmp=trk.filterTraj*0.001;
   tag_pos = tag_pos.update_position(tmp(1:2,it));
   current_mean = tag_pos.moving_avarage();
   mean_vector(:,it) = tag_pos.moving_avarage();
   %plot(mean_vector(1,:),mean_vector(2,:),'r')
   
   if  length(traje) > 0
        tmp=trk.filterTraj*0.001;
        plot(tmp(1,:),tmp(2,:),'r:')
        %plot(traje(1,:),traje(2,:),'b')
        plot(mean_vector(1,:),mean_vector(2,:),'b')
        plot(current_mean(1),current_mean(2),'g*')
        legend('true trajectory','KF estimated trajectory','butter','current pos');
        %legend('Raw KF trajectory','Smoothed trajectory','Location','SouthEast')
   end

   pause(1/10)
end