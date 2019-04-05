mypath=downpath(i);
        neighborpath=downpath(i-1);
        treeflow(i)=treeflow((i-1)/2)*(1-sum(pathres(mypath(:)))/(sum(pathres(mypath(:)))+sum(pathres(neighborpath(:)))))