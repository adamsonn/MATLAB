

a = [ LAVr  SCr  fLAVr  fTLVr  LAV2r  D3dr  Dfr  LANr  Df2r ; ...
    LAVl  SCl  fLAVl  fTLVl  LAV2l  D3dl  Dfl  LANl  Df2l ] ;

ind = a(:,2) > 0 ;
b   = a( ind,: ) ;


tits = { 'LAV', 'SCvol', 'fLAV', 'fTLV', 'LAV*', 'D', 'Df', 'LAN', 'Df*' } ;
c    = [ mean( b(:,1:7) ) mean( a(:,8:9) ) ; std( b(:,1:7) )/sqrt( size(b,1) ) std( a(:,8:9) )/sqrt( size(a,1) ) ]  ;

xlswrite( 'ctrl_data.xls', [ tits ; num2cell(c) ] )