


P = [0 1 0 0 0 0 0 0 0;
    SingleBifucprop(10*10^-4,23*10^-2,.9*10^-2,2,pi/4) 0 (1-SingleBifucprop(10*10^-4,23*10^-2,.9*10^-2,2,pi/4))/2 (1-SingleBifucprop(10*10^-4,23*10^-2,.9*10^-2,2,pi/4))/2 0 0 0 0 0; 
    SingleBifucprop(.5*10*10^-4,23*10^-2,.9*10^-2,2,pi/4) 0 0 0 (1-SingleBifucprop(.5*10*10^-4,23*10^-2,.9*10^-2,2,pi/4))/2 (1-SingleBifucprop(.5*10*10^-4,23*10^-2,.9*10^-2,2,pi/4))/2 0 0 0; 
    SingleBifucprop(.5*10*10^-4,23*10^-2,.9*10^-2,2,pi/4) 0 0 0 0 0 (1-SingleBifucprop(.5*10*10^-4,23*10^-2,.9*10^-2,2,pi/4))/2 (1-SingleBifucprop(.5*10*10^-4,23*10^-2,.9*10^-2,2,pi/4))/2 0;
    SingleBifucprop(.25*10*10^-4,23*10^-2,.9*10^-2,2,pi/8) 0 0 0 0 0 0 0 1-SingleBifucprop(.25*10*10^-4,23*10^-2,.9*10^-2,2,pi/8);
    SingleBifucprop(.25*10*10^-4,23*10^-2,.9*10^-2,2,pi/8) 0 0 0 0 0 0 0 1-SingleBifucprop(.25*10*10^-4,23*10^-2,.9*10^-2,2,pi/8);
    SingleBifucprop(.25*10*10^-4,23*10^-2,.9*10^-2,2,pi/8) 0 0 0 0 0 0 0 1-SingleBifucprop(.25*10*10^-4,23*10^-2,.9*10^-2,2,pi/8);
    SingleBifucprop(.25*10*10^-4,23*10^-2,.9*10^-2,2,pi/8) 0 0 0 0 0 0 0 1-SingleBifucprop(.25*10*10^-4,23*10^-2,.9*10^-2,2,pi/8);
    0 1 0 0 0 0 0 0 0]
mc = dtmc(P);

stateNames = ["Deposit" "1" "11" "12" "111" "112" "121" "122" "Escape"];
mc.StateNames = stateNames;

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
imagesc(mc.P);
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