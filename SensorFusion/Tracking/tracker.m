classdef tracker
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
        type=''
        
    end
    
    methods
        function obj = tracker(opt,x0,p0,sample_freq,cutoff)
            %constant velocity, cartesian coordinates
            tau = 1/sample_freq;
            if strcmp(opt,'cvcc')
                x0=[0;0;-2;0];
                p0=0.1*diag([15 15 2 2]);
                F=[1 0 x0(3) 0; 0 1 0 x0(4);0 0 1 0;0 0 0 1];
                Q=0.5*diag([1 1 10 10]);
                H=[1 0 0 0;0 1 0 0];
                R=2*[1,0;0,1];
                G=[1 0 tau^2/2 0;0 1 0 tau^2/2;0 0 tau 0; 0 0 0 tau];
            end
            
            obj.kf=kalmantracker(F,H,Q,R,x0,p0,G);
            obj.trj=trajectory(cutoff);
            obj.type=opt;
            
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
            if strcmp(obj.type,'cvcc')
               position=obj.kf.xk;
               position=position(1:2);
            end
            
        end
        function cov=getCov(obj)
            if strcmp(obj.type,'cvcc')
               cov=obj.kf.Pk;
               cov=cov(1:2,1:2);
            end
            
        end
    end
end
   