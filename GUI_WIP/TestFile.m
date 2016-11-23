classdef TestFile < handle
    properties
        % The name of the test file
        FileName
        % The number of data points received
        DataPointCount
        % Plotting or paused
        PlotPaused
        data
        time
    end
    methods
        function obj = TestFile(filename)
            % Load the file with test data
            obj.FileName = filename;
            s = load(filename);
            obj.data = s.data / 1000;
            obj.time = datetime(s.time')';
            obj.DataPointCount = size(obj.data,2);
        end
        function delete(obj)
            %DELETE Destructor for the class.
            %
            % Avoid getting stuck in the paused state
            obj.PlotPaused = false;
        end
        function plot(obj, ax)
            %PLOT Plot data on the axes.
            obj.PlotPaused = false;
            try
                % Create animate line object
                hLine = animatedline(ax);
                % Print the first point
                plotDataPoint(hLine,1,obj.data,obj.time);
                startTime = datetime;
                % Print the following points with delay
                for i=2:obj.DataPointCount
                    % Check if plotting is paused
                    if obj.PlotPaused
                        waitfor(obj, 'PlotPaused', false);
                    end
                    % Wait if we are ahead of time
                    elapsed = datetime - startTime;
                    if obj.time(1) + elapsed < obj.time(i)
                        leadTime = obj.time(i) - obj.time(1) - elapsed;
                        pause(seconds(leadTime));
                    end
                    plotDataPoint(hLine,i,obj.data,obj.time);
                end
            catch ME
                % The figure might be closed when plotting
                if strcmp(ME.identifier, 'MATLAB:class:InvalidHandle')
                    % disp('The figure is closed, stop plotting.');
                else
                    disp('Unexpected exception:');
                    disp(['  identifier: ', ME.identifier]);
                    disp(['     message: ', ME.message]);
                end
                return
            end
        end
        function togglePlotting(obj)
            %TOGGLEPLOTTING Pause or resume plotting.
            if obj.PlotPaused
                obj.PlotPaused = false;
            else
                obj.PlotPaused = true;
            end
        end
    end
end

function plotDataPoint(hLine,i,data,time)
    % Add the data point to the animated line
    addpoints(hLine,data(1,i),data(2,i));
    drawnow
    % Display current time in the title
    title(hLine.Parent, datestr(time(i)));
end
