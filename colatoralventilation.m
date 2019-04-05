i=1;
a=downpath(2);
while i<=length(a)
specificpathres(i)=(LDP(a(i),1)/(LDP(a(i),2)^4));
i=i+1;
end
sum(specificpathres);


i=1;
while i<length(LDP)+1
pathres(i)=(LDP(i,1)/(LDP(i,2)^4));
i=i+1;
end
sum(pathres);

%flow in m/s
i=2;
maxflow=10*10^-4;
treeflow=zeros(1,length(LDP));
treeflow(1)=maxflow;
while i<length(pathres)+1
    if mod(i,2)==0
        mypath=downpath(i);
        neighborpath=downpath(i+1);
        treeflow(i)=treeflow(i/2)*(1-sum(pathres(mypath(:)))/(sum(pathres(mypath(:)))+sum(pathres(neighborpath(:)))));
        i=i+1;
    else
        mypath=downpath(i);
        neighborpath=downpath(i-1);
        treeflow(i)=treeflow((i-1)/2)*(1-sum(pathres(mypath(:)))/(sum(pathres(mypath(:)))+sum(pathres(neighborpath(:)))));
        i=i+1;
    end
end


i=1;

Q=[0.5*10^-5:1*10^-5:10*10^-4];
while i<length(LDP)+1
    propline=(real(SingleBifucprop([0.5*10^-5:1*10^-5:10*10^-4],LDP(i,1)*10^-3,LDP(i,2)*10^-3,LDP(i,3),LDP(i,4))));
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
while i<length(optimalflowlim)+1
    Qmouth(i)=(optimalflowlim(i)/treeflow(i))*maxflow;
    i=i+1;
end



adjmatrix=zeros(length(LDP)+2,length(LDP)+2);
i=1;
while i<length(LDP)+1
    adjmatrix(i,(length(LDP)+1))=abs(real(SingleBifucprop(treeflow(i),LDP(i,1)*10^-3,LDP(i,2)*10^-3,LDP(i,3),100)));
    if i<(length(LDP)+1)/2
        adjmatrix(i,2*i)=abs(real((1-(SingleBifucprop(treeflow(i),LDP(i,1)*10^-3,LDP(i,2)*10^-3,LDP(i,3),100)))/2));
        adjmatrix(i,2*i+1)=abs(real((1-(SingleBifucprop(treeflow(i),LDP(i,1)*10^-3,LDP(i,2)*10^-3,LDP(i,3),100)))/2));
    else
        adjmatrix(i,(length(LDP)+1))=1-abs(real((1-(SingleBifucprop(treeflow(i),LDP(i,1)*10^-3,LDP(i,2)*10^-3,LDP(i,3),100)))));
        adjmatrix(i,(length(LDP)+2))=abs(real((1-(SingleBifucprop(treeflow(i),LDP(i,1)*10^-3,LDP(i,2)*10^-3,LDP(i,3),100)))));
    end
    i=i+1;
    
end

i=1;
rng(5)
while i<240
    a=randi([32 63],1);
    b=randi([32 63],1);
    adjmatrix(a,b)=adjmatrix(a,65)/2;
    adjmatrix(a,64)=adjmatrix(a,64);
    adjmatrix(a,65)=(adjmatrix(a,65)-adjmatrix(a,65)/2);
    i=i+1;
end


adjmatrix((length(LDP)+1),1)=0;
adjmatrix((length(LDP)+1),(length(LDP)+1))=1;
adjmatrix((length(LDP)+2),(length(LDP)+2))=1;
mc = dtmc(adjmatrix);

%stateNames = ["Deposit" "1" "11" "12" "111" "112" "121" "122" "Escape"];
%mc.StateNames = stateNames;

figure;
graphplot(mc,'ColorEdges',true);

rng(2); % For reproducibility
numSteps = 15;
X0 = zeros(mc.NumStates,1);
X0(1) = 10000; % 100 random walks starting from state 1 only
X = simulate(mc,numSteps,'X0',X0);


figure;
simplot(mc,X,'Type','transitions');

figure;
imagesc(mc.adjmatrix);
colormap(jet);
axis square;
colorbar;

figure;
eVals = eigplot(mc);

[bins,~,ClassRecurrence] = classify(mc);
recurrentClass = find(ClassRecurrence,1) ;

recurrentState = find((bins == recurrentClass));

sc = subchain(mc,recurrentState);

%figure;
%graphplot(sc,'ColorNodes',true);

%avg path length for simulation
i=1;

a=zeros(1,length(X));
while i<=length(X)
    
    a(i)=length(unique(X(:,i)== 16385))-1;
    i=i+1;
end

mean(a)

sum(a(:) == 6)/10000



