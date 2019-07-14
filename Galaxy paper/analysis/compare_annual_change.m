
close all

x        = -8:2:6 ; % -.6:.1:.6 ;
params   = [ 5 7 ] ;
[ p,R2 ] = lin_reg( a(:,params), 1, 1 ) ;
[ R,Pc ] = corrcoef( a(:,params) ) ; disp( [ R Pc ] )

yfit = polyval( p,x ) ;


fn = 'tmp.xls' ;
if exist( fn, 'file' ) ; delete( fn ) ; end
xlswrite( fn, [ x; yfit ]' ) ;