function xopt=toa_positioning(sensor_positions, ranges,grid)
%function for position estimation using a TOA method. The position estimate
%is given by the NLS solution. The grid input argument is for using various
%initial values for the optimization algorithm in order to avoid local
%minima. Note that the execution time is proportional to the square of the
%length of the grid vector.
%
% % %Example:
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
dmin=100000000000; %big number
xopt=[0;0];
opts = optimoptions('lsqnonlin','Display','off'); %Dont display warning from the nls solver.

%iterate over the grid
for it=1:length(grid)
    for jt=1:length(grid)
        for kt=1:length(grid)
            %Utilize matlab's build in NLS solver.
            [x,d] = lsqnonlin(@(x) costfcn(x,sensor_positions(:,:)...
                ,ranges(:)),[grid(it);grid(jt);grid(kt)],[-10;0;0],[30;7.5;2.5],opts);      
            if d<dmin
                dmin=d;
                xopt=x;
            end
        end
    end
    
end

    %Cost function to be minimized. 
    function F = costfcn(x,pos,ranges)%remove ranges since its a nested fcn?
            distances=zeros(size(pos,1),1);
            for lt=1:length(distances)
               distances(lt)=sqrt((x(1)-pos(lt,1))^2+(x(2)-pos(lt,2))^2+(x(3)-pos(lt,3))^2); 
            end
            F=zeros(length(distances),1);
            for lt=1:length(F)
                
               F(lt)=ranges(lt)-distances(lt); 
            end
    end
end