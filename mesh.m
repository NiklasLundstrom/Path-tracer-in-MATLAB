classdef mesh < handle
    %mesh Creates buffers for vertices, normals, colors, indices
    %   Right-handed coordinate system!
    
    properties
        vertices
        verts1
        verts2
        verts3
        indices
        colors
        normals
        material material = lambertian([0.5, 0.5, 0.5])
    end
    
    methods (Access = public)
        function obj = mesh(meshName)
            %UNTITLED4 Construct an instance of this class
            %   Detailed explanation goes here            
            if (strcmp(meshName, 'Single Triangle'))
                createSingleTriangle(obj);
            elseif (strcmp(meshName, 'Sphere'))
                createSphere(obj);
            elseif (strcmp(meshName, 'Plane'))
                createPlane(obj);
            else
                error('Invalid mesh name!');
            end
        end
        
    end
    methods (Access = private)
        function createSingleTriangle(obj)
            % create buffers
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
        
        function createPlane(obj)
           % create buffers
           obj.vertices = [ 1,0, 1;...
                            1,0,-1;...
                           -1,0,-1;...
                           -1,0, 1];
           obj.indices = [1,2,3;1,3,4];
           obj.colors = zeros(4,3) + [0.5,0.5,0.5];
           obj.normals = zeros(4,3) + [0,1,0];
           
           % apply transform
           obj.vertices = obj.vertices*3 + [0,-1,-2];
           
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
        
        
    end
end



