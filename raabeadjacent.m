%ab=SingleBifucprop(.5^max(ceil(log10(abs(LDP(467,4)))),1)*10^-4,LDP(19,1)*10^-2,LDP(19,2)*10^-2,LDP(19,3),100);
%real(ab)
%SingleBifucprop(.5*10^-4,LDP(10,1)*10^-2,LDP(10,2)*10^-2,LDP(10,3),100)
adjmatrix=zeros(length(LDP)+1,length(LDP)+1);
i=1;
Q=maxflow/8;
while i<length(LDP)+1
    adjmatrix(i,(length(LDP)+1))=SingleBifucprop(Q*.5^max(ceil(log10(abs(LDP(i,4))))),LDP(i,1)*10^-3,LDP(i,2)*10^-3,LDP(i,3),100);
    if i<(length(LDP)+1)/2
        adjmatrix(i,2*i)=(1-(SingleBifucprop(Q*.5^max(ceil(log10(abs(LDP(i,4))))),LDP(i,1)*10^-3,LDP(i,2)*10^-3,LDP(i,3),100)))/2;
        adjmatrix(i,2*i+1)=(1-(SingleBifucprop(Q*.5^max(ceil(log10(abs(LDP(i,4))))),LDP(i,1)*10^-3,LDP(i,2)*10^-3,LDP(i,3),100)))/2;
    else
        adjmatrix(i,(length(LDP)+1))=1;
    end
    i=i+1;
    
end
adjmatrix((length(LDP)+1),1)=0;
adjmatrix((length(LDP)+1),(length(LDP)+1))=1;
mc = dtmc(adjmatrix);

stateNames = ["Deposit" "1" "11" "12" "111" "112" "121" "122" "Escape"];
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

%figure;
%imagesc(mc.adjmatrix);
%colormap(jet);
%axis square;
%colorbar;

figure;
eVals = eigplot(mc)

[bins,~,ClassRecurrence] = classify(mc);
recurrentClass = find(ClassRecurrence,1) ;

recurrentState = find((bins == recurrentClass));

sc = subchain(mc,recurrentState);

figure;
graphplot(sc,'ColorNodes',true);

%avg path length for simulation
i=1;
y=[1:15];

c=zeros(1,length(X));
while i<=length(X)
    
    c(i)=length(unique(X(:,i)))-1;
    i=i+1;
end

mean(c)

sum(c(:) == 6)/10000
