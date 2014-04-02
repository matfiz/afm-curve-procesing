classdef StiffnessParams
    
    properties
       numberOfSegments = 0
       xContactPoint
       yContactPoint
       stiffnessSegments       
       dataForce
       dataIndentation
       dataH %distance cell membrane-probe
    end
    
    methods 
        %function data = xLength(obj)
        % data = abs(xStartPos-xEndPos)
        %end % xLength
        function data = force_indentation(obj)
         dataLength = length(obj.dataIndentation);
         data(1,:) = obj.dataIndentation(1:dataLength);
         data(2,:) = obj.dataForce(1:dataLength);
        end % force_indentation()
       
        function data = height_distance(obj)
         dataLength = length(obj.dataIndentation);
         data(1,:) = obj.dataIndentation(1:dataLength);
         data(2,:) = obj.dataH(1:dataLength);
        end % height_distance()
        
    end
    
end

