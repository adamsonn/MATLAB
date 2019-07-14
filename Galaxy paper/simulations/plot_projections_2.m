
%function F = plot_projections_2( lungs, emph3D, N_lung, LAV )
clearvars -except lungs
N_lung = 2 ;


%-- UNPACK lung structure
sz    = lungs.sz ;                  % 3D lung size
pntr  = lungs.pntr ;                % [ ind  HUct  L/R  emph?  clust#  sc# ]

%-- PARAMETERS
prct = 90 ;                         % percentile to threshold lung volume
rd   = [ 1 2 3 ; 2 1 3 ; 3 1 2 ] ;  % dimensions for summing
proj = cell( 3,1 ) ;                % projections
th   = [ 135 80 190 ] ;
%prpl = cell( 1,4 ) ;                % plot projections


%-- GET PROJECTIONS
for nn = N_lung
    % rebuild in 3D
    ind1 = pntr( pntr(:,3) ==nn, 1 ) ;
    msk1 = zeros( sz ) ;	msk1( ind1 ) = 1 ;          % normal tissue
    
    if exist( 'emph3D', 'var' )
        msk2 = emph3D ;
    else
        ind2 = pntr( and( pntr(:,3) ==nn, pntr(:,4) ), 1 ) ;
        msk2 = zeros( sz ) ;    msk2( ind2 ) = 1 ;          % emphysema
        msk2 = imgaussfilt3( msk2, 2, 'FilterSize', 3 ) ;
    end
    
    % get coronal, saggital, axial projections
    for ii = 1:3
        tmp1 = sum( msk1,rd(ii,1) ) ;
        tmp1 = reshape( tmp1, sz( rd(ii,2) ), sz( rd(ii,3) ) ) ;
        
        tmp2 = sum( msk2,rd(ii,1) ) ;
        tmp2 = reshape( tmp2, sz( rd(ii,2) ), sz( rd(ii,3) ) ) ;
        tmp2 = tmp2 ./ tmp1 ; tmp2( isnan(tmp2 ) ) = 0 ;	% normalize
        
        p_th = prctile( tmp1( tmp1 >0 ), 100 -prct ) ;
        tmp  = ( tmp1 >p_th ).*tmp2 ;
        proj{ ii } = tmp / max( tmp(:) ) ; %th( ii ) ;
    end
end
% prpl{1} = fliplr( imrotate( proj{1,1} + proj{1,2}, -90 ) ) ;
% prpl{2} = proj{3,1} + proj{3,2} ;
% prpl{4} = fliplr( imrotate( proj{2,2}, -90 ) ) ;
% prpl{3} = fliplr( imrotate( proj{2,1}, -90 ) ) ;
% cmax    = max( [ max( prpl{1}(:) ) max( prpl{2}(:) ) max( prpl{3}(:) ) max( prpl{4}(:) ) ] ) ;


%-- PLOT
figure(3) ; set( gcf, 'Position', [ 200 800 1000 260 ], 'Color', 'k' ) % [ 9   689   448   668 ] )
nn = 1 ; [ cc,rr ] = size( proj ) ;
myMap = parula ; myMap( 1,: ) = [ 0 0 0 ] ;
for ii = 1:rr
    for jj = fliplr( 1:cc )
        subplot( rr, cc, jj )
        if jj ==3
            imagesc( proj{ jj,ii } ) ; set( gcf, 'Color', [ 1 1 1 ] )
        else
            imagesc( fliplr( imrotate( proj{ jj,ii }, -90 ) ) ) ; set( gcf, 'Color', [ 1 1 1 ] )
        end
        colormap( myMap ) ; caxis( [ 0 1 ] ) % colorbar ;
        axis off ; set( gcf, 'Color', [ 1 1 1 ] )
        nn = nn +1 ;
    end
end
set( gcf, 'Color', [ 0 0 0 ] )
subplot( rr,cc,1 ) ; title( 'Coronal', 'Color', 'w', 'FontSize', 18 )
subplot( rr,cc,2 ) ; title( 'Saggital', 'Color', 'w', 'FontSize', 18 )
subplot( rr,cc,3 ) ; title( 'Axial', 'Color', 'w', 'FontSize', 18 )
% subplot( rr,cc,3 ) ; title( sprintf( '%.1f%% LAV', LAV ), 'Color', 'w', 'FontSize', 18 )

% get frame
F = getframe( gcf ) ;


