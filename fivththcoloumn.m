i=1;

while i<length(LDP)+1
    test=pathback(i)
    LDP(i,5)=test(length(pathback(i))-1)
    i=i+1;
end