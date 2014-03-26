classdef ElasticityParams
    
    properties
       xContactPoint
       yContactPoint
       xShiftCP
       xShiftCP_use_stiffness = false
       excludeInitial
       excludeInitial_use_stiffness = false
       indexStart
       xStart
       yStart
       indexEnd
       xEnd
       yEnd
       model
       radius = 2500
       E = 0
       b = 0
       y0 = 0
       dataForce
       dataIndentation
    end
    
    methods 
        function data = force_indentation(obj)
         dataLength = length(obj.dataIndentation);
         data(1,:) = obj.dataIndentation(1:dataLength);
         data(2,:) = obj.dataForce(1:dataLength);
        end % force_indentation()
        function data = force_indentation_to_fit(obj)
         dataLength = length(obj.dataIndentation);
         if obj.indexStart > 0
             indexStart = obj.indexStart;
         else
             indexStart = 0;
         end
         if obj.indexEnd < dataLength
             indexEnd = obj.indexEnd;
         else
             indexEnd = dataLength;
         end
         data(1,:) = obj.dataIndentation(indexStart:indexEnd);
         data(2,:) = obj.dataForce(indexStart:indexEnd);
        end % force_indentation_to_fit()
       
        
    end
    
end

