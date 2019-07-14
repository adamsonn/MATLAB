
% temporarily check if analyzing both lungs simultaneously returns same
% results as analyzing each lung individually

function lungs_out = analyze_both_lungs( lungs )


%-- UNPACK 'lungs' struct
sz   = lungs.sz ;
pntr = lungs.pntr ;                     % [ ind   HUct   L/R   emph? ]

%-- PARAMETERS
conn    = 6 ;                           % connectivity
nbins   = 70 ;                          % number of bins for distribution
sr_th   = 0.5 ;                         % outlier threshold
sc_pnt  = zeros( size(pntr,1), 2 ) ;    % pre-allocate super cluster pointer columns
LAVdist = cell( 3,1 ) ;                 % save distribution parameters


fprintf( '\n\tAnalyzing LAV cluster distribution...' )

%-- REBUILD emphysema in 3D for selected lung
emph3D = zeros( sz ) ;
emph3D( pntr( logical( pntr(:,4) ), 1 ) ) = 1 ;

%-- Find LAV CLUSTERS
CC   = bwconncomp( emph3D, conn ) ;
LAVi = CC.PixelIdxList ;                    % LAV indices
LAVc = cellfun( @numel, LAVi ) ;            % LAV cluster sizes
LAN  = length( LAVc ) ;                     % number of LAV clusters

% assign cluster number
for ii = 1 : length( LAVi ) ; emph3D( LAVi{ii} ) = ii ; end
sc_pnt(:,1) = sc_pnt(:,1) + emph3D( pntr(:,1) ) ;


%-- POWER LAW distribution
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

% exclude super clusters
while Sres(end) >sr_th      % and( Sres(end) >sr_th, X(end) >sv_th )
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

% assign super cluster number
[ ~,iCl ] = sort( LAVc, 'descend' ) ;
for ii = 1 : excN
    tmp = zeros( sz ) ;  tmp( LAVi{ iCl(ii) } ) = 1 ;
    sc_pnt(:,2) = sc_pnt(:,2) + ii*tmp( pntr(:,1) ) ;
end

% adjusted LAV excluding super cluster
Nsc    = sum( LAVc( iCl( 1:excN ) ) ) ;
Nemph  = sum( pntr(:,4) ) ;
Nlung  = size( pntr,1 ) ;
LAVadj = ( Nemph - Nsc ) / ( Nlung - Nsc ) ;

% save distribution parameters
LAVdist{ 1 } = [ 100*LAVadj -p(1) R2 ] ;
LAVdist{ 2 } = [ X0 Y0 ] ;
LAVdist{ 3 } = [ X  Y  ] ;


%-- SAVE
lungs_out.pntr = [ pntr( :,1:4 ) sc_pnt ] ;
lungs_out.LAN  = LAN ;
lungs_out.dist = LAVdist ;
fprintf( 'Complete.\n' )


%-- PLOT
figure()
loglog( X0, Y0, 'bo' ) ; hold on ; loglog( X, Yfit, 'r--' )
loglog( X0( length(X)+1:end ), Y0( length(X)+1:end ), 'c*' )
title( sprintf( 'Percent = %.1f', 100*Nemph/Nlung ) )
xlabel( 'Cluster Size (#vox)' ) ; ylabel( 'Cum # of clusters' )
xlim( [ 1 1e7 ] ) ; ylim( [ 1 1e7 ] )

