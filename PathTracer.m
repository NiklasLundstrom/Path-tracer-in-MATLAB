classdef PathTracer < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        output
        xres
        yres
        mesh
    end
    
    methods (Access = public)
        function obj = PathTracer(xres, yres, meshName)
            %UNTITLED2 Construct an instance of this class
            %   Detailed explanation goes here
            obj.xres = xres;
            obj.yres = yres;
            obj.output = zeros(xres,yres,3, 'single');
            obj.mesh = mesh(meshName);
        end
        
        function renderTime = render(obj,app)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            tic;
            
            for x = 1:obj.xres
                for y = 1:obj.yres
                    d = (([x,y] - 0.5)./[obj.xres, obj.yres])*2 - 1;
                    aspectRatio = obj.xres/obj.yres;
                    rayDirection = normalize([d(1)*aspectRatio, -d(2), -1], 'norm');
                    [hitPoint, color] = obj.mesh.closestHit([0,0,0], rayDirection);
                    obj.output(y,x,:) = color;
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
    end
end

