classdef scene < handle
    %scene Creates scene with multiple meshes. Creating single buffer for
    %multiple meshes. Handles ray intersection.
    %   Right-handed coordinate system!
    
    properties
        meshes mesh
    end
    
    methods (Access = public)
        function obj = scene(sceneName)
            %UNTITLED4 Construct an instance of this class
            %   Detailed explanation goes here            
            if (strcmp(sceneName, 'Single Triangle'))
                triangle = mesh('Single Triangle');
                triangle.material = lambertian(rand(1,3));
                obj.meshes(1) = triangle;

            elseif (strcmp(sceneName, 'Sphere'))
                sphere = mesh('Sphere');
                sphere.material = lambertian([1,0,0]);
                obj.meshes(1) = sphere; 
                    
                plane = mesh('Plane');
                plane.material = lambertian([0.5, 0.5, 0.5]);
                obj.meshes(2) = plane;
                    
            else
                error('Invalid scene name!');
            end
        end
        
    end
    
end