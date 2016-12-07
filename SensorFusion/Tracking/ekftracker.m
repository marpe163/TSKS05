classdef ekftracker
    %Implementation of an extended kalman filter for iterative filtering.
    %The filter is using a coordinated turn model, in cartesian coordinates. 
    
    properties
        %Notation like in Gustafsson's sensor fusion book
        %xk+1=Fxk+v
        %yk=Hk+e
        F=[]; %Lower case f to indicate non linear model.       
        H=[]; %Still have linear measurements of position.
        
            
        Q=[]; %model noise
        R=[]; %measurement noise
        G=[]; %Model for the noise of the motion model
        
        xk=[];
        Pk=[];
        
        y=[]; %vector of measurements
        trajectory=[]%vector of estimated trajectory.
        T=0;
    end
    
    methods
        function obj = ekftracker(h,q,r,x0,p0,g,tau)
            if nargin < 6
               error('Too few arguments given to the constructor') 
            end
           
           obj.F=obj.getfprime(x0);
           obj.H=h;
           obj.Q=q;
           obj.R=r;           
           obj.xk=x0;
           obj.Pk=p0;
           obj.G=g;
           obj.T=tau;
           
        end
        function obj=timeupdate(obj)
            obj.F=obj.getfprime(obj.xk);
            obj.xk=obj.coord_turn(obj.xk); 
            obj.Pk=obj.F*obj.Pk*obj.F'+obj.G*obj.Q*obj.G';
        end
        function obj=measurementupdate(obj,yk)
            obj.y=[obj.y yk];           
            K=obj.Pk*obj.H'*inv(obj.H*obj.Pk*obj.H'+obj.R);
            obj.xk=obj.xk+K*(yk-obj.H*obj.xk);
            obj.trajectory=[obj.trajectory [obj.xk(1);obj.xk(2)]];
            obj.Pk=obj.Pk-K*obj.H*obj.Pk;
  
        end
        function transf = coord_turn(obj,xk)
           X=xk(1);
           Y=xk(2);
           vx=xk(3);
           vy=xk(4);
           w=xk(5);
           transf=ones(5,1);
           transf(1)=X+(vx/w)*sin(w*obj.T)-(vy/w)*(1-cos(w*obj.T));
           transf(2)=Y+(vx/w)*(1-cos(w*obj.T))+(vy/w)*sin(w*obj.T);
           transf(3)=vx*cos(w*obj.T)-vy*sin(w*obj.T);
           transf(4)=vx*sin(w*obj.T)+vy*cos(w*obj.T);
           transf(5)=w;
        end
        function F=getfprime(obj,xk)
           X=xk(1);
           Y=xk(2);
           vx=xk(3);
           vy=xk(4);
           w=xk(5);
           A=[0 0 1 0 0;0 0 0 1 0;0 0 0 -w -vy;0 0 w 0 vx;0 0 0 0 0];
           F=expm(A*obj.T);
        end
        function obj=measurementNoiseUpdate(obj,deltax,deltay,const,expo)
            obj.R=const*[1/((deltax)^expo) 0;0 1/(deltay^expo)];
        end
        
    end
    
end

