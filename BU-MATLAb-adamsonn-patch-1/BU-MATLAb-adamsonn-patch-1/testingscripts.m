pathbackID=Pathback+1;
i=1;
pathnumber=1;

while pathnumber<length(Pathback)
    while pathbackID(i,pathnumber)>=1
        probpathback(i,pathnumber)=getProbability(nodes(pathbackID(i,pathnumber)),flowMatrix(pathbackID(i,pathnumber),2));
        i=i+1;
    end
    i=1;
    pathnumber=pathnumber+1;
end

    
getProbability(nodes(pathbackID(1,1)),flowMatrix(pathbackID(1,1),2));
