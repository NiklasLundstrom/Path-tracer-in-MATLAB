classdef mesh < handle
    %UNTITLED4 Summary of this class goes here
    %   Right-handed coordinate system!
    
    properties
        vertices
        indices
        colors
    end
    
    methods (Access = public)
        function obj = mesh(meshName)
            %UNTITLED4 Construct an instance of this class
            %   Detailed explanation goes here
            if (strcmp(meshName, 'Single Triangle'))
                createSingleTriangle(obj);
            else
                error('Invalid mesh name!');
            end
        end
        
        function [hitPoint, hitMaterial] = closestHit(obj, rayOrigin, rayDirection)
            hitPoint = [Inf, Inf, Inf];
            hitMaterial = [0, 0, 0];
            hitIdx = 0;
            u_min = 0; v_min = 0;
            t_min = Inf;
            for idx = 1:size(obj.indices,1)
                [t, u, v] = isHit(obj, rayOrigin, rayDirection, idx);
                if (t > 0 && t < t_min)
                   t_min = t; u_min = u; v_min = v;
                   hitIdx = idx;
                end
            end
            if (hitIdx ~= 0)
               hitPoint = rayOrigin + rayDirection * t_min;
               colors = obj.colors(obj.indices(hitIdx,:), :);
               hitMaterial = colors(1,:) * (1 - u_min - v_min)...
                            +colors(2,:) * u_min...
                            +colors(3,:) * v_min;
            end
        end
    end
    methods (Access = private)
        function createSingleTriangle(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.vertices = [-0.5, -0.5, -1;...
                             0.5, -0.5, -1;...
                             0.0,  0.5, -1];
            obj.indices = [1, 2, 3];
            obj.colors  =  [1, 0, 0;...
                            0, 1, 0;...
                            0, 0, 1];
        end
        
        function [depth, u, v] = isHit(obj, rayOrigin, rayDirection, triangleIdx)
            % Möller–Trumbore algorithm
            % hitpoint: [isHit bool, hit point coordinates xyz]
            epsilon = 1e-5;
            depth = -1;
            u = 0; v = 0;
            
            verts = obj.vertices(obj.indices(triangleIdx,:),:);
            edge1 = verts(2,:) - verts(1,:);
            edge2 = verts(3,:) - verts(1,:);
            h = cross(rayDirection, edge2);
            a = edge1 * h';
            if (a > -epsilon && a < epsilon)
                return
            end
            f = 1.0/a;
            s = rayOrigin - verts(1,:);
            u = f * s * h'; % 1st barycentric
            if (u < 0.0 || u > 1.0)
                return
            end
            q = cross(s, edge1);
            v = f * rayDirection * q'; % 2nd barycentric
            if (v < 0.0 ||  (u + v) > 1.0)
                return
            end
            
            t = f * edge2 * q';
            if (t > epsilon && t < 1/epsilon)% intersection!
                depth = t;
                return
            else
                return
            end
        end
    end
end

