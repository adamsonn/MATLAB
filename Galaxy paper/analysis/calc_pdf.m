
close all
load HU_data.mat

a = [ a(:,1:2) ; a(:,3:4) ; a(:,5:6) ; a(:,7:8) ; a(:,9:10) ] ;

edges = linspace( 0, max( a(:,1) ), 20 ) ;
ind = a(:,2) >0 ;

figure()
subplot( 4,2, [1 2] ) ; stem( a(:,1), logical( a(:,2) ) )
title( 'Super Clusters' )

subplot( 4,2,3 ) ; h1= histogram( a(:,1), edges ) ;
ylim( [ 0 20 ] ) ; xlim( [ min( edges ) max( edges ) ] )
title( 'All pts' )

subplot( 4,2,4 ) ; h2= histogram( a( ind,1 ), edges ) ;
ylim( [ 0 20 ] ) ; xlim( [ min( edges ) max( edges ) ] )
title( 'Pts w/ SC' )

P = [ 0 ( h2.Values ./ h1.Values ) ] ;
P( isnan(P) ) = 0 ;

[ f, gof ] = fit( edges', P', '1- ( 1/( 1 + (x/a)^b ) )', 'StartPoint', [ 20 10 ] ) ;
disp( [ f.a f.b gof.rsquare ] )

yf = 1- ( 1./( 1 + ( edges/f.a ).^f.b ) ) ;

subplot( 4,2,5:8 ) ; hold on
plot( edges, yf, 'r', 'LineWidth', 2 )
stem( edges, P )
title( 'Super Cluster Prevalence' )

% fn = 'prevalence_fit.xls' ;
% if exist( fn, 'file' ) ; delete( fn ) ; end
% xlswrite( fn, num2cell( [ edges' yf' P' ] ) )


xf = linspace( 0, max( a(:,1) ), 100 ) ;
yf = 1- ( 1./( 1 + ( xf/f.a ).^f.b ) ) ;
[~,ind,~] = unique( yf ) ; 
x = interp1( yf( ind ), xf( ind ), [ .10 .90 ] ) ; disp( x )

