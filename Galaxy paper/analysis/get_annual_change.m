

if ~exist( 'a', 'var' ) ; load( 'yearly_pft_data.mat' ) ; end

tits = { 'FEV1', '%FEV1', 'FVC', '%FVC', '%FEV1/FVC', 'DLCO', 'DLCO/VA' } ;

ind1 = 1:3:size(a,2) ;
ind2 = 2:3:size(a,2) ;
ind3 = 3:3:size(a,2) ;

delta = ( ( a(:,ind2)-a(:,ind1) ) + ( a(:,ind3)-a(:,ind2) ) )/2  ;

stats = zeros( length( ind1 ), 6 ) ;
for ii = 1:size( delta,2 )
    d = delta( :,ii ) ;
    [ h,p ] = ttest( d ) ;
    stats( ii,: ) = [ prctile( d, [ 50 25 75 ] ), h, p, kstest( d ) ] ;
end

disp( [ tits' num2cell( stats ) ] )