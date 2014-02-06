classdef StiffnessParams
    
    properties
       numberOfSegments
       xContactPoint
       yContactPoint
       stifnessSegments       
       dataForce
       dataIndentation
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
       
        
    end
    
end

