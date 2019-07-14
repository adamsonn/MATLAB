
close all

xr = fLAVr ;    xr = reshape( xr', [],1 ) ;   ind1 = xr >0 ;
xl = fLAVl ;    xl = reshape( xl', [],1 ) ;
x  = 0.5*( xr + xl ) ;

yr = Dfr ;      yr = reshape( yr', [],1 ) ;   ind2 = yr >0 ;
yl = Dfl ;      yl = reshape( yl', [],1 ) ;
y  = 0.5*( yr + yl ) ;

% figure() ; set( gcf, 'Position', [ 293  170  1025  364 ] )
% subplot( 1,2,1 ) ; plot( x(ind1), fev1(ind1), 'bo' )
% subplot( 1,2,2 ) ; plot( y(ind2), DLCO_VA(ind2), 'ro' )

lin_reg( [ x(ind1) fev1(ind1) ], 1, 1 ) ;
lin_reg( [ y(ind2) DLCO_VA(ind2) ], 1, 1 ) ;

p1 = polyfit( x(ind1), fev1(ind1), 1 ) ;
p2 = polyfit( y(ind2), DLCO_VA(ind2), 1 ) ;

[ rx,px ] = corrcoef( x(ind1)', fev1(ind1)' ) ;     disp( [ rx px ] )
[ ry,py ] = corrcoef( y(ind2)', DLCO_VA(ind2)' ) ;  disp( [ ry py ] )

fev1_x   = linspace( 0,1,10 )' ;
DLCO_x   = linspace( 2.2,2.6,10 )' ;
fev1_fit = polyval( p1, fev1_x ) ;
DLCO_fit = polyval( p2, DLCO_x ) ;

a = [ x(ind) fev1(ind) y(ind2) DLCO_VA(ind2) ] ;
b = [ fev1_x fev1_fit DLCO_x DLCO_fit ] ;

tits = { 'fLAV','FEV1/FVC','Df','DLCO_VA' } ;

warning( 'off', 'MATLAB:xlswrite:AddSheet' )
xlswrite( 'pft.xls', [ tits ; num2cell(a) ], 'Sheet1' )
xlswrite( 'pft.xls', num2cell(b), 'Sheet2' )
warning( 'on', 'MATLAB:xlswrite:AddSheet' )



