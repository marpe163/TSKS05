classdef map < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        tag_list
        Anchor_list
        picture
    end
    
    methods
       % function obj = map(picture,tag)
        
       % obj.picture = picture;
       % obj.tag_list = [tag];
       % end
        
        function obj = map(picture)
        
        obj.picture = picture;
        end
        function set_tag_pos(obj,x,y,index)
        obj.tag_list(index).set_pos(x,y);
        end
        function out = get_pic(obj)
        out = obj.picture;
        end
    end
    
end

