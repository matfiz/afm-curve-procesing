classdef Curve
%properties:
%   params
%       xPos
%       yPos
%       mode(constant-height,...)
%       closedLoop (true/false)
%       sensitivity
%       springConstant
%       extendTime
%       retractTime
%       extendPauseTime
%   data
%       height
%       deflection
%       height measured smoothed
%       height measured
%       series time
%       segment time
    
    properties
        name
        xPos
        yPos
        mode
        closedLoop
        sensitivity
        springConstant
        extendTime
        retractTime
        extendPauseTime
        extendLength
        retractLength
        pauseLength
        dataHeight
        dataDeflection
        dataHeightMeasuredSmoothed
        dataHeightMeasured
        dataSeriesTime
        dataSegmentTime
        fancyNames
        units
        dataSteps
        
    end
    
    methods 
        function data = force_distance_approach(obj)
         % disp(['Ala ' obj.extendLength])
         data(1,:) = obj.dataHeightMeasured(1:obj.extendLength);
         data(2,:) = obj.dataDeflection(1:obj.extendLength);
        end % force_distance_approach()
        function data = force_distance_pause(obj)
         data(1,:) = obj.dataHeightMeasured(obj.extendLength+1:obj.extendLength+obj.pauseLength);
         data(2,:) = obj.dataDeflection(obj.extendLength+1:obj.extendLength+obj.pauseLength);
        end % force_distance_pause()
        function data = force_distance_retract(obj)
         data(1,:) = obj.dataHeightMeasured(obj.extendLength+obj.pauseLength+1:length(obj.dataHeightMeasured));
         data(2,:) = obj.dataDeflection(obj.extendLength+obj.pauseLength+1:length(obj.dataDeflection));
        end % force_distance_retract()
        function data = force_time(obj)
         data(1,:) = obj.dataSeriesTime(1:length(obj.dataSeriesTime));
         data(2,:) = obj.dataDeflection(1:length(obj.dataDeflection));
        end % force_time()
        function data = force_time_approach(obj)
         % disp(['Ala ' obj.extendLength])
         data(1,:) = obj.dataSeriesTime(1:obj.extendLength);
         data(2,:) = obj.dataDeflection(1:obj.extendLength);
        end % force_distance_approach()
        function data = force_time_pause(obj)
         data(1,:) = obj.dataSeriesTime(obj.extendLength+1:obj.extendLength+obj.pauseLength);
         data(2,:) = obj.dataDeflection(obj.extendLength+1:obj.extendLength+obj.pauseLength);
        end % force_distance_pause()
        function data = force_time_retract(obj)
         data(1,:) = obj.dataSeriesTime(obj.extendLength+obj.pauseLength+1:length(obj.dataSeriesTime));
         data(2,:) = obj.dataDeflection(obj.extendLength+obj.pauseLength+1:length(obj.dataDeflection));
        end % force_distance_retract()
        
        function SetDataSteps(obj, step_array)
         obj.dataSteps = step_array;    
        end
        
    end
    
end

