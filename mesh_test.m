%% setup
clc
xres = 25;
yres = 25;
nbrSamples = 10;
pathDepth = 6;
pathTracer = PathTracer(xres, yres, 'Spheres', nbrSamples, pathDepth);
output = zeros(xres,yres,3, 'single');

%% run

tic;
dim = [xres, yres];
tempColor = zeros(dim(1), dim(2), 3, 'single');
for sample = 1:nbrSamples
    for x = 1:dim(1)
        for y = 1:dim(2)
            d = (([x,y]-1 + rand(1,2))./dim)*2 - 1;
            aspectRatio = dim(1)/dim(2);
            ray.direction = [d(1)*aspectRatio, -d(2), -1];
            ray.direction = ray.direction / norm(ray.direction);
            ray.origin = [0,0,0];
            color = pathTracer.samplePath(ray, pathDepth);
            tempColor(y,x,:) = squeeze(tempColor(y,x,:))' + color;
        end
    end
    % output current state of image
    image(tempColor ./ sample);
    title(sample)
    pause(0.01);
end
output = tempColor ./ nbrSamples;
toc;
%%
image(output);
axis equal