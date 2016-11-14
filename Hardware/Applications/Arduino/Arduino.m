classdef Arduino < handle
    %ARDUINO A class that provides access to the Arduino board
    %   An object of this class represent a connection to the Arduino
    %   board. After initialization via Arduino(SerialPortName) the object
    %   accumulates data from the serial port automatically for later
    %   retrieval.

    properties
        % The name of the serial port
        %
        % On Linux it looks like this:
        %   '/dev/ttyS99'
        %
        % On Windows it looks like this:
        %   'COM3'
        SerialPortName
        % The serial port object to the Arduino board
        SerialPort
        % All data points received
        DataPoints
        % The number of data points received
        DataPointCount
        % The index that will be read next
        CurrrentDataPointIndex
    end
    
    methods
        function obj = Arduino(name)
            % ARDUINO Create and open the serial port.
            %    A = ARDUINO(SerialPortName) creates and opens the serial
            %    port. After this call DataPoints will start accumulate
            %    automatically.
            %
            %    See Also Arduino.SerialPortName
            obj.SerialPortName = name;
            obj.SerialPort = serial(obj.SerialPortName,'BaudRate',115200);
            obj.SerialPort.Terminator = 'CR/LF';
            obj.SerialPort.BytesAvailableFcn = {@mycallback,obj};
            obj.DataPointCount = 0;
            obj.CurrrentDataPointIndex = 1;
            fopen(obj.SerialPort);
        end
        function delete(obj)
            % DELETE Close the serial port.
            fclose(obj.SerialPort);
        end
        function data = read(obj)
            % READ Get a data point and increment CurrentDataPointIndex.

            % WARNING: Possible bug if this branch not atomic!
            if obj.CurrrentDataPointIndex > obj.DataPointCount
                waitfor(obj, 'DataPointCount', obj.CurrrentDataPointIndex);
            end
            data = obj.DataPoints(:,obj.CurrrentDataPointIndex);
            obj.CurrrentDataPointIndex = obj.CurrrentDataPointIndex+1;
        end
        function data = readLatest(obj)
            % READLATEST Get the most recent data point.
            %    Get the most recent data point and set
            %    CurrentDataPointIndex to the next one
            data = obj.DataPoints(:,obj.DataPointCount);
            obj.CurrrentDataPointIndex = obj.DataPointCount+1;
        end
        function push(obj, data)
            % PUSH Push data point.
            obj.DataPoints = [obj.DataPoints data];
            obj.DataPointCount = obj.DataPointCount+1;
        end
    end
end

function mycallback(obj, event, arduino)
    data = fscanf(obj, '%d %d %d');
    arduino.push(data);
end
