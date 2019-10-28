classdef mesh < handle
    % Creates buffers for vertices, normals, colors, indices
    % Right-handed coordinate system!
    
    properties
        name char
        vertices
        verts1
        verts2
        verts3
        indices
        colors
        normals
        material material = lambertian([0.5, 0.5, 0.5])
        rotation = eye(3)
        scale = ones(1,3)
        translation = zeros(1,3)
    end
    
    methods (Access = public)
        function obj = mesh(meshName, transform)
            %mesh Construct an instance of this class
            obj.name = meshName;
            
            % read transform
            if isfield(transform, 'rotation') 
                obj.rotation = obj.createRotationMatrix(obj, transform.rotation);
            end
            if isfield(transform, 'scale')
                obj.scale = transform.scale;
            end
            if isfield(transform, 'translation')
                obj.translation = transform.translation;
            end
            
            % create buffers
            if (strcmp(meshName, 'Single Triangle'))
                createSingleTriangle(obj);
            elseif (strcmp(meshName, 'Sphere'))
                createSphere(obj);
            elseif (strcmp(meshName, 'Plane'))
                createPlane(obj);
            else
                error('Invalid mesh name!');
            end
            
            % apply transform
           obj.applyTransform();
           
           obj.verts1 = obj.vertices(obj.indices(:,1),:);
           obj.verts2 = obj.vertices(obj.indices(:,2),:);
           obj.verts3 = obj.vertices(obj.indices(:,3),:);
        end
        
    end
    methods (Access = private)
        function createSingleTriangle(obj)
            obj.vertices = [-0.5, 0, 0;...
                             0.5, 0, 0;...
                             0.0, 1, 0];
            obj.indices = [1, 2, 3];
            obj.colors  =  [1, 0, 0;...
                            0, 1, 0;...
                            0, 0, 1];
            obj.normals = [0,0,1; 0,0,1; 0,0,1];
        end
        
        function createPlane(obj)
           obj.vertices = [ 1,0, 1;...
                            1,0,-1;...
                           -1,0,-1;...
                           -1,0, 1];
           obj.indices = [1,2,3;1,3,4];
           obj.colors = zeros(4,3) + [0.5,0.5,0.5];
           obj.normals = zeros(4,3) + [0,1,0];
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
            
            obj.colors = obj.normals*0.5 + 0.5;
        end
        
        %% help functions
        function rotation = createRotationMatrix(obj, rot)
            rotation = rotx(rot(1))' * roty(rot(2))' * rotz(rot(3))';
        end
        
        function applyTransform(obj)
            obj.vertices = obj.vertices*diag(obj.scale)*obj.rotation + obj.translation;
            obj.normals = obj.normals*diag(1./obj.scale)*obj.rotation;
            obj.normals = obj.normals./sqrt(sum(obj.normals.*obj.normals,2));% normalise
        end
    end
end



