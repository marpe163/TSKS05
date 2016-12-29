classdef trajectory < handle
    %Implementation of a kalman filter for iterative filtering. Updates
    %with each new measurement.
    %   Detailed explanation goes here
    
    properties
        y=[];               %measurement data
        traj=[];            %Trajectories
        cutoff=0;           % Cut off frequency if butter/cheb is used
        movAvgOrder = 10;    % Order of the moving avarage, if used
        saved_pos = [];     % vector of saved, earlier positions 2xX
        filtertype='';      % Filter type
    end
    
    methods
        
        % trajectory constructor
        function obj = trajectory(type,cutoffFreq_movAvgOrder)
            obj.filtertype=type;
            
            % Check if the second argument was order or cutoff
            if strcmp(type,'movingAvg')
                obj.movAvgOrder=cutoffFreq_movAvgOrder;
                
            else
                obj.cutoff=cutoffFreq_movAvgOrder;
            end
            
        end
        
        %reset the trajectory
        function obj = reset_Trajectory(obj)
            obj.y = [];
            obj.traj = [];
        end
        
        %Change smoothing
        function obj = change_smoothfilter(obj,new_filteringType,cutoffFreq_movAvgOrder)
            obj.filtertype = new_filteringType;
            
            % Check if the second argument was order or cutoff
            if strcmp(new_filteringType,'movingAvg')
                obj.movAvgOrder=cutoffFreq_movAvgOrder;
            else
                obj.cutoff=cutoffFreq_movAvgOrder;
                obj.y = [];
                obj.traj = [];
            end
        end
        
        %Method for adding new data and perform smoothing.
        function obj=add_data(obj,inp_data)
            
            if strcmp(obj.filtertype,'movingAvg')
                pos_data_xy_input = inp_data(1:2);
            
                if isempty(obj.saved_pos)
                    saved_pos_len = 0;
                else
                    saved_pos_len = length(obj.saved_pos(1,:));     % How many saved
                                                                    % positions now?
                end

                if saved_pos_len < obj.movAvgOrder
                    obj.saved_pos(:,saved_pos_len+1) = pos_data_xy_input;
                else
                    obj.saved_pos(:,1:obj.movAvgOrder-1) =...   % Vector is now full,
                        obj.saved_pos(:,2:obj.movAvgOrder);     % shift one step back

                    obj.saved_pos(:,obj.movAvgOrder) = pos_data_xy_input;
                end
                
                if (saved_pos_len == obj.movAvgOrder)
                    moving_avg = [mean(obj.saved_pos(1,:)); ...
                                  mean(obj.saved_pos(2,:))];
                    obj.traj = [obj.traj moving_avg];
                end
                
            %If we have a butterworth or chebychev    
            else
                
                obj.y=[obj.y inp_data];
                
                %If we have obtained enough new data, perform smoothing
                if length(obj.y)-25>length(obj.traj)
                    obj.traj=obj.rt_smooth(obj.y,obj.traj);
                end
            end
            
        end
        
        %Function for smoothing the trajectory using butter or cheby.
        function smoothed_traj=rt_smooth(obj, data, old_traj)
            %real time smoothing
            lend = length(data);
            lenot = length(old_traj);
            smoothed_traj=[];

            if lenot < 20 %margin to not go out of bounds
                smoothed_traj = obj.smooth_trajectory(5,obj.cutoff,data,obj.filtertype);
            elseif lend-35>lenot
                tmpvec=[old_traj(1:2,(lenot-15):lenot) data(1:2, lenot+1:end)];
                tmpvec=obj.smooth_trajectory(5,obj.cutoff,tmpvec,obj.filtertype);
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


