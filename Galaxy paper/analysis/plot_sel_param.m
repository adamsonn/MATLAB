
close all


dVr   = reshape( diff( Vr,1,2 )',[],1 ) ;
Vr2   = 0.5*( Vr( :,1:2 ) + Vr( :,2:3 ) ) ;
pdVr  = dVr ./ reshape( Vr2',[],1 ) ;

dVl   = reshape( diff( Vl,1,2 )',[],1 ) ;
Vl2   = 0.5*( Vl( :,1:2 ) + Vl( :,2:3 ) ) ;
pdVl  = dVl ./ reshape( Vl2',[],1 ) ;

dSCr  = reshape( diff( SCr,1,2 )',[],1 ) ;
SCr2  = 0.5*( SCr( :,1:2 ) + SCr( :,2:3 ) ) ;
pdSCr = dSCr ./ reshape( SCr2',[],1 ) ;

dSCl  = reshape( diff( SCl,1,2 )',[],1 ) ;
SCl2  = 0.5*( SCl( :,1:2 ) + SCl( :,2:3 ) ) ;
pdSCl = dSCl ./ reshape( SCl2',[],1 ) ;



% figure()
% plot( dVr, dSCr, 'bo' ) ; hold on
% plot( dVl, dSCl, 'ro' )

% figure()
% plot( pdVr, pdSCr, 'ko' ) ; hold on
% plot( pdVl, pdSCl, 'ko' )

[ p,R2 ] = lin_reg( [ dVr dSCr; dVl dSCl ], 1, 1 ) ; hold on
plot( [ -.4 .8 ], [ -.4 .8 ], 'b--' )
[ R,P ] = corrcoef( [ dVr ; dVl ], [ dSCr ; dSCl ] )


[ p,R2 ] = lin_reg( [ pdVr pdSCr; pdVl pdSCl ], 1, 1 ) ; hold on
plot( [ -.4 .8 ], [ -.4 .8 ], 'b--' )
[ R,P ] = corrcoef( [ pdVr ; pdVl ], [ pdSCr ; pdSCl ] )

x0 = -20:5:50 ;
p0 = polyfit( [ pdVr ; pdVl ], [ pdSCr ; pdSCl ], 1 ) ;
y0 = polyval( p0, x0 ) ;


LAV2  = [ reshape( LAVr',[],1 ) ; reshape( LAVl',[],1 ) ] ;
SC2   = [ reshape( SCr',[],1 ) ; reshape( SCl',[],1 ) ] ;
fLAV2 = [ reshape( fLAVr',[],1 ) ; reshape( fLAVl',[],1 ) ] ;
fTLV2 = [ reshape( fTLVr',[],1 ) ; reshape( fTLVl',[],1 ) ] ;

figure()
plot( LAV2, SC2, 'ko' ) ; hold on
plot( LAV2, fLAV2, 'ro' )
plot( LAV2, fTLV2, 'bo' )

ind = LAV2 >20 ;

[ R1,P1 ] = corrcoef( LAV2(ind), SC2(ind) ) ;   disp( [ R1 P1 ] )
[ R2,P2 ] = corrcoef( LAV2(ind), fLAV2(ind) ) ; disp( [ R2 P2 ] )
[ R3,P3 ] = corrcoef( LAV2(ind), fTLV2(ind) ) ; disp( [ R3 P3 ] )

x  = 15:5:45 ;
p1 = polyfit( LAV2(ind), SC2(ind), 1 ) ;    y1 = polyval( p1,x ) ;
p2 = polyfit( LAV2(ind), fLAV2(ind), 1 ) ;  y2 = polyval( p2,x ) ;
p3 = polyfit( LAV2(ind), fTLV2(ind), 1 ) ;  y3 = polyval( p3,x ) ;


warning( 'off', 'MATLAB:xlswrite:AddSheet' )
xlswrite( 'tmp.xls', num2cell( 100*[ pdVr pdSCr ; pdVl pdSCl ] ), 'Sheet1' )
xlswrite( 'tmp.xls', num2cell( [ x0' y0' ] ), 'Sheet2' )
xlswrite( 'tmp.xls', num2cell( [ R P ] ), 'Sheet3' )
xlswrite( 'tmp.xls', num2cell( [ LAV2 SC2 fLAV2 fTLV2 ] ), 'Sheet4' )
xlswrite( 'tmp.xls', num2cell( [ x' y1' y2' y3' ] ), 'Sheet5' )
xlswrite( 'tmp.xls', num2cell( [ R1 P1 ; R2 P2 ; R3 P3 ] ), 'Sheet6' )
warning( 'on', 'MATLAB:xlswrite:AddSheet' )


