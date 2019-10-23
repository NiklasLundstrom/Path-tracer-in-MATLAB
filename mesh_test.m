%% setup
xres = 50;
yres = 50;
nbrSamples = 15;
pathDepth = 2;
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
        if x == dim(1)/2 && y == dim(2)/2
            bp = 1;
        end
        
        color = pathTracer.samplePath(ray, pathDepth);
        tempColor = tempColor + color;
        end
        output(y,x,:) = tempColor / nbrSamples;
    end
end
toc;
image(output);