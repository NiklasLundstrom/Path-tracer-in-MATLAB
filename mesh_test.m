%% setup
xres = 128;
yres = 128;
nbrSamples = 5;
pathTracer = PathTracer(xres, yres, 'Sphere', nbrSamples);
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
        rayDirection = [d(1)*aspectRatio, -d(2), -1];
        rayDirection = rayDirection / norm(rayDirection);
        if x == dim(1) && y == dim(2)
            bp = 1;
        end
        [hitPoint, color] = pathTracer.closestHit([0,0,0], rayDirection);
        tempColor = tempColor + color;
        end
        output(y,x,:) = tempColor / nbrSamples;
    end
end
toc;
image(output);