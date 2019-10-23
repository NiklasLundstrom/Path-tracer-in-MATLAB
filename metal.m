classdef metal < material
     properties
        albedo = [1,1,1]
    end
    
    methods
        function obj = metal(albedo)
           obj.albedo(1:3) = albedo; 
        end
        
        function [continuePath, outDir, attenuation] = scatter(obj, inDir, hitInfo)
            continuePath = true;
            n = hitInfo.normal;
            outDir = inDir - 2*(inDir * n')*n;
            attenuation = obj.albedo;
        end
        
    end
    
end