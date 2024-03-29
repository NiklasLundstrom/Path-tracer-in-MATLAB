classdef (Abstract) material < handle
    % Abstrac class for material. A concrete material must define scatter
    % function, which returns an outoing ray direction and attenuation.
    % Could also be a light source if continuePath is False and attenuation
    % is the light colour/intensity.

    methods (Abstract)
        [continuePath, outDir, attenuation] = scatter(obj, inDir, hitInfo);%Choose outgoing direction for next ray 
    end
    
    methods (Access = protected)
       function direction = cosineRandDir(obj, normal)
            u = rand(1,2);
            a = 1 - 2*u(1); 
            b = sqrt(1 - a*a); 
            phi = 2*pi*u(2); 
            x = normal(1) + b*cos(phi);
            y = normal(2) + b*sin(phi); 
            z = normal(3) + a; 
            direction = [x,y,z]/norm([x,y,z]);
        end 
    end
end