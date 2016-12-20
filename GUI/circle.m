classdef circle < handle
    % The circle class is used to represent the tag 
    %
    % The class needs to know its location on the map and its tag ID
    % Besides that the tag is represented by a image, in this case its a 
    % square with a color chosen in the constructor.
    % Using the class involves methods for setting the position and
    % retreving the image. The tag ID argument in the constructor 
    % isn't used but might be usefull for futher development of the system.
    % The constructor for the cirlce takes three arguments. Fist a 
    % string with the color specifed for the cirlce. Second the radius
    % of the circle. Third it takes the tags ID as a string.
    
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
        % Give the circle a new position
        function set_pos(obj,x , y)   
                obj.on_img.Position = [(x - obj.radius), (y - obj.radius), 2*obj.radius, 2*obj.radius];
      
        end
        % Return the cirlce position
        function out = get_pos(obj)
        out = [obj.Xpos obj.Ypos];
        end
        % Return the picture for the cirlce
        function pic = get_pic(obj)
        pic = obj.on_img;       
        end
        % Class destructor
       function delete(obj)
       delete(obj.on_img)
       
       end
        
    
    end
    
end

