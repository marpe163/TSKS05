function [ xpos,ypos ] = start_track(x,y)
tracking_on = 1;
%if(tracking_on == 1)
 %   { tracking_on = 0;
  %      }
   % else
    %    {tracking_on = 1
     %       }
%end
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here 
xpos = x + 5;
ypos = y + 20*sin(x);

end

