

function lungs = divide_LR( s, vsz, emph_th )


%-- PARAMETERS
% emph_th   = -960 ;                      % emphysema threshold
vsf       = 1e-6*prod( vsz ) ;          % scaling factor to L per voxel
bool_vid  = 0 ;                         % choose to make lung segmentation video
vdir      = 'C:\Users\Suki''s Lab\Desktop\Media\Videos\Lung_segmentation\' ;


%-- THRESHOLD CT
lung_CT  = s{4} ;                           % get CT data
lung_msk = lung_CT < 0 ;                    % lung voxels
emph_msk = lung_CT <= emph_th ;             % emphysema voxels

if length(s) <5
    lobe_msk = zeros( size( lung_CT ) ) ;
else
    lobe_msk = s{5} ;                     	% lobe mask
end


%-- INSTANTIATE save structure
lungs.sz  = size( lung_CT ) ;
lungs.vox = [ vsf vsz ] ;


%-- DIVIDE into L/R lung
LR_msk  = zeros( size( lung_msk ) ) ;       % left/right lung mask

if bool_vid                                 % initialize movie
    numf      = length( 55 : size( lung_msk,3 ) ) ;
    F( numf ) = struct( 'cdata', [], 'colormap', [] ) ;
end

fprintf( '\tDividing into Left and Right lungs...' )
for nn = 1 : size( lung_msk,3 )
    
    % get region properties for slice
    bw   = bwlabel( lung_msk( :,:,nn ) ) ;
    rp   = regionprops( logical( bw ), 'Area', 'Centroid' ) ;
    mdl  = size( lung_msk,2 ) / 2 ;
    bool = 0 ;
    
    if length( rp ) >= 2
        
        % find main left and right lung clusters
        [ ~,I ] = sort( [ rp.Area ], 'descend' ) ;
        C       = [ rp( I(1) ).Centroid ; rp( I(2) ).Centroid ] ;
        [ ~,L ] = max( C( :,1 ) ) ;
        [ ~,R ] = min( C( :,1 ) ) ;
        
        % then assign smaller clusters to L or R
        if all( C(:,1) > mdl ) ...      % QC - check if one-sided
                || all( C(:,1) <= mdl ) ;
            bool = 1 ;
            
        else                            % proceed
            for ii = 3 : size( I,2 )
                d = pdist( [ C; rp( I(ii) ).Centroid ] ) ;
                if d(2) < d(3) ;        bw( bw == I(ii) ) = I(1) ;
                elseif d(2) > d(3) ;    bw( bw == I(ii) ) = I(2) ;
                end
            end
            bw2                 = zeros( size( bw ) ) ;
            bw2( bw == I( L ) ) = 1 ;   % assign left
            bw2( bw == I( R ) ) = 2 ;   % assign right
            
        end
        
    elseif isempty( rp )                % QC - check if no regions
        bool = 2 ;
    else                                % QC - check if only one region
        I = 1 ;
        bool = 1 ;
    end
    
    Amax = round( .15*numel( bw ) ) ;	% QC - check if any too big
    if max( [ rp.Area ] ) > Amax
        bool = 3 ;
    end
    
    % handle any errors
    switch bool
        case 1  % cluters failed: assign based on centroid location
            bw2 = zeros( size( bw ) ) ;
            for ii = 1 : size( I,2 )
                if rp( I(ii) ).Centroid(1) > mdl ;  bw2( bw == I(ii) ) = 1 ;
                else                                bw2( bw == I(ii) ) = 2 ;
                end
            end
            
        case 2  % no regions: do nothing
            bw2 = bw ;
            
        case 3  % too big: assign based on previous slice
            L1    = LR_msk( :,:,nn-1 ) ;                   % previous slice
            L2    = lung_msk( :,:,nn ) ;                    % current slice
            Ldiff = logical( L1 ) - logical( L2 ) ;         % unassigned pixels
            
            ind1       = find( L1 ) ;
            [ i1, i2 ] = ind2sub( size( L1 ), ind1 ) ;
            ind2       = find( Ldiff ) ;
            [ j1, j2 ] = ind2sub( size( Ldiff ), ind2 ) ;
            k          = knnsearch( [ i1 i2 ], [ j1 j2 ] ) ;    % nearest neighbor in previous
            
            L2new         = zeros( size( L2 ) ) ;
            L2new( ind2 ) = L1( ind1( k ) ) ;
            L2new         = L1 .* logical( L2 ) + L2new ;       % assign pixels in new slice
            
            bw2 = L2new ;
            
        otherwise
    end
    
    % save
    LR_msk( :,:,nn ) = bw2 ;
    
    % get movie frame
    if bool_vid
        f1 = figure( 1 ) ; set( gcf, 'Position', [ 1 41 1920 964 ] )
        subplot( 1,3,1 ) ; imshow( bw2 ) ;      title( 'LUNG MASK', 'FontSize', 14 )
        subplot( 1,3,2 ) ; imshow( bw2 == 2 ) ; title( 'RIGHT LUNG', 'FontSize', 14 )
        subplot( 1,3,3 ) ; imshow( bw2 == 1 ) ; title( 'LEFT LUNG', 'FontSize', 14 )
        F( nn ) = getframe( f1 ) ;
    end
    
end
fprintf( 'Complete.\n' )
if bool_vid ; close( f1 ) ; end


% correct lobe mask
lobe_msk( lobe_msk >8 ) = 0 ;



%-- Populate lung POINTER matrix
ind  = find( lung_msk ) ;                                         	% find lung voxel indices
pntr = zeros( length( ind ), 7 ) ;                                 	% lung pointer matrix
pntr( :,1:4 ) = [ ind, lung_CT(ind), LR_msk(ind), emph_msk(ind) ] ;
pntr( :,7 )   = lobe_msk( ind ) ;

%-- Get LAV and lung volumes
indLR = [ pntr(:,3) ==1, pntr(:,3) ==2 ] ;
Lvox  = [ sum( indLR(:) ) sum( indLR ) ] ;
Evox  = [ sum( pntr(:,4) ), sum( and( indLR(:,1), pntr(:,4) ) ), sum( and( indLR(:,2), pntr(:,4) ) ) ] ;
LAV   = 100* Evox ./ Lvox ;
TLVct = vsf* Lvox ;

%-- Get lobar volumes
lobe_vol = zeros( 1,5 ) ;
for lv = 4:8
    lobe_vol( lv-3 ) = vsf*sum( pntr(:,7) == lv ) ;
end

%-- Build MOVIE
if exist( 'F', 'var' ) && bool_vid
    fprintf( '\tMaking lung segmentation video...' )
    make_video
    vn = strsplit( fn, '.' ) ;
    movefile( 'my_movie.avi', [ vdir vn{1} '.avi' ] )
    fprintf( [ 'Complete.\t\tSaved video ' vn{1} '.avi.\n' ] )
end

%-- SAVE
lungs.th       = [ num2str( emph_th ) ' HU' ] ;
lungs.pntr     = pntr ;
lungs.LAV      = LAV ;
lungs.TLVct    = TLVct ;
lungs.lobe_vol = lobe_vol ;
%fprintf( '\tFinished.\n' )


