classdef positioning
    % Positioning using the moving avarage or the estimated position
    % can also be used for tracking of the tag, plotting the moving
    % avarages
    
    properties
        current_pos = [];   % vector 2x1
        pos_to_save = 10;   % integer, default = 10
        saved_pos = [];     % vector of saved, earlier positions 2xX
    end
    
    methods
        function obj = positioning(pos_input,pos_to_save_input)
            if nargin < 1
               error('Too few arguments given to the constructor') 
            end
            obj.current_pos = pos_input;
            obj.saved_pos = obj.current_pos;
            if nargin == 2
                obj.pos_to_save = pos_to_save_input;
            end
        end
        
        function obj = update_position(obj,pos_input)
            obj.current_pos = pos_input;
            saved_pos_len = length(obj.saved_pos(1,:));     % How many saved
                                                            % positions now?
            
            if saved_pos_len < obj.pos_to_save
                obj.saved_pos(:,saved_pos_len+1) = pos_input;
            else
                obj.saved_pos(:,1:obj.pos_to_save-1) =...   % Vector is now full,
                    obj.saved_pos(:,2:obj.pos_to_save);     % shift one step back
                
                obj.saved_pos(:,obj.pos_to_save) = pos_input;
            end
        end
        
        function moving_avg = moving_avarage(obj)
            moving_avg = [mean(obj.saved_pos(1,:)) ...    % Works like a
                ; mean(obj.saved_pos(2,:))];            % moving avarage
        end
        
    end
    
end