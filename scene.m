classdef scene < handle
    %scene Creates scene with multiple meshes. Creating single buffer for
    %multiple meshes. Handles ray intersection.
    %   Right-handed coordinate system!
    
    properties
        vertices
        verts1
        verts2
        verts3
        indices
        colors
        normals
    end
    
    methods (Access = public)
        function obj = scene(sceneName)
            %UNTITLED4 Construct an instance of this class
            %   Detailed explanation goes here            
            if (strcmp(sceneName, 'Single Triangle'))
                triangle = mesh('Single Triangle');
                    obj.verts1 = triangle.verts1;
                    obj.verts2 = triangle.verts2;
                    obj.verts3 = triangle.verts3;
                    obj.indices = triangle.indices;
                    obj.colors = triangle.colors;
                    obj.normals = triangle.normals;
            elseif (strcmp(sceneName, 'Sphere'))
                sphere = mesh('Sphere');
                    obj.verts1 = sphere.verts1;
                    obj.verts2 = sphere.verts2;
                    obj.verts3 = sphere.verts3;
                    obj.indices = sphere.indices;
                    obj.colors = sphere.colors;
                    obj.normals = sphere.normals;
                    
                plane = mesh('Plane');
                    obj.verts1 = [obj.verts1 ; plane.verts1];
                    obj.verts2 = [obj.verts2 ; plane.verts2];
                    obj.verts3 = [obj.verts3 ; plane.verts3];
                    obj.indices = [obj.indices ; plane.indices + size(sphere.colors,1)];
                    obj.colors = [obj.colors ; plane.colors];
                    obj.normals = [obj.normals ; plane.normals];
                    
            else
                error('Invalid scene name!');
            end
        end
        
    end
    
end