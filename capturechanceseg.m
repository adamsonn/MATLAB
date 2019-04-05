Q=[1*10^-8:1*10^-8:20*10^-4];
while i<length(LDP)+1
    propline=(real(SingleBifucprop([0.5*10^-5:1*10^-5:20*10^-4],LDP(i,1)*10^-3,LDP(i,2)*10^-3,LDP(i,3),LDP(i,4))));
    [chance,index]=min(propline);
    optimalflow(i)=Q(index);
    i=i+1;
end

i=1;
while i<length(optimalflow)+1
    if optimalflow(i)>=treeflow(i)
        optimalflowlim(i)=treeflow(i);
        else optimalflowlim(i)=optimalflow(i);
    end
    i=i+1;
   
end

i=1;
while i<length(LDP)+1
    capturechancesegm(i,(1))=real(abs(real(SingleBifucprop(optimalflowlim(i),LDP(i,1)*10^-3,LDP(i,2)*10^-3,LDP(i,3),100))));

    i=i+1;
    
end