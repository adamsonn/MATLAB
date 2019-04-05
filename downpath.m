function [path] = downpath(n)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

path(1)=n;
i=1;
while 2*n+1<437
path(2*i)=2*n;
path(2*i+1)=2*n+1;
n=path(i+1);
i=i+1;

end


end

