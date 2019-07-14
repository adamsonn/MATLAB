
function LAVdist = calc_dist( LAVc, num_vox, nbins, sr_th, vsf )


% total LAV
Nemph  = sum( LAVc ) ;
Nlung  = num_vox ;
LAVtot = round( 100*( Nemph / Nlung ), 1 ) ;

% get initial power law distribution
bins  = logspace( 0, ceil( log10( max(LAVc) ) ), nbins+1 ) ;
binc  = 0.5*( bins( 1:end-1 ) + bins( 2:end ) ) ;
count = histc( LAVc, bins ) ;
count = count( 1:end-1 ) ;
X0    = binc( count >0 ) ;
Y0    = fliplr( cumsum( fliplr( count( count >0 ) ) ) ) ;

% get initial guess
[ p,R2 ] = lin_reg( log10( [ X0;Y0 ]' ), 1, 0 ) ;
Yfit = 10^p(2) * X0.^p(1) ;
Sres = ( log10(Y0) - log10(Yfit) ).^2 ;
X = X0 ;    Y = Y0 ;


% return if super clusters not suspected
if max( LAVc ) < 1e4
    LAVdist{ 1 } = [ LAVtot  LAVtot  -p(1)  R2  0  0  0 ] ;
    LAVdist{ 2 } = [ X0 ; Y0 ]' ;
    LAVdist{ 3 } = [ X ; Y ; Yfit ]' ;
    
    return
end


% otherwise find and exclude super clusters
while Sres(end) >sr_th
    X = X( 1:end-1 ) ;  Y = Y( 1:end-1 ) ;
    [ p,R2 ] = lin_reg( log10( [ X;Y ]' ), 1, 0 ) ;
    Yfit = 10^p(2) * X.^p(1) ;
    Sres = ( log10( Y ) - log10( Yfit ) ).^2 ;
end

% get number of excluded clusters
excBin = length(X0) - length(X) ;
if excBin >1
    tmp  = diff( fliplr( Y0( end-excBin+1 : end ) ) ) ;
    excN = sum( [ Y0(end) tmp ] ) ;
elseif excBin ==1
    excN = Y0( end ) ;
else
    excN = 0 ;
end

% adjusted LAV excluding super cluster
[ ~,iCl ] = sort( LAVc, 'descend' ) ;
Nsc       = sum( LAVc( iCl( 1:excN ) ) ) ;
LAVadj    = 100* ( Nemph - Nsc ) / ( Nlung - Nsc ) ;

% save distribution parameters
LAVdist{ 1 } = [ LAVtot  LAVadj  -p(1)  R2  Nsc*vsf  Nsc/Nemph  excN ] ;
LAVdist{ 2 } = [ X0 ; Y0 ]' ;
LAVdist{ 3 } = [ X ; Y ; Yfit ]' ;

