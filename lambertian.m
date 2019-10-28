classdef lambertian < material
    % Lambertian material. Shoots diffuse cosine weighted ray.
    properties
        albedo = [0,0,0]
    end
    
    methods
        function obj = lambertian(albedo)
           obj.albedo(1:3) = albedo; 
        end
        
        function [continuePath, outDir, attenuation] = scatter(obj, inDir, hitInfo)
            continuePath = true;
            outDir = cosineRandDir(obj, hitInfo.normal);
            attenuation = obj.albedo;
        end
        
    end
    
    methods (Access = protected)
        function outDir = cosineRandDir(obj, hitNormal)
            outDir = cosineRandDir@material(obj, hitNormal);
        end
        
    end
end