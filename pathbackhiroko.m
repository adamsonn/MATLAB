
load rawpointsFix
rawpoints = rawpointsFix ;

smallas(1,6) = -1 ;

g=0;
pathb=zeros(length(rawpoints),length(rawpoints));
while g<length(rawpoints)+1
    i=g;
    b=1;
    while i>0
        pathb(b,smallas(:,1)==g)=i;
        b=b+1;
        i=smallas( smallas(:,1)==i ,6);
    end
    pathb(b,smallas(:,1)==g)=0;
    g=g+1;
end

i=1;
Pathprop=zeros(1,length(rawpoints));
while i<length(rawpoints)
temppath=nonzeros(pathb(:,i));
Pathprop(i)=1-prod(1-smallas(nonzeros(pathb(:,i)),5));
i=i+1;
end

Pathprop=Pathprop';

i=1;
while i<length(rawpoints)+1

A=rawpointsFix(i,1:3);
B=rawpointsFix(i,4:6);
pts= [A; B];

plot3(pts(:,1),pts(:,2),pts(:,3));
hold on
i=i+1;
end

%%
cmap = parula(100) ;
cmap = cubehelix( 256 , 1.00 , -0.2 , 1.0 , 1.0 , [0.1,0.9] , [0.1,0.9] ) ;
[~,colIndex] = histc( Pathprop , linspace(0,1,size(cmap,1)) ) ;
figure( ...
    'Position' , [ 50 , 50 , 900 , 900 ] , ...
    'Color' , [1,1,1] , ...
    'Colormap' , cmap )
axes( ...
    'Position' , [0.00,0.05,0.90,0.90] , ...
    'View' , [170,20] , ...
    'DataAspectRatio' , [1,1,1] , ...
    'NextPlot' , 'add' , ...
    'Clipping' , 'off' , ...
    'Visible' , 'off' )
i=1 ;
while i<length(rawpoints)
    [X,Y,Z]=cylinder2P(rawpoints(i,7),15,[rawpoints(i,1) rawpoints(i,2) rawpoints(i,3)], [rawpoints(i,4) rawpoints(i,5) rawpoints(i,6)]);
    FV = surf2patch(X,Y,Z) ;
    patch( FV , ...
        'SpecularStrength' , 0.1 , ...
        'DiffuseStrength' , 0.8 , ...
        'AmbientStrength' , 0.4 , ...
        'FaceColor' , cmap( colIndex(i) ,:) , ...
        'FaceAlpha' , 1 , ...
        'EdgeColor' , 'none' );
    i=i+1;
end
zoom(1.3)
colorbar()
lighting gouraud
camlight


