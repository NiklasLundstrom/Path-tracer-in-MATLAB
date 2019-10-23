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
                transformation.translation = [0,-0.5,-1];
                triangle = mesh('Single Triangle', transformation);
                triangle.material = lambertian(rand(1,3));
                obj.meshes(1) = triangle;

            elseif (strcmp(sceneName, 'Sphere'))
                % sphere
                transformation = struct;
                transformation.scale = [1,1,1];
                transformation.translation = [0.5,0,-2];
                sphere = mesh('Sphere', transformation);
                sphere.material = lambertian([1,0.1,0.1]);
                obj.meshes(1) = sphere; 
                    
                % plane
                transformation = struct;
                transformation.scale = [3,3,3];
                transformation.translation = [0,-1,-3];
                plane = mesh('Plane', transformation);
                plane.material = lambertian([0.5, 0.5, 0.5]);
                obj.meshes(2) = plane;
                
                % sphere reflective
                transformation = struct;
                transformation.scale = [1,1,1]*0.25;
                transformation.translation = [-0.75,-0.75,-1.5];
                sphere2 = mesh('Sphere', transformation);
                sphere2.material = metal([0.3,1,0.3]);
                obj.meshes(3) = sphere2;
                    
            else
                error('Invalid scene name!');
            end
        end
        
    end
    
end