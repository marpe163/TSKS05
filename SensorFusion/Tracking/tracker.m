classdef tracker < handle
  %Class enabling higher level abstraction of tracking. A tracker object is
  %fed data by the add_data method, and in turn it calculates the current
  %position (Based on the chosen filter) and an estimated trajectory 
  %(Done by low pass filtering) of the sequence of estimated positions.
  %   
  % Example use:
  % my_tracker=tracker('cvcc',1,1)
  %   
  % for it=1:length(measurements)
  %     my_tracker=my_tracker.add_data(measurements(1:2,it));
  % end
  % %Get the current estimated position
  % estimated_position = my_tracker.getPos();
  %   
  %   
  % %Get the estimated trajectory (can also be obtained on-the-fly)
  % estimated_trajectory=my_tracker.getTraj();
    
    properties
        kf=[]; %arbitrary filter that has measurement- and time update methods.
        trj=[];
        filterTraj=[];
        type='';
        smoothingType = '';
    end
    
    methods
        function obj = tracker(opt,x0,p0,sample_freq,cutoffFreq_movAvgOrder,smoothingType_)
            obj.smoothingType = smoothingType_;
            %constant velocity, cartesian coordinates
            tau = 1/sample_freq;
            if strcmp(opt,'cvcc')
                F=[1 0 x0(3) 0; 0 1 0 x0(4);0 0 1 0;0 0 0 1];
                Q=1*diag([1 1 15 15]);
                H=[1 0 0 0;0 1 0 0];
                R=10*[1,0;0,1];
                G=[1 0 tau^2/2 0;0 1 0 tau^2/2;0 0 tau 0; 0 0 0 tau];
                obj.kf=kalmantracker(F,H,Q,R,x0,p0,G);
            elseif strcmp(opt,'ekfctcc')
%                 x0=[0;0;-2;0;0.1];
%                 p0=0.1*diag([15 15 2 2 2]);
                Q=0.0005*diag([1 1 10 10 2]);
                H=[1 0 0 0 0;0 1 0 0 0];
                R=2*[1,0;0,1];
                G=blkdiag([1 0 tau^2/2 0;0 1 0 tau^2/2;0 0 tau 0; 0 0 0 tau],[1]);
                obj.kf=ekftracker(H,Q,R,x0,p0,G,tau);
            end
            
            
            obj.trj=trajectory(smoothingType_,cutoffFreq_movAvgOrder);
            obj.type=opt;
            
        end
        
        % Function to change the smoothing type, needs to change in
        % trajectory class as well
        function obj = change_smoothing(obj,new_smoothing_type,cutoffFreq_movAvgOrder)
            obj.smoothingType = new_smoothing_type;
            obj.trj = obj.trj.change_smoothfilter(new_smoothing_type,cutoffFreq_movAvgOrder);
        end
        
        function obj=add_data(obj,inp_data)
             obj.kf=obj.kf.measurementupdate(inp_data);
             obj.trj=obj.trj.add_data(obj.kf.xk);
             obj.filterTraj=[obj.filterTraj obj.kf.xk];
             obj.kf=obj.kf.timeupdate();
        end
        function fetchedTraj=getTraj(obj)
           fetchedTraj=obj.trj.traj; 
        end
        function position=getPos(obj)
            
               position=obj.kf.xk;
               position=position(1:2);
            
            
        end
        function cov=getCov(obj)
            
               cov=obj.kf.Pk;
               cov=cov(1:2,1:2);
            
        end
        function velocities=getVelocities(obj)
           velocities=obj.kf.xk;
           velocities=velocities(3:4);
        end
        function obj=measurementNoiseUpdate(obj,dx,dy,const,expo)
            
           obj.kf=obj.kf.measurementNoiseUpdate(dx,dy,const,expo) ;
        end
        
    end
end
   