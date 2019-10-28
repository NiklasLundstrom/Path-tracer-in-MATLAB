classdef glass < material
    %Refraction and reflection with fresnel effect
     properties
        albedo = [1,1,1]
        refIdx = 1.5
    end
    
    methods
        function obj = glass(albedo, refIdx)
           obj.albedo(1:3) = [1,1,1];%albedo; 
           obj.refIdx = refIdx;
        end
        
        function [continuePath, outDir, attenuation] = scatter(obj, inDir, hitInfo)
            continuePath = true;
            attenuation = obj.albedo;
            
            n = hitInfo.normal;
            
            if (dot(inDir, n) > 0)
                % from the inside
                outN = -n;
                niOverNt = obj.refIdx;
                cosine = obj.refIdx * dot(inDir, n);
            else
                % from the outside
                outN = n;
                niOverNt = 1/obj.refIdx;
                cosine = -dot(inDir, n);
            end
            
            [shouldRefract, refractDir] = refract(obj, inDir, outN, niOverNt);
            % approximate fresnel factor
            if shouldRefract
                reflectProb = schlick(obj, cosine, obj.refIdx);
            else
                reflectProb = 1;
            end
                
            % pick outgoing direction
            if (rand < reflectProb)  
                outDir = inDir - 2*(inDir * n')*n;
            else
                outDir = refractDir;
            end
            
        end
    end
    
    methods (Access = protected)
        
        function [shouldRefract, refractedDir] = refract(obj, v, n, niOverNt)
            dt = dot(v,n);
            discriminant = 1 - niOverNt*(1-dt*dt);
            if (discriminant > 0)
                shouldRefract = true;
                refractedDir = niOverNt*(v - n*dt) - n*sqrt(discriminant);
            else
               shouldRefract = false;
               refractedDir = NaN;
            end
        end
        
        function prob = schlick(obj, cosine, refIdx)
           %Approximation of fresnel factor
           r0 = (1-refIdx)/(1+refIdx);
           r0 = r0*r0;
           prob = r0 + (1-r0)*(1-cosine)^5;
        end
        
    end
    
end