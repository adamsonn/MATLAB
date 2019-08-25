a=zeros(1,length(Q));
i=1;
while i<=length(Q)
    a(i)=(SingleBifucprop(Q(i)*.5^max(ceil(log10(abs(LDP(2,4))))),LDP(2,1)*10^-2,LDP(2,2)*10^-2,LDP(2,3),100));
    i=i+1;
end

plot(Q,a)
legend('Totalprob') 
 
xlabel('Flow rate m^3/s') 
ylabel('Probability of Capture') 
  

%i=1;
%y=[1:15];

%a=zeros(1,length(X));
%while i<=length(X)
    
   % a(i)=sum(ismember(X(:,i),y));
   % i=i+1;
%end

%mean(a)