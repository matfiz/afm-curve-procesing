classdef StifnessSegment
%properties:
%   params
%       xStartPos
%       yStartPos
%       xEndPos
%       yEndPos
%       slope
%       freeCoef
%       correlation
    
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
         data = abs(xStartPos-xEndPos)
        end % xLength
       
        
    end
    
end

