classdef map < handle
    % This Class is used to handle all the tags and anchor in the system.
    % The constructor takes only a image as input argument.
    
    properties
        tag_list
        Anchor_list
        picture
    end
    
    methods
        
        function obj = map(picture)       
        obj.picture = imrotate(imread(picture),180);
        end
        % Gives tags new positions
        function set_tag_pos(obj,x,y,tagindex)
        obj.tag_list(tagindex).set_pos(x,y);
        end
        % Return the picture of the map
        function out = get_pic(obj)
        out = obj.picture;
        end
    end
    
end

