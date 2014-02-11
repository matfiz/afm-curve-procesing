classdef StiffnessSegment
   
    properties
       xStartPos
       yStartPos
       xEndPos
       yEndPos
       slope
       freeCoef
       correlation       
    end
    
    methods 
        function data = xLength(obj)
         data = abs(obj.xStartPos-obj.xEndPos);
        end % xLength
       
        
    end
    
end

