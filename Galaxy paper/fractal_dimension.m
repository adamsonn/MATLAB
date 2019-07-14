
function [ D, R2 ] = fractal_dimension( clust_msk, sz )

% get limits
[ i1, i2, i3 ] = ind2sub( sz, find( clust_msk ) ) ;
L = [ min(i1) max(i1) min(i2) max(i2) min(i3) max(i3) ] ;

% resize
if L(6)-L(5) > 512
    clust_mskn = clust_msk( L(1):L(2), L(3):L(4), L(5):L(5)+511 ) ;
else
    clust_mskn = clust_msk( L(1):L(2), L(3):L(4), L(5):L(6) ) ;
end

% boxcount
warning( 'off', 'MATLAB:nargchk:deprecated' )
[ n,r ] = boxcount( logical( clust_mskn ) ) ;
warning( 'on', 'MATLAB:nargchk:deprecated' )

% fit
[ p,R2 ] = lin_reg( log( [ r;n ]' ), 1, 0 ) ;     D = p(1) ;

