SingleBifucprop(.5*10^-4,LDP(10,1)*10^-2,LDP(10,2)*10^-2,LDP(10,3),100)
adjmatrix=zeros(476,476);
i=1;
while i<476
    adjmatrix(i,476)=SingleBifucprop(.5^*10^-4,LDP(i,1)*10^-2,LDP(i,2)*10^-2,LDP(i,3),100);
    if i<476/2
        adjmatrix(i,2*i)=(1-SingleBifucprop(.5*10^-4,LDP(i,1)*10^-2,LDP(i,2)*10^-2,LDP(i,3),100))/2;
        adjmatrix(i,2*i+1)=(1-SingleBifucprop(.5*10^-4,LDP(i,1)*10^-2,LDP(i,2)*10^-2,LDP(i,3),100))/2;
    else
        adjmatrix(i,476)=1;
    end
    i=i+1;
    
end
adjmatrix(476,1)=1
mc = dtmc(adjmatrix);

stateNames = ["Deposit" "1" "11" "12" "111" "112" "121" "122" "Escape"];
%mc.StateNames = stateNames;

figure;
graphplot(mc,'ColorEdges',true);

rng(1); % For reproducibility
numSteps = 20;
X0 = zeros(mc.NumStates,1);
X0(1) = 100; % 100 random walks starting from state 1 only
X = simulate(mc,numSteps,'X0',X0);


figure;
simplot(mc,X,'Type','transitions');

figure;
imagesc(mc.adjmatrix);
colormap(jet);
axis square;
colorbar;

figure;
eVals = eigplot(mc)

[bins,~,ClassRecurrence] = classify(mc);
recurrentClass = find(ClassRecurrence,1) 

recurrentState = find((bins == recurrentClass))

sc = subchain(mc,recurrentState);

figure;
graphplot(sc,'ColorNodes',true);