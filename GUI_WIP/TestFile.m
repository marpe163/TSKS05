classdef TestFile < handle
    properties
        % The name of the test file
        FileName
        % The number of data points received
        DataPointCount
        data
        time
        t timer
    end
    
    methods
        function obj = TestFile(filename)
            % Load the file with test data
            obj.FileName = filename;
            s = load(filename);
            obj.data = s.data / 1000;
            obj.time = s.time;
            obj.DataPointCount = size(obj.data,2);
            % Create timers for each data point
            for i=1:obj.DataPointCount
                obj.t(i) = timer();
            end
        end
        function startPlotting(obj, ax, delay)
            if ~exist('delay', 'var')
                delay = [0 0 0 0 0 2]';
            end
            % Calculate times for plotting
            delta = datevec(datetime)' - obj.time(:,1);
            deltas = repmat(delta, [1 obj.DataPointCount]);
            delays = repmat(delay, [1 obj.DataPointCount]);
            firetime = obj.time + deltas + delays;
            % Plot function
            for i=1:obj.DataPointCount
                obj.t(i).TimerFcn = ...
                    {@plotDataPoint,i,ax,obj.data,datetime(obj.time(:,i)')};
            end
            startat(obj.t, firetime');
        end
        function delete(obj)
            stop(obj.t);
            delete(obj.t);
        end
    end
end

function plotDataPoint(~,~,i,ax,data,time)
    plot(ax,data(1,i),data(2,i),'x');
    title(ax, datestr(time));
end