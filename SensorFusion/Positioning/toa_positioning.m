function xopt=toa_positioning(sensor_positions, ranges,grid)
%function for position estimation using a TOA method. The position estimate
%is given by the NLS solution. The grid input argument is for using various
%initial values for the optimization algorithm in order to avoid local
%minima. Note that the execution time is proportional to the square of the
%length of the grid vector.
%
%Example:
% traj=[5*cos(0:0.05:pi);5*sin(0:0.05:pi)];
% senspos=[1 0;2 2;0 0];
% dist=zeros(3,length(traj));
% for it=1:length(traj)
%    dist(1,it)=sqrt((traj(1,it)-senspos(1,1))^2 +(traj(2,it)-senspos(1,2))^2);
%    dist(2,it)=sqrt((traj(1,it)-senspos(2,1))^2 +(traj(2,it)-senspos(2,2))^2);
%    dist(3,it)=sqrt((traj(1,it)-senspos(3,1))^2 +(traj(2,it)-senspos(3,2))^2); 
% end
% 
% dist=dist+0.15*randn(size(dist));
% xpos=[];
% for it=1:length(dist)
%     it
%     tic
%     xpos=[xpos toa_positioning(senspos,[dist(1,it);dist(2,it);dist(3,it)],[-20 0 20])];
%     toc
% end
% clf
% plot(traj(1,:),traj(2,:))
% hold on
% plot(xpos(1,:),xpos(2,:))
dmin=100000000000; %big number
xopt=[0;0];
opts = optimoptions('lsqnonlin','Display','off'); %Dont display warning from the nls solver.

%iterate over the grid
for it=1:length(grid)
    for jt=1:length(grid)
        %Utilize matlab's build in NLS solver.
        [x,d] = lsqnonlin(@(x) costfcn(x,[sensor_positions(1,:);sensor_positions(2,:);sensor_positions(3,:)]...
            ,[ranges(1);ranges(2);ranges(3)]),[grid(it);grid(jt)],[-20;-20],[20;20],opts);      
        if d<dmin
            dmin=d;
            xopt=x;
        end
    end
    
end

    %Cost function to be minimized. 
    function F = costfcn(x,pos,ranges)%remove ranges since its a nested fcn?
            distances=zeros(size(pos,1),1);
            for lt=1:length(distances)
               distances(lt)=sqrt((x(1)-pos(lt,1))^2+(x(2)-pos(lt,2))^2) ;
            end
            F=zeros(length(distances),1);
            for lt=1:length(F)
               F(lt)=ranges(lt)-distances(lt); 
            end
    end
end