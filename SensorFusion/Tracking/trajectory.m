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
            disp('1')
            obj.y=[obj.y inp_data];
            disp('2')
            length(obj.y)-10>length(obj.traj)
            disp('wtf')
            if length(obj.y)-25>length(obj.traj)
                disp('4')
               obj.traj=rt_smooth(obj.y,obj.traj);
               disp('3')
            end
        end
    end
   end


