classdef TestFile < handle
    properties
        % The name of the test file
        FileName
        % The number of data points received
        DataPointCount
        % Indicates the state of plotting
        State
        % The handle to animated line
        Line matlab.graphics.animation.AnimatedLine
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
            % Create animate line object
            obj.Line = animatedline;
            % Initial state is not plotting
            obj.State = 'stopped';
        end
        function delete(obj)
            %DELETE Destructor for the class.
            %
            % Avoid getting stuck in the paused state
            obj.State = 'stopped';
        end
        function plot(obj, ax)
            %PLOT Plot data on the axes.
            obj.clearPlot;
            obj.State = 'plotting';
            try
                % Attach line to the axes
                obj.Line.Parent = ax;
                % Print the first point
                plotDataPoint(obj.Line,1,obj.data,obj.time);
                startTime = datetime;
                % Print the following points with delay
                for i=2:obj.DataPointCount
                    % Check if plotting is paused or stopped
                    if strcmp(obj.State, 'paused')
                        pauseTime = datetime;
                        waitfor(obj, 'State', 'plotting');
                        % Resume the timing
                        startTime = startTime + (datetime - pauseTime);
                    end
                    if strcmp(obj.State, 'stopped')
                        return
                    end
                    % Wait if we are ahead of time
                    elapsed = datetime - startTime;
                    if obj.time(1) + elapsed < obj.time(i)
                        leadTime = obj.time(i) - obj.time(1) - elapsed;
                        pause(seconds(leadTime));
                    end
                    plotDataPoint(obj.Line,i,obj.data,obj.time);
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
            if strcmp(obj.State, 'plotting')
                obj.State= 'paused';
            elseif strcmp(obj.State, 'paused')
                obj.State = 'plotting';
            end
        end
        function clearPlot(obj)
            %CLEARPLOT Clear the plot.
            obj.State = 'stopped';
            obj.Line.clearpoints;
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
