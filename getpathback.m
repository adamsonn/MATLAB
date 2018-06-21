function [pathback1] = getpathback(generationname)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
powerorder=0
total=0;
i=1;
while total<generationname
    total=2^i;
    i+1
end

i
    
    
i=1;
while i<generationname
    if mod(generationame(i),2)==1
        pathback(i) = (generationname(i)-1)/2;
    else
        pathback(i) = generationname/2;
end
end
