classdef mesh < handle
    %UNTITLED4 Summary of this class goes here
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
        function obj = mesh(meshName)
            %UNTITLED4 Construct an instance of this class
            %   Detailed explanation goes here            
            if (strcmp(meshName, 'Single Triangle'))
                createSingleTriangle(obj);
            elseif (strcmp(meshName, 'Sphere'))
                createSphere(obj);
            else
                error('Invalid mesh name!');
            end
        end
        
        function [hitPoint, hitMaterial] = closestHit(obj, rayOrigin, rayDirection)
            hitPoint = [Inf, Inf, Inf];
            [t, u, v] = getAllHits(obj, rayOrigin, rayDirection);
            
            if all(isnan(t)) % no hits
                hitMaterial = miss(obj, rayDirection);
                return
            end
            % get closest hit
            [t_min, hitIdx] = min(t);
            hitPoint = rayOrigin + rayDirection * t_min;
            triColors = obj.colors(obj.indices(hitIdx,:), :);
            hitMaterial = triColors(1,:) * (1 - u(hitIdx) - v(hitIdx))...
                        + triColors(2,:) * u(hitIdx)...
                        + triColors(3,:) * v(hitIdx);
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
            obj.normals = [0,0,1; 0,0,1; 0,0,1];
            obj.verts1 = obj.vertices(obj.indices(:,1),:);
            obj.verts2 = obj.vertices(obj.indices(:,2),:);
            obj.verts3 = obj.vertices(obj.indices(:,3),:);
        end
        
        function createSphere(obj)
            phiRes = 16;
            thetaRes = 16;
            radius = 1;
            
            nbrVert = phiRes * thetaRes;
            obj.vertices = zeros(nbrVert,3);
            obj.colors = rand(nbrVert,3);
            obj.colors((end-phiRes+1):end, :) = obj.colors(1:phiRes,:);
            obj.normals = zeros(nbrVert,3);
            
            theta = 0.0;
            dTheta = 2*pi/(thetaRes - 1);
            phi = 0.0;
            dPhi = pi/(phiRes - 1);
            
            % create vertices and normals
            index = 1;
            for i=1:thetaRes
                cos_theta = cos(theta);
                sin_theta = sin(theta);
                
                phi = 0.0;
                for j=1:phiRes
                    cos_phi = cos(phi);
                    sin_phi = sin(phi);
                    
                    obj.vertices(index,:) = [radius * sin_theta * sin_phi,...
                                                        -radius * cos_phi,...
                                            radius * cos_theta * sin_phi];
                                        
                    obj.normals(index,:) = [sin_theta*sin_phi,...
                                            -cos_phi,...
                                            cos_theta*sin_phi]/(radius*radius);

                    phi = phi + dPhi;
                    index = index + 1;
                end
            theta = theta + dTheta;
            end
                        
            % create indices
            index = 1;
            for i=0:(thetaRes-2)
               for j=0:(phiRes-2)
                   obj.indices(index,:) = [phiRes*i + j,...
                                           phiRes*i + j + 1 + phiRes,...
                                           phiRes*i + j + 1] + 1;
                   index = index + 1;
                   obj.indices(index,:) = [phiRes*i + j,...
                                           phiRes*i + j + phiRes...
                                           phiRes*i + j + phiRes + 1] + 1;
                   index = index + 1;
               end
            end
            
            % add transform
            obj.vertices = obj.vertices + [0,0, -2];
            
            obj.verts1 = obj.vertices(obj.indices(:,1),:);
            obj.verts2 = obj.vertices(obj.indices(:,2),:);
            obj.verts3 = obj.vertices(obj.indices(:,3),:);
            
            obj.colors = obj.normals*0.5 + 0.5;
            
        end
        
        function [depth, u, v] = getAllHits(obj, rayOrigin, rayDirection)
            % Möller–Trumbore algorithm
            % return: [depth t, barycentric u v]
            nbrTri = size(obj.indices,1);
            epsilon = 1e-5;
            depth = nan(nbrTri,1);
            u = 0; v = 0;
            
            edge1 = obj.verts2 - obj.verts1;
            edge2 = obj.verts3 - obj.verts1;
            h = cross(repmat(rayDirection,nbrTri,1), edge2, 2);
            a = sum(edge1.*h, 2);
            angleOK = abs(a) > epsilon;
            if (all(~angleOK))
                return % all tringles are parallel to ray
            end
            a(~angleOK) = nan;
            s = rayOrigin - obj.verts1;
            u = sum(s.*h,2)./a; % 1st barycentric
            q = cross(s, edge1, 2);
            v = sum(rayDirection.*q,2)./a; % 2nd barycentric
            t = sum(edge2.*q,2)./a;
            ok = (angleOK & u >= 0.0 & v >= 0.0 &  (u + v) <= 1.0);
            intersect = (ok & t>=0.0); % index over all triangles that intersect with ray
            depth(intersect) = t(intersect);
            
        end
        
        function missColor = miss(obj, rayDirection)
            t = rayDirection(2)*0.5+ 0.5;
            missColor = (1-t)*[1,1,1] + t*[0.5,0.7, 1.0];
        end
    end
end

