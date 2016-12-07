classdef Arduino < handle
    %ARDUINO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        SerialPortName
        SerialPort
        RawData
        RawDataCount
        CurrentPosition
    end
    
    methods
        % Constructor
        function obj = Arduino(name)
            obj.SerialPortName = name;
            obj.SerialPort = serial(obj.SerialPortName,'BaudRate',115200);
            obj.SerialPort.Terminator = 'CR/LF';
            obj.SerialPort.BytesAvailableFcn = {@mycallback,obj};
            obj.RawDataCount = 0;
            obj.CurrentPosition = 1;
            fopen(obj.SerialPort);
        end
        % Destructor
        function delete(obj)
            fclose(obj.SerialPort);
        end
        % Read data
        function data = read(obj)
            % WARNING: Possible bug if this branch not atomic!
            if obj.CurrentPosition > obj.RawDataCount
                waitfor(obj, 'RawDataCount', obj.CurrentPosition);
            end
            data = obj.RawData(:,obj.CurrentPosition);
            obj.CurrentPosition = obj.CurrentPosition+1;
        end
        % Push data
        function push(obj, data)
            obj.RawData = [obj.RawData data];
            obj.RawDataCount = obj.RawDataCount+1;
        end
    end
end

function mycallback(obj, event, arduino)
    data = fscanf(obj, '%d %d %d');
    arduino.push(data);
end
