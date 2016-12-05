function xopt=toa_positioning2D(sensor_positions, ranges,grid)
%Does 2D positioning using 3D data with only ranges from three sensors
%available. We do this by projecting down on to the ranging in the xy-plane.
dmin=100000000000; %big number
xopt=[0;0];
opts = optimoptions('lsqnonlin','Display','off'); %Dont display warning from the nls solver.

%iterate over the grid
for it=1:length(grid)
    for jt=1:length(grid)
        %Utilize matlab's build in NLS solver.
        [x,d] = lsqnonlin(@(x) costfcn(x,[sensor_positions(1,1:2);sensor_positions(2,1:2);sensor_positions(3,1:2)]...
            ,[sqrt(abs(ranges(1)^2-(sensor_positions(1,3)-1.5)^2));sqrt(abs(ranges(2)^2-(sensor_positions(2,3)-1.5)^2));sqrt(abs(ranges(3)^2-(sensor_positions(3,3)-1.5)^2))]),[grid(it);grid(jt)],[-10;0],[30;7.5],opts);      
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


