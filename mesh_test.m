%% setup
clc
xres = 100;
yres = 100;
nbrSamples = 2;
pathDepth = 5;
pathTracer = PathTracer(xres, yres, 'Sphere', nbrSamples, pathDepth);
output = zeros(xres,yres,3, 'single');

%% run

tic;
 dim = [xres, yres];
for x = 1:dim(1)
    for y = 1:dim(2)
        tempColor = [0,0,0];
        for samples = 1:nbrSamples
         d = (([x,y]-1 + rand(1,2))./dim)*2 - 1;
        aspectRatio = dim(1)/dim(2);
        ray.direction = [d(1)*aspectRatio, -d(2), -1];
        ray.direction = ray.direction / norm(ray.direction);
        ray.origin = [0,0,0];
        if x == 75 && y == 51
            bp = 1;
        elseif x == 19 && y == 51
            bp=1;
        elseif all(ray.direction > [-0.547, 0, -0.8371]-0.001) && all(ray.direction < [-0.547, 0, -0.8371]+0.001)
            bp=1;
        end
        
        
        color = pathTracer.samplePath(ray, pathDepth);
        tempColor = tempColor + color;
        end
        output(y,x,:) = tempColor / nbrSamples;
    end
end
toc;
%%
image(output);
axis equal