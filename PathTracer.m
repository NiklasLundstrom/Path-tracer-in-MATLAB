classdef PathTracer < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        output
        xres
        yres
        scene
        nbrSamples
        pathDepth
    end
    
    methods (Access = public)
        function obj = PathTracer(xres, yres, sceneName, nbrSamples, pathDepth)
            %UNTITLED2 Construct an instance of this class
            %   Detailed explanation goes here
            obj.xres = xres;
            obj.yres = yres;
            obj.output = zeros(xres,yres,3, 'single');
            obj.scene = scene(sceneName);
            obj.nbrSamples = nbrSamples;
            obj.pathDepth = pathDepth;
        end
        
        function renderTime = render(obj,app)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            tic;
            
            dim = [obj.xres, obj.yres];
            for x = 1:dim(1)
                for y = 1:dim(2)
                    tempColor = [0,0,0];
                    for sample = 1:obj.nbrSamples
                        d = (([x,y]-1 + rand(1,2))./dim)*2 - 1;
                        aspectRatio = dim(1)/dim(2);
                        ray.direction = normalize([d(1)*aspectRatio, -d(2), -1], 'norm');
                        ray.origin = [0,0,0];
                        color = obj.samplePath(ray, obj.pathDepth);                        
                        tempColor = tempColor + color;
                    end
                    obj.output(y,x,:) = obj.gammaCorrect( tempColor / obj.nbrSamples );
                end
            end
            
            renderTime = toc;
            image(app.UIAxes, obj.output);
        end
        
        function writeOutputToFile(obj)
            time = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
            filename = strcat('output\output_', time, '.png');
            imwrite(obj.output, filename, 'png');
            disp(strcat('Saved::', filename));
        end
        
        function color = samplePath(obj, ray, pathDepth)
            if pathDepth <= 0
                color = [0,0,0];
                return
            else
                [hitPoint, hitMaterial, hitNormal] = obj.closestHit(ray.origin, ray.direction);
                if hitPoint(1)==Inf
                    % miss
                    color = hitMaterial;
                    return
                else
                    % hit
                    hitInfo.normal = hitNormal;
                    [continuePath, outDir, attenuation] = hitMaterial.scatter(ray.direction, hitInfo);
                    if ~continuePath
                        color = attenuation;
                        return                        
                    else
                        ray.origin = hitPoint;
                        ray.direction = outDir./norm(outDir);
                        color = attenuation .* obj.samplePath(ray, pathDepth-1);
                    end
                end
            end
        end 
    end
    
    methods (Access = private)
        
        function [hitPoint, hitMaterial, hitNormal] = closestHit(obj, rayOrigin, rayDirection)
            hitPoint = [Inf, Inf, Inf];
            hitNormal = [0,0,0];
            [t, u, v, meshIdx, triIdx] = getAllHits(obj, rayOrigin, rayDirection);
            
            if all(isnan(t)) % no hits
                hitMaterial = miss(obj, rayDirection);
                return
            end
            % get closest hit
            [t_min, hitIdx] = min(t);
            hitMesh = obj.scene.meshes(meshIdx(hitIdx));
            hitPoint = rayOrigin + rayDirection * t_min;
            hitMaterial = hitMesh.material;
            triNormals = hitMesh.normals(hitMesh.indices(triIdx(hitIdx),:),:);
            hitNormal  = triNormals(1,:) * (1 - u(hitIdx) - v(hitIdx))...
                        + triNormals(2,:) * u(hitIdx)...
                        + triNormals(3,:) * v(hitIdx);
            hitNormal = hitNormal./norm(hitNormal);
        end 
        
        function [outDepth, outU, outV, outMeshIdx, outTriIdx] = getAllHits(obj, rayOrigin, rayDirection)
            % Möller–Trumbore algorithm
            % return: [depth t, barycentric u v, mesh index]
            outDepth = [];
            outU = [];
            outV = [];
            outMeshIdx = [];
            outTriIdx = [];
            
            meshIdx = 1;
            for m = obj.scene.meshes
                nbrTri = size(m.indices,1);
                epsilon = 1e-5;
                %depth = nan(nbrTri,1);
                u = 0; v = 0;
            
                edge1 = m.verts2 - m.verts1;
                edge2 = m.verts3 - m.verts1;
                h = cross(repmat(rayDirection,nbrTri,1), edge2, 2);
                a = sum(edge1.*h, 2);
                angleOK = abs(a) > epsilon;
                if (all(~angleOK))
                    return % all tringles are parallel to ray
                end
                a(~angleOK) = nan;
                s = rayOrigin - m.verts1;
                u = sum(s.*h,2)./a; % 1st barycentric
                q = cross(s, edge1, 2);
                v = sum(rayDirection.*q,2)./a; % 2nd barycentric
                t = sum(edge2.*q,2)./a;
                ok = (angleOK & u >= 0.0 & v >= 0.0 &  (u + v) <= 1.0);
                intersectIdx = (ok & t>=0.0001); % index over all triangles that intersect with ray
                depth = t(intersectIdx);
                
                % add to out vectors
                outDepth = [outDepth; depth];
                outU = [outU; u(intersectIdx)];
                outV = [outV; v(intersectIdx)];
                outMeshIdx = [outMeshIdx; zeros(size(depth)) + meshIdx];
                outTriIdx = [outTriIdx; find(intersectIdx)];
                
                meshIdx = meshIdx + 1;
            end
        end
        
        function missColor = miss(obj, rayDirection)
            t = rayDirection(2)*0.5+ 0.5;
            missColor = (1-t)*[1,1,1] + t*[0.5,0.7, 1.0];
        end
        
        function outColor = gammaCorrect(obj, inColor)
            % gamma 2
            outColor = sqrt(inColor);
        end
        
    end
    
end

