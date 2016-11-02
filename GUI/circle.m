classdef circle < handle
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Xpos
        Ypos
        on_img
        radius
        
    end
    
    methods
        function obj = circle(color,rad)
        obj.on_img = rectangle('Curvature',[1 1],'Facecolor',color);
        obj.radius = rad;
        end
        function set_pos(obj,x , y)   
                obj.on_img.Position = [(x - obj.radius), (y - obj.radius), 2*obj.radius, 2*obj.radius];
      
        end
        function pic = get_pic(obj)
        pic = obj.on_img;       
        end
       function delete(obj)
       delete(obj.on_img)
       
       end
        
    
    end
    
end

