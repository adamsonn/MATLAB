%load rawpointfixerlarge
rawpoints = rawpointsFix ;
Largeassgraph(1,6) = -1 ;

g=0;
pathb=zeros(length(rawpoints),length(rawpoints));
while g<length(rawpoints)+1
    i=g;
    b=1;
    while i>0
        pathb(b,Largeassgraph(:,1)==g)=i;
        b=b+1;
        i=Largeassgraph( Largeassgraph(:,1)==i ,6);
    end
    pathb(b,Largeassgraph(:,1)==g)=0;
    g=g+1;
end

i=1;
Pathprop=zeros(1,length(rawpoints));
 while i<length(rawpoints)
 temppath=nonzeros(pathb(:,i));
 Pathprop(i)=1-prod(1-Largeassgraph(nonzeros(pathb(:,i)),5));
 i=i+1;
 end
 
 %Pathprop=Pathprop;
 
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

% crange = [ 0.0 , 0.2 ] ;
crange = [ min(Pathprop) , max(Pathprop) ] ;

cmap = cubehelix( 256 , 1.00 , -0.2 , 1.0 , 1.0 , [0.1,0.9] , [0.1,0.9] ) ;
cmap = flipud( cmap ) ;
amap = linspace( 0.1 , 1 , size(cmap,1) ) ;

[~,colIndex] = histc( ...
    max(crange(1),min(crange(2),Pathprop)) , ...
    linspace(crange(1),crange(2),size(cmap,1)) ) ;
close all
figure( ...
    'Position' , [ 50 , 50 , 900 , 900 ] , ...
    'Color' , [1,1,1] , ...
    'Colormap' , cmap , ...
    'Visible' , 'off' )
axes( ...
    'Position' , [0.00,0.05,0.90,0.90] , ...
    'XLim' , [min(min(rawpoints(:,[1,4]))),max(max(rawpoints(:,[1,4])))] , ...
    'YLim' , [min(min(rawpoints(:,[2,5]))),max(max(rawpoints(:,[2,5])))] , ...
    'ZLim' , [min(min(rawpoints(:,[3,6]))),max(max(rawpoints(:,[3,6])))] , ...
    'View' , [170,20] , ...
    'CLim' , crange , ...
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
        'FaceAlpha' , amap( colIndex(i) ) , ...
        'EdgeColor' , 'none' );
    i=i+1;
end
colorbar()
lighting gouraud
camlight
set( gcf , ...
    'Visible' , 'on' )

