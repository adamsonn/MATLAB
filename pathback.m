function [uppath] = pathback(n)
%UNTITLED13 Summary of this function goes here
%   Detailed explanation goes here
uppath(1)=n
i=2;
while n>1
    if mod(n,2)==0
        uppath(i) = n/2;
        n=uppath(i);
        i=i+1;
    else
        uppath(i)= (n-1)/2;
        n=uppath(i);
        i=i+1;

    end

end
uppath=fliplr(uppath);
end