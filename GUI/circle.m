classdef circle < handle
    % The circle class is used to represent the tag 
    
    % The class needs to know its location on the map and its tag ID
    % Besides that the tag is represented by a image, in this case its a 
    % square with a color chosen in the constructor.
    % Using the class involves methods for setting the position and
    % retreving the image.
    properties
        Xpos
        Ypos
        on_img
        radius
        ID
        
    end
    
    methods
        function obj = circle(color,rad,tagID)
        obj.on_img = rectangle('Curvature',[1 1],'Facecolor',color);
        obj.radius = rad;
        obj.ID = tagID;
        end
        function set_pos(obj,x , y)   
                obj.on_img.Position = [(x - obj.radius), (y - obj.radius), 2*obj.radius, 2*obj.radius];
      
        end
        function set_pos3D(obj,x , y,z)   
                obj.on_img.Position = [(x - obj.radius), (y - obj.radius),(z - obj.radius), 2*obj.radius, 2*obj.radius];
      
        end
        function pic = get_pic(obj)
        pic = obj.on_img;       
        end
       function delete(obj)
       delete(obj.on_img)
       
       end
        
    
    end
    
end

