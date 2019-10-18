classdef PathTracer < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        output
        xres
        yres
    end
    
    methods (Access = public)
        function obj = PathTracer(xres, yres)
            %UNTITLED2 Construct an instance of this class
            %   Detailed explanation goes here
            obj.xres = xres;
            obj.yres = yres;
            obj.output = zeros(xres,yres,3, 'single');
        end
        
        function render(obj,app)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.output = rand(obj.xres, obj.yres, 3);
            image(app.UIAxes, obj.output);
        end
        
        function writeOutputToFile(obj)
            time = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
            filename = strcat('output_', time, '.png');
            imwrite(obj.output, filename, 'png');
            disp(strcat('Saved::', filename));
        end
    end
end

