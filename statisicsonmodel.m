i=1;


mean(a)

sum(a(:) == 6)/10000

i=1;


mean(b)

sum(b(:) == 6)/10000



figure
histogram(a,6,'BinWidth',1)
ylabel('Count')
xticks([1.5 2.5 3.5 4.5 5.5 6.5])
title('optimal flow 10000 simulations Asymmetric Geometry')
dim = [.2 .5 .3 .3];
str = '%escape=97.85 mean transitions=5.9462';
annotation('textbox',dim,'String',str,'FitBoxToText','on')

xticklabels({'generation 1','generation 2', 'generation 3', 'generation 4','Escape'})

figure 
histogram(b,6,'BinWidth',1)
ylabel('Count')
xticks([1.5 2.5 3.5 4.5 5.5 6.5])
title('Maxflow 10000 simulations Asymmetric Geometry')
xticklabels({'generation 1','generation 2', 'generation 3', 'generation 4','Escape'})
dim = [.2 .5 .3 .3];
str = '%escape=91.57 mean transitions=5.7476';
annotation('textbox',dim,'String',str,'FitBoxToText','on')



figure
plot(Qmouth*10^3)
ylabel('Flowrate L/s')


figure
hold on
i=1;
d=zeros(32,6);
while i<32
    d(i,:)=Qmouth(pathback(64-i));
    plot(Qmouth(pathback(64-i)))
    i=i+1;
end
hold off
