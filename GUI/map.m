classdef map < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        tag_list
        Anchor_list
        picture
    end
    
    methods
        function obj = map(tag)
        obj.tag_list = [tag];
        end
        function set_tag_pos(obj,x,y,index)
        obj.tag_list(index).set_pos(x,y);
        end
    end
    
end

