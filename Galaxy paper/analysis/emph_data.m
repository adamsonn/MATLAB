
close all

a = [ ...
    reshape( LAVr', [],1 ) ...           % 1
    reshape( SCr', [],1 ) ...            % 2
    reshape( fLAVr', [],1 )...           % 3
    reshape( fTLVr', [],1 ) ...          % 4
    reshape( LAV2r', [],1 ) ...          % 5
    reshape( D3dr', [],1 ) ...           % 6
    reshape( LANr', [],1 ) ...           % 8 switched
    reshape( Dfr', [],1 ) ...            % 7 ^^
    reshape( Df2r', [],1 ) ; ...         % 9
    
    reshape( LAVl', [],1 ) ...
    reshape( SCl', [],1 ) ...
    reshape( fLAVl', [],1 ) ...
    reshape( fTLVl', [],1 ) ...
    reshape( LAV2l', [],1 ) ...
    reshape( D3dl', [],1 ) ...
    reshape( LANl', [],1 ) ...
    reshape( Dfl', [],1 ) ...
    reshape( Df2l', [],1 ) ...
    ] ;

x1 = 5:5:45 ;
x2 = 0:0.1:1 ;
x3 = 1e5:5e4:6e5 ;
ind = a(:,2) >0 ;
plot_bool = 0 ;

[ p2,~ ] = lin_reg( [ a(ind,1) a(ind,2) ], 1, plot_bool ) ;
[ p3,~ ] = lin_reg( [ a(ind,1) a(ind,3) ], 1, plot_bool ) ;
[ p4,~ ] = lin_reg( [ a(ind,1) a(ind,4) ], 1, plot_bool ) ;

[ p8,~ ] = lin_reg( [ a(ind,3) a(ind,8) ], 1, plot_bool ) ;
[ p7,~ ] = lin_reg( [ a(:,7) a(:,9) ], 1, plot_bool ) ;

[ pc2,pv2 ] = corrcoef( a(ind,1), a(ind,2) ) ; disp( [ pc2 pv2 ] )
[ pc3,pv3 ] = corrcoef( a(ind,1), a(ind,3) ) ; disp( [ pc3 pv3 ] )
[ pc4,pv4 ] = corrcoef( a(ind,1), a(ind,4) ) ; disp( [ pc4 pv4 ] )

[ pc8,pv8 ] = corrcoef( a(ind,3), a(ind,8) ) ; disp( [ pc8 pv8 ] )
[ pc7,pv7 ] = corrcoef( a(:,7), a(:,9) ) ;     disp( [ pc7 pv7 ] )

y2 = polyval( p2,x1 ) ;
y3 = polyval( p3,x1 ) ;
y4 = polyval( p4,x1 ) ;

y8 = polyval( p8,x2 ) ;
y7 = polyval( p7,x3 ) ;

tits = { 'LAV', 'SCvol', 'fLAV', 'fTLV', 'LAV*', 'D', 'Df', 'LAN', 'Df*' } ;

fn = 'emph_data_new.xls' ;

warning( 'off', 'MATLAB:xlswrite:AddSheet' )
xlswrite( fn, [ tits; num2cell(a) ], 'Sheet1' )
xlswrite( fn, num2cell( [ x1' y2' y3' y4' ] ), 'Vol_Frac_Fit' )
xlswrite( fn, num2cell( [ x2' y8' ] ), 'Df_vs_fLAV' )
xlswrite( fn, num2cell( [ x3' y7' ] ), 'Df2_vs_LAN' )
warning( 'on', 'MATLAB:xlswrite:AddSheet' )




