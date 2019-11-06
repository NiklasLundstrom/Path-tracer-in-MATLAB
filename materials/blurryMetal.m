classdef blurryMetal < material
    % Metal material with blurry reflections. Samples sphere with radius r
    % for the outgoing ray to create blur.
     properties
        albedo = [1,1,1]
        r = 0.5
    end
    
    methods
        function obj = blurryMetal(albedo, r)
           obj.albedo(1:3) = albedo; 
           obj.r = r;
        end
        
        function [continuePath, outDir, attenuation] = scatter(obj, inDir, hitInfo)
            continuePath = true;
            attenuation = obj.albedo;
            
            n = hitInfo.normal;
            refDir = inDir - 2*(inDir * n')*n;
            refDir = refDir./norm(refDir);
            outDir = uniformSphere(obj, obj.r, refDir, n);
        end
    end
    
    methods (Access = protected)
        function outDir = uniformSphere(obj, R, refDir, normal)
            % Sample a sphere uniformly using rejection sampling. Outgoing
            % direction is the sphere around the standard reflection
            % direction.
            point = ones(1,3);
            outDir = zeros(1,3);
            while (norm(point)>1) || (dot(outDir, normal)<0)
                point = rand(1,3)*2 - 1;
                outDir = refDir + R*point;
            end
        end
    end
end