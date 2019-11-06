classdef scene < handle
    % Creates scene with multiple meshes. Creating different buffers 
    % for each mesh.
    % note: Right-handed coordinate system!
    
    properties
        meshes mesh
    end
    
    methods (Access = public)
        function obj = scene(sceneName)          
            if (strcmp(sceneName, 'Single Triangle'))
                transformation.translation = [0,-0.5,-1];
                triangle = mesh('Single Triangle', transformation);
                triangle.material = lambertian(rand(1,3));
                obj.meshes(1) = triangle;

            elseif (strcmp(sceneName, 'Spheres'))
                % sphere
                transformation = struct;
                transformation.scale = [1,1,1];
                transformation.translation = [1.2,0,-4];
                sphere = mesh('Sphere', transformation);
                sphere.material = lambertian([1,0.1,0.1]);
                obj.meshes(1) = sphere; 
                    
                % plane
                transformation = struct;
                transformation.scale = [10,1,10];
                transformation.translation = [0,-1,-10];
                plane = mesh('Plane', transformation);
                plane.material = lambertian([0.5, 0.5, 0.5]);
                obj.meshes(2) = plane;
                
                % sphere reflective
                transformation = struct;
                transformation.scale = [1,1,1];
                transformation.translation = [-1.5,0,-4];
                sphere2 = mesh('Sphere', transformation);
                sphere2.material = metal([0.3,1,0.3]);
                obj.meshes(3) = sphere2;
                
                % sphere glass
                transformation = struct;
                transformation.scale = [1,1,1];
                transformation.translation = [0,0.3,-3];
                sphere3 = mesh('Sphere', transformation);
                sphere3.material = glass([0.3,1,0.3], 1.5);
                obj.meshes(4) = sphere3;
                
                % sphere glass
                transformation = struct;
                transformation.scale = -0.8*[1,1,1];
                transformation.translation = [0,0.3,-3];
                sphere4 = mesh('Sphere', transformation);
                sphere4.material = glass([0.3,1,0.3], 1.5);
                obj.meshes(5) = sphere4;
                    
            else
                error('Invalid scene name!');
            end
        end      
    end  
end