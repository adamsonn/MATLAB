powerorder=0;
total=0;
generationname=99;
i=1;
while generationname>1
    path(i)=generationname;
    generationname=(generationname-mod(generationname,2))/2;
    
    i=i+1;
end

path=flip([path,1]);

