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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Only Moving avg without kalman filtering %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all

load('20161107_02_java.mat')


x0 = data(:,1);
tag_pos = positioning(x0,10);

mean_vector = [];
iter = length(data);
truetraj=[[0;0],[-2;0], [-2;-6],[-0.5;-6],[-0.5;-4.5],[0;-4.5],[0; 0]];
truetraj = 1000*truetraj;
for it=2:iter-1
    
    tag_pos = tag_pos.update_position(data(:,it));
    mean_val = [mean(tag_pos.saved_pos(1,:)) ; mean(tag_pos.saved_pos(2,:))];
    figure(3)
    plot(truetraj(1,:),truetraj(2,:),'--k')    
    hold on
    plot(tag_pos.saved_pos(1,:),tag_pos.saved_pos(2,:),'b');


    mean_vector(:,it-1) = tag_pos.moving_avarage();
    plot(mean_vector(1,:),mean_vector(2,:),'r')
    plot(mean_vector(1,it-1),mean_vector(2,it-1),'g*')
    legend('True trajectory','Unproccesed data','Moving avg','Current pos');
    hold off
    pause(1/10)
end


legend('True trajectory','Unproccesed data','Moving avg','Current pos');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Real-time comparison of moving avg and butter %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all

load('20161107_02_java.mat')

trk=tracker('cvcc',1,1,1,0.2,'butter');

t=0:0.01:pi;

truetraj=[[0;0],[-2;0], [-2;-6],[-0.5;-6],[-0.5;-4.5],[0;-4.5],[0; 0]];

meas = data;
estimate_covariances=[];

tag_pos = positioning(data(:,1)*0.001,25);
mean_vector = [];

for it=1:length(meas)
   trk=trk.add_data(meas(:,it));
   pos=trk.getPos()*0.001;
   traje=trk.getTraj()*0.001;
   
   figure(1);
   plot(truetraj(1,:),truetraj(2,:),'--k')
   hold on
   
   tmp=trk.filterTraj*0.001;
   
   if  length(traje) > 0
        tmp=trk.filterTraj*0.001;
        plot(tmp(1,:),tmp(2,:),'r:')
        plot(traje(1,:),traje(2,:),'b')
        legend('True trajectory','KF est traj','butter');
   end
   
   hold off
   
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
   legend('True trajectory','Current Pos','Moving avg','KF est traj');
   end
  
   hold off
  
   pause(1/10)
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Test with only butter filtering %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all


load('20161107_02_java.mat')
trk=tracker('cvcc',1,1,1,0.2,'butter');

t=0:0.01:pi;

traj=data;
truetraj=[[0;0],[-2;0], [-2;-6],[-0.5;-6],[-0.5;-4.5],[0;-4.5],[0; 0]];

meas = data;
estimate_covariances=[];

tic
for it=1:length(meas)
   trk=trk.add_data(meas(:,it));
   pos=trk.getPos()*0.001;
   traje=trk.getTraj()*0.001;
   
   tmp=trk.filterTraj*0.001;
   
   if  length(traje) > 0
        tmp=trk.filterTraj*0.001;
   end

end


Butter_filtered_time = toc


    figure(1);
    plot(truetraj(1,:),truetraj(2,:),'--k')
    hold on
    plot(tmp(1,:),tmp(2,:),'r:')
    plot(traje(1,:),traje(2,:),'b')
    legend('true trajectory','KF est traj','butter');

    % Test of how much time butter filtering takes
    % test without plotting in the loop: toc = 0.2309 seconds
    % dataset: '20161107_02_java.mat'
    
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Test with only moving avarage %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all


load('20161107_02_java.mat')
trk=tracker_moving_avarage('cvcc',1,1,1);

t=0:0.01:pi;

traj=data;
truetraj=[[0;0],[-2;0], [-2;-6],[-0.5;-6],[-0.5;-4.5],[0;-4.5],[0; 0]];

meas = data;
estimate_covariances=[];

tag_pos = positioning(data(:,1)*0.001,10);
mean_vector = zeros(2,length(data));
tic
for it=1:length(meas)
   trk=trk.add_data(meas(:,it));
   pos=trk.getPos()*0.001;
   
   tmp=trk.filterTraj*0.001;
   tag_pos = tag_pos.update_position(tmp(1:2,it));
   current_mean = tag_pos.moving_avarage();
   mean_vector(:,it) = tag_pos.moving_avarage();
   
end


Moving_avarage_time = toc


   figure(2);
   plot(truetraj(1,:),truetraj(2,:),'--k')
   hold on
   plot(tmp(1,:),tmp(2,:),'r:')
   plot(mean_vector(1,:),mean_vector(2,:),'b')
   plot(current_mean(1),current_mean(2),'g*')
   legend('true trajectory','KF est traj','moving avarage','current pos');
   
   
    % Test of how much time moving avarage filtering takes
    % test without plotting in the loop: toc = 0.1028 seconds
    % dataset: '20161107_02_java.mat'
   
   
   
   