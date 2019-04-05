mc = dtmc(P);

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
colormap(jet);
axis square;
colorbar;

figure;
eVals = eigplot(mc);