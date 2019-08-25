%Plot the points;
 figure
 i=1;
 
 
 while i<length(xyz0)+1

A=xyz0(i,1:3);
B=xyz1(i,1:3);
pts= [A; B];

plot3(pts(:,1),pts(:,2),pts(:,3));
hold on
i=i+1;
end
hold off
 
i=1
%Rotate all the points
figure
while i<length(xyz0)+1

A=xyz0(i,1:3)*rotmat([0,pi/2,pi/2]);
B=xyz1(i,1:3)*rotmat([0,pi/2,pi/2]);
pts= [A; B];

plot3(pts(:,1),pts(:,2),pts(:,3));
hold on
i=i+1;
end
hold off

% 
 %plot3(pts(:,1),pts(:,2),pts(:,3));
% hold on




%% Fixes Lenghts??
indAwy = treeStructure(:,1) ;

indPar = treeStructure(:,9) ;
 

numAwy = size(treeStructure,1) ;

for kk = 1 : numAwy

    indChi = find( indPar == indAwy(kk) ) ;

    if numel( indChi ) == 2

        xyzNew = mean( [

            xyz1( kk        ,:)

            xyz0( indChi(1) ,:)

            xyz0( indChi(2) ,:)

            ] ) ;

        xyz1(kk,:) = xyzNew ;

        xyz0(indChi(1),:) = xyzNew ;

        xyz0(indChi(2),:) = xyzNew ;

    end

end
% figure
% while i<length(xyz0)+1
% 
% A=xyz0(i,1:3)*rotmat([0,0,3.1/2]);
% B=xyz1(i,1:3)*rotmat([0,0,3.1/2]);
% pts= [A; B];
% 
% plot3(pts(:,1),pts(:,2),pts(:,3));
% hold on
% i=i+1;
% end
% hold off
% 
% figure
%%

 crange = [ 0.0 , 0.2 ] ;
%crange = [ min(Pathprop) , max(Pathprop) ] ;

 %crange = [ 0.0 , 0.0001 ] ;

cmap = cubehelix( 256 , 1.00 , -0.2 , 1.0 , 1.0 , [0.1,0.9] , [0.1,0.9] ) ;
cmap = flipud( cmap ) ;
amap = linspace( 0.1 , 1 , size(cmap,1) ) ;
amap(:) = 1.0 ;
    %gets the colors
[~,colIndex] = histc( ...
    max(crange(1),min(crange(2),.1)) , ...
    linspace(crange(1),crange(2),size(cmap,1)) ) ;
%close all
figure( ...
    'Position' , [ 50 , 50 , 900 , 900 ] , ...
    'Color' , [1,1,1] , ...
    'Colormap' , cmap , ...
    'Visible' , 'off' )
% axes( ...
%     'Position' , [0.00,0.05,0.90,0.90] , ...
%     'XLim' , [min(min(rawpoints(:,[1,4]))),max(max(rawpoints(:,[1,4])))] , ...
%     'YLim' , [min(min(rawpoints(:,[2,5]))),max(max(rawpoints(:,[2,5])))] , ...
%     'ZLim' , [min(min(rawpoints(:,[3,6]))),max(max(rawpoints(:,[3,6])))] , ...
%     'View' , [170,20] , ...
%     'CLim' , crange , ...
%     'DataAspectRatio' , [1,1,1] , ...
%     'NextPlot' , 'add' , ...
%     'Clipping' , 'off' , ...
%     'Visible' , 'off' )
i=1 ;
while i<length(xyz0)
    [X,Y,Z]=cylinder2P(diam(i),24,[xyz0(i,1) xyz0(i,2) xyz0(i,3)], [xyz1(i,1) xyz1(i,2) xyz1(i,3)]);
    FV = surf2patch(X,Y,Z) ;
    patch( FV , ...
        'SpecularStrength' , 0.1 , ...
        'DiffuseStrength' , 0.8 , ...
        'AmbientStrength' , 0.4 , ...
        'EdgeColor' , 'none'  )%,'FaceColor' , cmap( colIndex(i) ,:) , ...        'FaceAlpha' , amap( colIndex(i) ) , ...);
    i=i+1;
end
colorbar()
lighting gouraud
camlight
set( gcf , ...
    'Visible' , 'on' )