classdef trajectory < handle
    %Implementation of a kalman filter for iterative filtering. Updates
    %with each new measurement.
    %   Detailed explanation goes here
    
    properties
        y=[]; %measurement data
        traj=[];%Trajectories
        counter=0;%
        cutoff=0;
        filtertype='';
    end
    
    methods
        function obj = trajectory(cutoffFreq,type)
            obj.cutoff=cutoffFreq;
            obj.filtertype=type;
            
        end
        function obj=add_data(obj,inp_data)
            
            obj.y=[obj.y inp_data];
            
            if length(obj.y)-25>length(obj.traj)
                
               obj.traj=obj.rt_smooth(obj.y,obj.traj,obj.cutoff,obj.filtertype);
            
            end
            
        end
        function smoothed_traj=rt_smooth(obj, data, old_traj,cutoffFreq,type)
            %real time smoothing
            lend = length(data);
            lenot = length(old_traj);
           smoothed_traj=[];
            if lenot < 20 %marigin to not go out of bounds
                smoothed_traj = obj.smooth_trajectory(5,cutoffFreq,data,type);
            elseif lend-35>lenot
                    
                tmpvec=[old_traj(1:2,(lenot-15):lenot) data(1:2, lenot+1:end)];
                tmpvec=obj.smooth_trajectory(5,cutoffFreq,tmpvec,type);
                smoothed_traj=[old_traj tmpvec(1:2,lenot+1:end-5)];
                
                
            end

            
        end
        function smoothed_trajectory = smooth_trajectory(obj,N,wn,trajectory,opt)
        %Takes a matrix with two rows, where the rows are the x and y coordinates
        %of the trajectory respectively. The trajectory is then fed through a LP
        %filter in order to obtain a smoother trajectory.

        if strcmp(opt,'butter')
            [B,A]=butter(N,wn/2);

        elseif strcmp(opt,'cheby1')
            [B,A]=cheby1(N,0.2,wn/2); 

        elseif strcmp(opt,'cheby2')
            [B,A]=cheby2(N,3,wn/2);
        end
        if length(trajectory)>14
            xfilt=filtfilt(B,A,trajectory(1,:));
            yfilt=filtfilt(B,A,trajectory(2,:));
            smoothed_trajectory=[xfilt;yfilt];
        else
            smoothed_trajectory=trajectory;
        end


        end
    end
end


