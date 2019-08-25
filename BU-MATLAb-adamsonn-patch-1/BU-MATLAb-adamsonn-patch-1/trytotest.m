pathbackID=Pathback+1;
i=1;
pathnumber=1;
flowMatrix(:,1)=round(flowMatrix(:,1));
flowMatrix=sscanf(findFlow(1000000000,nodes(1), nodes), '%g,', [2, inf]).';
flowMatrix=sortrows(flowMatrix);
flowMatrix=unique(flowMatrix,'rows');
flowMatrix(:,2)=flowMatrix(:,2)*10^-12;

while pathnumber<length(Pathback)
    while pathbackID(i,pathnumber)>=1
        probpathback(i,pathnumber)=getProbability(nodes(pathbackID(i,pathnumber)),flowMatrix(pathbackID(i,pathnumber),2)/1);
        i=i+1;
    end
    i=1;
    pathnumber=pathnumber+1;
end

pathnumber=1;
i=1;
while pathnumber<length(Pathback)
    probwholepathback(pathnumber)=prod(1-nonzeros(probpathback(:,pathnumber)))*flowMatrix(pathbackID(1,pathnumber),2)*10^3;
    i=1;
    pathnumber=pathnumber+1;
end

sum(probwholepathback)
i=1;
pathnumber=1;
%Redo for optimal flow
while pathnumber<length(Pathback)
    while pathbackID(i,pathnumber)>=1
        probpathback(i,pathnumber)=getProbability(nodes(pathbackID(i,pathnumber)),flowMatrix(pathbackID(i,pathnumber),2)*optiflow(pathbackID(i,pathnumber)));
        i=i+1;
    end
    i=1;
    pathnumber=pathnumber+1;
end

pathnumber=1;
i=1;
while pathnumber<length(Pathback)
    probwholepathback(pathnumber)=prod(1-nonzeros(probpathback(:,pathnumber)))*(optiflow(pathbackID(1,pathnumber))*(flowMatrix(pathbackID(1,pathnumber),2)))/((optiflow(pathbackID(1,pathnumber))*(flowMatrix(1,2))));
    i=1;
    pathnumber=pathnumber+1;
end


sum(probwholepathback)


% % Finding optimal probability Vectors
% for i=1:length(nodes)
%     Maxprob(i)=getProbability(nodes(i),flowMatrix(i,2));
%     Optiprob(i)=getProbability(nodes(i),optiflow(i));
% end
b=1;    
for i=1:length(nodes)
    c=nodes(i).Index;
    while nodes(c).Diameter~=nodes(1).Diameter
        b=b+1;
        c=nodes(c).Parent.Index;
    end
    Generation(i)=b;
    b=1;
end
        
optiflowgen(5,:)=optiflow; %of max flow at generation
optiflowgen(2,:)=Generation;%Generation Number

%Getting the volumes
for i=1:length(nodes)
    optiflowgen(1,i)=(optiflow(i)*(flowMatrix(i,2)));%Actual flow rate at generation
    optiflowgen(3,i)=nodes(i).Length*10^-2*pi*(((nodes(i).Diameter*10^-2))/2)^2; %volumes
    optiflowgen(4,i)=optiflowgen(3,i)/ optiflowgen(1,i); %time to transverse
   
end

%Just mouth Flows
mouthflowgen(2,:)=optiflow; %of max flow at generation
mouthflowgen(1,:)=Generation;%Generation Number
mouthflowgen(3,:)=optiflowgen(4,:);%
mouthflowgen(4,:)=diam;
Lengths(5,:)=nodes(:).Length;
mouthflowgen(6,:)=flowMatrix(:,2);
sortedmouth=sortrows(mouthflowgen');

%average
 for i=1:length(nodes)
 avgoptgen(i)=(sortedmouth(:,1)==i)'*sortedmouth(:,2)/(length(nonzeros((sortedmouth(:,1)==i))));
 avgtime(i)=(sortedmouth(:,1)==i)'*sortedmouth(:,3)/(length(nonzeros((sortedmouth(:,1)==i))));
 end


for i=1:length(nonzeros(unique(Generation)))
genon(:,i)=(sortedmouth(:,1)==i);
end

gennumber=1
for gennumber=1:length(nonzeros(unique(Generation)))
    for i=1:length(genon)
    times(i,gennumber)=genon(i,gennumber)*sortedmouth(i,3);
    flowrates(i,gennumber)=genon(i,gennumber)*sortedmouth(i,2);
    i=i+1;
    end
    gennumber=gennumber+1;
    i=1;
end

for i=1:length(nonzeros(unique(Generation)))
    medianflow(i)=median(nonzeros(flowrates(:,i)));
    mediantime(i)=median(nonzeros(times(:,i)));
end

figure
plot(avgoptgen)
xlabel('Generation Number')
ylabel('Flow Rate L/s') 

figure
syms t
y= piecewise(0<t<avgtime(1),avgoptgen(1),avgtime(1)<t<avgtime(1)+avgtime(2),avgoptgen(2),sum(avgtime(1:2))<t<sum(avgtime(1:3)),avgoptgen(3),sum(avgtime(1:3))<t<sum(avgtime(1:4)),avgoptgen(4),sum(avgtime(1:4))<t<sum(avgtime(1:5)),avgoptgen(5),sum(avgtime(1:5))<t<sum(avgtime(1:6)),avgoptgen(6),sum(avgtime(1:6))<t<sum(avgtime(1:7)),avgoptgen(7),sum(avgtime(1:7))<t<sum(avgtime(1:8)),avgoptgen(8),sum(avgtime(1:8))<t<sum(avgtime(1:9)),avgoptgen(9),sum(avgtime(1:9))<t<sum(avgtime(1:10)),avgoptgen(10),sum(avgtime(1:10))<t<sum(avgtime(1:11)),avgoptgen(11),sum(avgtime(1:11))<t<sum(avgtime(1:12)),avgoptgen(12),sum(avgtime(1:12))<t<sum(avgtime(1:13)),avgoptgen(13),sum(avgtime(1:13))<t<sum(avgtime(1:14)),avgoptgen(14),sum(avgtime(1:14))<t<sum(avgtime(1:15)),avgoptgen(15));
fplot(y,[0,5])

figure

plot(medianflow)
xlabel('Generation Number')
ylabel('Median Flow Rate L/s') 








