classdef kalmantracker
    %Implementation of a kalman filter for iterative filtering. Updates
    %with each new measurement.
    %   Detailed explanation goes here
    
    properties
        %Notation like in Gustafsson's sensor fusion book
        %xk+1=Fxk+v
        %yk=Hk+e
        F=[];       
        H=[];
            
        Q=[]; %model noise
        R=[]; %measurement noise
        G=[]; %Model for the noise of the motion model
        
        xk=[];
        Pk=[];
        
        y=[]; %vector of measurements
        trajectory=[]%vector of estimated trajectory.
    end
    
    methods
        function obj = kalmantracker(f,h,q,r,x0,p0,g)
            if nargin < 6
               error('Too few arguments given to the constructor') 
            end
           obj.F=f;
           obj.H=h;
           obj.Q=q;
           obj.R=r;           
           obj.xk=x0;
           obj.Pk=p0;
           obj.G=g;
        end
        function obj=timeupdate(obj)
            obj.xk=obj.F*obj.xk;
            obj.Pk=obj.F*obj.Pk*obj.F'+obj.G*obj.Q*obj.G';
        end
        function obj=measurementupdate(obj,yk)
            obj.y=[obj.y yk];
            K=obj.Pk*obj.H'*inv(obj.H*obj.Pk*obj.H'+obj.R);
            obj.xk=obj.xk+K*(yk-obj.H*obj.xk);
            obj.trajectory=[obj.trajectory [obj.xk(1);obj.xk(2)]];
            obj.Pk=obj.Pk-K*obj.H*obj.Pk;
  
        end
        function obj=measurementNoiseUpdate(obj,deltax,deltay,const,expo)
            obj.R=const*[1/((deltax)^expo) 0;0 1/(deltay^expo)];
        end
        
    end
    
end

