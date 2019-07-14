
close all


%-- UNPACK lung structure
sz    = lungs.sz ;                  % 3D lung size
pntr  = lungs.pntr ;                % [ ind  HUct  L/R  emph?  clust#  sc# ]
th    = 1e-6 ;
nbins = 30 ;


%-- REBUILD in 3D
figure(1) ; set( gcf, 'Position', [ 850   263   690   690 ] )
for nn = 1:2
    
    ind1 = pntr( pntr(:,3) ==nn, 1 ) ;                      % normal tissue
    ind2 = pntr( and( pntr(:,3) ==nn, pntr(:,4) ), 1 ) ;    % emphysema
    msk2 = zeros( sz ) ;    msk2( ind2 ) = 1 ;
    
    msk3 = imgaussfilt3( msk2, 'FilterSize', 5 ) ;
    msk3 = msk3.*~msk2 ;
    msk3 = msk3( ind1 ) ;
    msk3 = msk3( msk3 >th );
    
    bins = logspace( log10(th), 0, nbins+1 ) ;
    h3   = histc( msk3, bins ) ;
    bins = bins( h3 >0 )' ;
    h3   = h3( h3 >0 ) ;
    h3   = flipud( cumsum(h3) ) ;
    
    figure(1) ; subplot( 2,1,nn ) ;
    plot( log10( bins ), log10( h3 ), 'o' )
    [ p,R2 ] = lin_reg( log10( [ bins(3:end) h3(3:end) ] ), 1, 1 )
end


