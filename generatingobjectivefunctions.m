clear
load('LDP.mat');

q=0:.0001:.1;
generationname=99;

i=1;

y=objectivefunction(LDP(2,1)*10^-2,LDP(2,2)*10^-2,LDP(2,3),1);

while i<length(LDP(:,1))
   
Volumetube(i)=(pi*LDP(i,1)*10^-2)*(.5*LDP(i,2)*10^-2).^2;
i=i+1;
end

ht= matlabFunction(y);
values=zeros(1,length(q));



i=1

while i<=length(q);
values(i)=ht(q(i));
if values(i)>1
    values(i)=1
end

   
i=i+1;
end

plot(q,values)
i=1;
path=1;
while generationname>1
    path(i)=generationname;
    generationname=(generationname-mod(generationname,2))/2;
    
    
    i=i+1;
end
i
path=flip([path,1]);

i=1;
while i<=length(path)
    cascadeprop(i)=objectivefunction(LDP(path(i),1)*10^-2,LDP(path(i),2)*10^-2,LDP(path(i),3),i);
    pathvolume(i)=Volumetube(path(i));
    i=i+1;
end
bigboy=matlabFunction(prod(cascadeprop))


matA=zeros(length(path),length(path));
i=1;


while i<=length(path)
    matA(i,i)=1;
    b(i)=20*(.5)^(i-1);
    
    Q=sym(['Q',(num2str(i))]);
    veq(i)=pathvolume(i)/Q;
    
    i=i+1;
    
end
matA(length(matA),length(matA))=1;
%b(length(b)+1)=20;
nonlinconst=matlabFunction(sum(veq)-20)
b=b';

x0=[.00001,.00001,.00001,.00001,.00001,.00001,.00001];
lb= [0,0,0,0,0,0,0];
ub =[.5, .5, .5, .5, .5, .5, .5];

a=sum(veq)
k=matlabFunction(a)

