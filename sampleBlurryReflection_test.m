function sampleBlurryReflection_test()
nbrSamples = 1000;
R = 0.75;
n = [0,0,1];
figure
axis equal
hold on
inDir = [0,-1,-1];
inDir = inDir./norm(inDir);
plot3([0,-inDir(1)], [0,-inDir(2)], [0,-inDir(3)],'g')
outDir = inDir - 2*(inDir * n')*n;
outDir = outDir./norm(outDir);
plot3([0,outDir(1)], [0,outDir(2)], [0,outDir(3)],'b')

outDir2 = zeros(nbrSamples,3);
for i=1:nbrSamples
    
    dir = uniformSphere(R, outDir, n);
    %dir = dir./norm(dir);
    outDir2(i,:) = dir;
    plot3([0,dir(1)], [0,dir(2)], [0,dir(3)],'r')
end

%%
figure
histogram(sum(outDir2.*outDir,2),40, 'FaceColor', 'g')
end

function outDir = uniformSphere(R, refDir, normal)
    point = ones(1,3);
    outDir = zeros(1,3);
    while (norm(point)>1) || (dot(outDir, normal)<0)
        point = rand(1,3)*2 - 1;
        outDir = refDir + R*point;
    end
end