classdef map < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        tag_list
        Anchor_list
        picture
    end
    
    methods
        
        function obj = map(picture)       
        obj.picture = imrotate(imread(picture),180);
        end
        function set_tag_pos(obj,x,y,index)
        obj.tag_list(index).set_pos(x,y);
        end
        function set_tag_pos3D(obj,x,y,z,index)
        obj.tag_list(index).set_pos3D(x,y,z);
        end
        function out = get_pic(obj)
        out = obj.picture;
        end
    end
    
end

