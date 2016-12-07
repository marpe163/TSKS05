addpath('../../../SensorFusion/Positioning');
addpath('../Arduino');

senspos=[4.95 7 1; -2.55 7 1; 4.95 0 1.6; 0 0 1.25];

if ~exist('a','var') || ~isvalid(a)
    % Open the serial port connection
    a = Arduino('/dev/ttyS99','%d %d %d %d %d %d %d');
end

pos = [];
xpos = [];

for i=1:100000
    % Get a data point
    data = a.readLatest;
    fprintf('%d %d %d %d %d %d %d\n',data(1),data(2),data(3),data(4),data(5),data(6),data(7));
    data = data / 1000;
    pos = [pos [data(1);data(2);data(3)]];
    dist = [data(4);data(5);data(6);data(7)];
    xpos=[xpos toa_positioning(senspos,dist,[-5  10])];

    clf
    plot(xpos(1,:),xpos(2,:));
    hold on
    plot(pos(1,:),pos(2,:));
    xlim([-3 8]);
    ylim([0 8]);
    zlim([0 3]);
    xlabel('x');
    ylabel('y');
    zlabel('z');
    legend('TOA', 'Pozyx');
    drawnow;

% traj=[cos(0:0.05:6*pi);sin(0:0.05:6*pi)]
% traj=[traj;linspace(0,4,length(0:0.05:6*pi))];
% senspos=[0 0 0; 0 5 0;0 0 5; 5 5 5]
% dist=zeros(4,length(traj));
% for it=1:length(traj)
%     
%    dist(1,it)=sqrt((traj(1,it)-senspos(1,1))^2 +(traj(2,it)-senspos(1,2))^2+(traj(3,it)-senspos(1,3))^2);
%    dist(2,it)=sqrt((traj(1,it)-senspos(2,1))^2 +(traj(2,it)-senspos(2,2))^2+(traj(3,it)-senspos(2,3))^2);
%    dist(3,it)=sqrt((traj(1,it)-senspos(3,1))^2 +(traj(2,it)-senspos(3,2))^2+(traj(3,it)-senspos(3,3))^2);
%    dist(4,it)=sqrt((traj(1,it)-senspos(4,1))^2 +(traj(2,it)-senspos(4,2))^2+(traj(3,it)-senspos(4,3))^2); 
% end
% 
% dist=dist+0.05*randn(size(dist));
% xpos=[];
% 
% for it=1:length(traj) 
%     it
%     tic
%     xpos=[xpos toa_positioning(senspos,dist(:,it),[-5  5])];
%     toc
% end
% clf
% plot3(traj(1,:),traj(2,:),traj(3,:));
% hold on
% plot3(xpos(1,:),xpos(2,:),xpos(3,:))

end