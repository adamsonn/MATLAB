
function plot_projections( lungs, varargin )


switch length( varargin )
    case 2
        frc = varargin{1} ;
        sp  = varargin{2} ;
        
    otherwise
        frc = [ 3 3 2 ] ;
        sp  = [ 2 1 4 3 6 5 ] ;
        figure( frc(1) ) ; set( gcf, 'Position', [ 1000 100 600 1000 ] )
end
fprintf( '\tPlotting ijk projections in 3D...' )


%-- UNPACK lung structure
sz    = lungs.sz ;                  % 3D lung size
pntr  = lungs.pntr ;                % [ ind  HUct  L/R  emph?  clust#  sc# ]
%TLVct = lungs.TLVct ;               % lung volumes estimated by CT

%-- PARAMETERS
prct = 90 ;                         % percentile to threshold lung volume
rd   = [ 1 2 3 ; 2 1 3 ; 3 1 2 ] ;  % dimensions for summing
proj = cell( 3,2 ) ;                % projections
prpl = cell( 1,4 ) ;                % plot projections


%-- GET PROJECTIONS
for nn = 1:2
    % rebuild in 3D
    ind1 = pntr( pntr(:,3) ==nn, 1 ) ;
    msk1 = zeros( sz ) ;	msk1( ind1 ) = 1 ;          % normal tissue
    
    ind2 = pntr( and( pntr(:,3) ==nn, pntr(:,4) ), 1 ) ;
    msk2 = zeros( sz ) ;    msk2( ind2 ) = 1 ;          % emphysema
    % msk2 = imgaussfilt3( msk2, 'FilterSize', 5 ) ;
    
    % get coronal, saggital, axial projections
    for ii = 1:3
        tmp1 = sum( msk1,rd(ii,1) ) ;
        tmp1 = reshape( tmp1, sz( rd(ii,2) ), sz( rd(ii,3) ) ) ;
        
        tmp2 = sum( msk2,rd(ii,1) ) ;
        tmp2 = reshape( tmp2, sz( rd(ii,2) ), sz( rd(ii,3) ) ) ;
        tmp2 = tmp2 ./ tmp1 ; tmp2( isnan(tmp2 ) ) = 0 ;	% normalize
        
        p_th = prctile( tmp1( tmp1 >0 ), 100 -prct ) ;
        proj{ ii,nn } = ( tmp1 >p_th ).*tmp2 ;
    end
end
prpl{1} = fliplr( imrotate( proj{1,1} + proj{1,2}, -90 ) ) ;
prpl{2} = proj{3,1} + proj{3,2} ;
prpl{4} = fliplr( imrotate( proj{2,2}, -90 ) ) ;
prpl{3} = fliplr( imrotate( proj{2,1}, -90 ) ) ;
cmax    = max( [ max( prpl{1}(:) ) max( prpl{2}(:) ) max( prpl{3}(:) ) max( prpl{4}(:) ) ] ) ;


%-- PLOT
figure( frc(1) ) ; nn = 1 ; [ rr,cc ] = size( proj ) ;
myMap = parula ; myMap( 1,: ) = [ 1 1 1 ] ;
for ii = 1:rr
    for jj = 1:cc
        subplot( frc(2), frc(3), sp(nn) )
        if ii ==3
            imagesc( proj{ ii,jj } )
        else
            imagesc( fliplr( imrotate( proj{ ii,jj }, -90 ) ) )
        end
        colormap( myMap ) ; caxis( [ 0 cmax ] ) % colorbar ;
        axis off ; set( gcf, 'Color', [ 1 1 1 ] )
        nn = nn +1 ;
    end
end

fprintf( 'Complete.\n' )


