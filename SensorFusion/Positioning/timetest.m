tic
for it=1:100
    sensorpos=[10 10 10;0 5 3;7 5 2];
    ranges=1*randn(3,1);
    toa_positioning2D(sensorpos,ranges,[-10 10]);
    
end
toc