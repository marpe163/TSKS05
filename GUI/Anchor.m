classdef Anchor < handle
    % This class handles the anchor position and where it is drawn on the
    % map. It only has one method for setting its position.
    % The consturor takes three arguments: Firs a position as a row vector
    % of lenght two, the raduis and the color of the anchor.
    
    properties
        pos
        on_img
        id
        radius
    end
    
    methods
        
        function obj = Anchor(pos,rad,color)
        obj.pos = pos;
        obj.on_img = rectangle('Curvature',[1 0],'Facecolor',color);
        obj.radius = rad;
        obj.on_img.Position = [(pos(1) - obj.radius), (pos(2) - obj.radius), 2*obj.radius, 2*obj.radius];
        
        end
        function set_pos(obj,xypos)
            obj.on_img.Position = [(xypos(1) - obj.radius), (xypos(2) - obj.radius), 2*obj.radius, 2*obj.radius];
            obj.pos = xypos;

        end
        
    end
    
end

