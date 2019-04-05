i=1;
% % a=downpath(3);
% % while i<=length(a)
% % specificpathres(i)=(LDP(a(i),1)/(LDP(a(i),2)^4));
% % i=i+1;
% % end
% % sum(specificpathres);


i=1;
%Calculates pathway resistence for each segment
while i<length(LDP)+1
pathres(i)=(LDP(i,1)/(LDP(i,2)^4));
i=i+1;
end
sum(pathres);

%largeass(1,6) = -1 ;

g=1;
pathb=zeros(length(LDP),length(LDP));
while g<length(LDP)+1
    i=g;
    b=1;
    while i>0
        pathb(b,largeass(:,1)==g)=i;
        b=b+1;
        i=largeass( largeass(:,1)==i ,6);
    end
    pathb(b,largeass(:,1)==g)=0;
    g=g+1;
end

%calculates downpath for this set
sort(unique(pathb(:,3)));

%flow in m/s
i=2;
maxflow=20*10^-4;
treeflow=zeros(1,length(LDP));
treeflow(1)=maxflow;
treeflow(2)=maxflow;
while i<length(pathres)+1
    if i<4396;
        i_sister = (sister ~= 1)'*sister ;
        mypath=find(sort(unique(pathb(:,i))));
        
        sister = setdiff( largeass( largeass(:,6)==pathb(2,i) ,1) , pathb(1,i) ) ;
        i_sister = (sister ~= 1)'*sister ;
        
        neighborpath=find(sort(unique(pathb(:,i_sister))));
        treeflow(i)=treeflow(largeass(i-1,6))*(1-sum(pathres(mypath(:)))/(sum(pathres(mypath(:)))+sum(pathres(neighborpath(:)))))+.0000001;
        i=i+1;

    else
        neighborpath=(find(sort(unique(pathb(:,400)))));
        treeflow(i)=treeflow(i-3)*(1-sum(pathres(mypath(:)))/(sum(pathres(mypath(:)))+sum(pathres(neighborpath(:)))))+.0000001;
        i=i+1;
        

    end
end

i=2;

Q=[1*10^-5:1*10^-5:20*10^-4];
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
while i<length(optimalflowlim)+1
    Qmouth(i)=(optimalflowlim(i)/treeflow(i))*maxflow;
    i=i+1;
end


daugherpath=(pathb(1:2,:));



adjmatrix=zeros(length(LDP)+1,length(LDP)+1);
i=2;
while i<length(LDP)-1
    adjmatrix(i,(length(LDP)+1))=abs(real(SingleBifucprop(optimalflowlim(i-1),LDP(i,1)*10^-3,LDP(i,2)*10^-3,LDP(i,3),100)));

    if sum(daugherpath(1,find(daugherpath(2,:)==i)))>0
        daughters=daugherpath(1,find(daugherpath(2,:)==i));
        
        adjmatrix(i,daughters(1))=abs(real((1-(SingleBifucprop(optimalflowlim(daughters(1)),LDP(i,1)*10^-3,LDP(i,2)*10^-3,LDP(i,3),100)))/2));
        adjmatrix(i,daughters(2))=abs(real((1-(SingleBifucprop(optimalflowlim(daughters(2)),LDP(i,1)*10^-3,LDP(i,2)*10^-3,LDP(i,3),100)))/2));
    else

        adjmatrix(i,(length(LDP)+1))=1;
    end
    i=i+1;
    
end
adjmatrix(1,2)=1;
adjmatrix(length(LDP)-1,(length(LDP)+1))=1;
adjmatrix(1,(length(LDP)+1))=0;
adjmatrix((length(LDP)+1),1)=0;
adjmatrix((length(LDP)+1),(length(LDP)+1))=1;
mc = dtmc(adjmatrix);
% 
% stateNames = ["Deposit" "1" "11" "12" "111" "112" "121" "122" "Escape"];
% %mc.StateNames = stateNames;
% % 
% % figure;
% graphplot(mc,'ColorEdges',true);

rng(2); % For reproducibility
numSteps = 15;
X0 = zeros(mc.NumStates,1);
X0(1) = 10000; % 100 random walks starting from state 1 only
X = simulate(mc,numSteps,'X0',X0);
% 
% 
% figure;
% simplot(mc,X,'Type','transitions');
% 
% %figure;
% %imagesc(mc.adjmatrix);
% colormap(jet);
% axis square;
% %colorbar;
% 
% figure;
% %eVals = eigplot(mc);
% 
% [bins,~,ClassRecurrence] = classify(mc);
% recurrentClass = find(ClassRecurrence,1) ;
% 
% recurrentState = find((bins == recurrentClass));
% 
% sc = subchain(mc,recurrentState);
% 
% %figure;
% %graphplot(sc,'ColorNodes',true);
% %avg path length for simulation
i=1;
% %y=[1:15];
% 
a=zeros(1,length(X));
while i<=length(X)
    
    a(i)=length(unique(X(:,i)))-1;
    i=i+1;
end

mean(a)

sum(a(:) == 11)/10000;


% % % adjmatrix=zeros(length(LDP)+1,length(LDP)+1);
% % % i=2;
% % % while i<length(LDP)-1
% % %     adjmatrix(i,(length(LDP)+1))=abs(real(SingleBifucprop(treeflow(i-1),LDP(i,1)*10^-3,LDP(i,2)*10^-3,LDP(i,3),100)));
% % % 
% % %     if sum(daugherpath(1,find(daugherpath(2,:)==i)))>0
% % %         daughters=daugherpath(1,find(daugherpath(2,:)==i));
% % %         
% % %         adjmatrix(i,daughters(1))=abs(real((1-(SingleBifucprop(treeflow(daughters(1)),LDP(i,1)*10^-3,LDP(i,2)*10^-3,LDP(i,3),100)))/2));
% % %         adjmatrix(i,daughters(2))=abs(real((1-(SingleBifucprop(treeflow(daughters(2)),LDP(i,1)*10^-3,LDP(i,2)*10^-3,LDP(i,3),100)))/2));
% % %     else
% % % 
% % %         adjmatrix(i,(length(LDP)+1))=1;
% % %     end
% % %     i=i+1;
% % %     
% % % end
% % % adjmatrix(1,2)=1;
% % % adjmatrix(length(LDP)-1,(length(LDP)+1))=1;
% % % adjmatrix(1,(length(LDP)+1))=0;
% % % adjmatrix((length(LDP)+1),1)=0;
% % % adjmatrix((length(LDP)+1),(length(LDP)+1))=1;
% % % mc = dtmc(adjmatrix);
% 
% stateNames = ["Deposit" "1" "11" "12" "111" "112" "121" "122" "Escape"];
% %mc.StateNames = stateNames;
% % 
% % figure;
% graphplot(mc,'ColorEdges',true);

% % rng(2); % For reproducibility
% % numSteps = 15;
% % X0 = zeros(mc.NumStates,1);
% % X0(1) = 10000; % 100 random walks starting from state 1 only
% % X = simulate(mc,numSteps,'X0',X0);
% % 
% % i=2;
% % a=zeros(1,length(X));
% % while i<=length(X)
% %     
% %     a(i)=length(unique(X(:,i)))-1;
% %     i=i+1;
% % end
% % 
% % mean(a)
% 
% adjmatrix=zeros(length(LDP)+1,length(LDP)+1);
% i=1;
% while i<length(LDP)+1
%     adjmatrix(i,(length(LDP)+1))=abs(real(SingleBifucprop(treeflow(i),LDP(i,1)*10^-3,LDP(i,2)*10^-3,LDP(i,3),100)));
%     if i<(length(LDP)+1)/2
%         adjmatrix(i,2*i)=abs(real((1-(SingleBifucprop(treeflow(i),LDP(i,1)*10^-3,LDP(i,2)*10^-3,LDP(i,3),100)))/2));
%         adjmatrix(i,2*i+1)=abs(real((1-(SingleBifucprop(treeflow(i),LDP(i,1)*10^-3,LDP(i,2)*10^-3,LDP(i,3),100)))/2));
%     else
%         adjmatrix(i,(length(LDP)+1))=1;
%     end
%     i=i+1;
%     
% end
% adjmatrix((length(LDP)+1),1)=0;
% adjmatrix((length(LDP)+1),(length(LDP)+1))=1;
% mc = dtmc(adjmatrix);
% 
% stateNames = ["Deposit" "1" "11" "12" "111" "112" "121" "122" "Escape"];
% %mc.StateNames = stateNames;
% 
% figure;
% graphplot(mc,'ColorEdges',true);
% 
% rng(2); % For reproducibility
% numSteps = 15;
% X0 = zeros(mc.NumStates,1);
% X0(1) = 10000; % 100 random walks starting from state 1 only
% X = simulate(mc,numSteps,'X0',X0);
% 
% 
% figure;
% simplot(mc,X,'Type','transitions');
% 
% %figure;
% %imagesc(mc.adjmatrix);
% colormap(jet);
% axis square;
% colorbar;
% 
% figure;
% %eVals = eigplot(mc);
% 
% [bins,~,ClassRecurrence] = classify(mc);
% recurrentClass = find(ClassRecurrence,1) ;
% 
% recurrentState = find((bins == recurrentClass));
% 
% sc = subchain(mc,recurrentState);
% 
% %figure;
% %graphplot(sc,'ColorNodes',true);
% %avg path length for simulation
% %i=1;
% %y=[1:15];
% 
% a=zeros(1,length(X));
% while i<=length(X)
%     
%     a(i)=length(unique(X(:,i)))-1;
%     i=i+1;
% end
% 
% mean(a)
% 
% sum(a(:) == 6)/10000


i=2;
gorge=zeros(20,10000);
while i<length(X)
    gorge(1:length(unique(X(:,i))),i)=unique(X(:,i));
    i=i+1;

end
gorge=sort(gorge);
deposition=(gorge(19,:));

tbl=histogram(deposition,4397);
Pathprop=tbl.Values';
Pathprop=Pathprop/sum(Pathprop);