%% setup
xres = 128;
yres = 128;
m = mesh('Sphere');
output = zeros(xres,yres,3, 'single');

%% run

tic;
 dim = [xres, yres];
for x = 1:dim(1)
    for y = 1:dim(2)
        d = (([x,y] - 0.5)./dim)*2 - 1;
        aspectRatio = dim(1)/dim(2);
        rayDirection = [d(1)*aspectRatio, -d(2), -1];
        rayDirection = rayDirection / norm(rayDirection);
        [hitPoint, color] = m.closestHit([0,0,0], rayDirection);
        output(y,x,:) = color;
    end
end
toc;
image(output);