SingleBifucprop(5*10^-4,LDP(1,:),4)


SingleBifucprop(.5*10^-4,LDP(10,1)*10^-2,LDP(10,2)*10^-2,LDP(10,3),4)

for i
SingleBifucprop(.5*10^-4,LDP(i,1)*10^-2,LDP(i,2)*10^-2,LDP(i,3),100)


P = [0 SingleBifucprop(5*10^-4,LDP(1,:),4) SingleBifucprop(5*10^-4,LDP(1,:),4) 0 0 0 0 0 0;
    SingleBifucprop(10*10^-4,23*10^-2,.9*10^-2,2,pi/4) 0 (1-SingleBifucprop(10*10^-4,23*10^-2,.9*10^-2,2,pi/4))/2 (1-SingleBifucprop(10*10^-4,23*10^-2,.9*10^-2,2,pi/4))/2 0 0 0 0 0; 
    SingleBifucprop(.5*10*10^-4,23*10^-2,.9*10^-2,2,pi/4) 0 0 0 (1-SingleBifucprop(.5*10*10^-4,23*10^-2,.9*10^-2,2,pi/4))/2 (1-SingleBifucprop(.5*10*10^-4,23*10^-2,.9*10^-2,2,pi/4))/2 0 0 0; 
    SingleBifucprop(.5*10*10^-4,23*10^-2,.9*10^-2,2,pi/4) 0 0 0 0 0 (1-SingleBifucprop(.5*10*10^-4,23*10^-2,.9*10^-2,2,pi/4))/2 (1-SingleBifucprop(.5*10*10^-4,23*10^-2,.9*10^-2,2,pi/4))/2 0;
    SingleBifucprop(.25*10*10^-4,23*10^-2,.9*10^-2,2,pi/8) 0 0 0 0 0 0 0 1-SingleBifucprop(.25*10*10^-4,23*10^-2,.9*10^-2,2,pi/8);
    SingleBifucprop(.25*10*10^-4,23*10^-2,.9*10^-2,2,pi/8) 0 0 0 0 0 0 0 1-SingleBifucprop(.25*10*10^-4,23*10^-2,.9*10^-2,2,pi/8);
    SingleBifucprop(.25*10*10^-4,23*10^-2,.9*10^-2,2,pi/8) 0 0 0 0 0 0 0 1-SingleBifucprop(.25*10*10^-4,23*10^-2,.9*10^-2,2,pi/8);
    SingleBifucprop(.25*10*10^-4,2300*10^-2,.9*10^-2,2,pi/8) 0 0 0 0 0 0 0 1-SingleBifucprop(.25*10*10^-4,23*10^-2,.9*10^-2,2,pi/8);
    0 1 0 0 0 0 0 0 0]
mc = dtmc(P);

stateNames = ["Deposit" "1" "11" "12" "111" "112" "121" "122" "Escape"];
mc.StateNames = stateNames;

figure;
graphplot(mc,'ColorEdges',true);