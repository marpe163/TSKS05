classdef trajectory
    %Implementation of a kalman filter for iterative filtering. Updates
    %with each new measurement.
    %   Detailed explanation goes here
    
    properties
        y=[]; %measurement data
        traj=[];%Trajectories
        counter=0;%
    end
    
    methods
        function obj = trajectory()
            
        end
        function obj=add_data(obj,inp_data)
            
            obj.y=[obj.y inp_data];
            
            if length(obj.y)-25>length(obj.traj)
                
               obj.traj=rt_smooth(obj.y,obj.traj);
            
            end
            
        end
   end
end


