
close all
clearvars
warning( 'off', 'MATLAB:xlswrite:AddSheet' )

svfldr   = 'C:\Users\Suki''s Lab\Desktop\DATA\lung_imaging\lung_structs\' ;
emph_all = { -910, -930, -950, -960, -990 } ;
Npts     = 12 ;

a = zeros( 2*3*Npts, 2*length( emph_all ) ) ;
for ii = 1:length( emph_all )
    srdir = fullfile( svfldr, [ num2str( emph_all{ ii } ) 'HU' ] ) ;
    tmp_a = extract_parameters( srdir ) ;
    a( :,2*ii-1:2*ii ) = tmp_a(:,1:2) ;
end

% reshape
A   = [ a(:,1:2) ; a(:,3:4) ; a(:,5:6) ; a(:,7:8) ; a(:,9:10) ] ;
ind = A(:,2) >0 ;

% fit and plot
[ p,R2 ] = lin_reg( A( ind,: ), 1, 1 ) ; disp( R2 )

% calculate fit
x = 10:5:65 ;
y = polyval( p,x ) ;

% save
fn = 'HU_data.xls' ;
if exist( fn, 'file' ) ; delete( fn ) ; end
xlswrite( fn, num2cell( [ x' y' ] ), 'Sheet1' )
xlswrite( fn, num2cell( a ), 'Sheet2' )
save HU_data.mat a
