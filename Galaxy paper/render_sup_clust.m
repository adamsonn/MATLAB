

function lungs = render_sup_clust( lungs, varargin )


%-- UNPACK lungs structure
sz        = lungs.sz ;
pntr      = lungs.pntr ;           	% [ ind  HUct  L/R  emph?  clust#  sc# ]
sup_clust = lungs.sup_clust ;     	% super cluster structure

switch length( varargin )
    case 2
        plot_bool = varargin{1} ;
        hax_1     = varargin{2}{ 1 } ;
        hax_2     = varargin{2}{ 2 } ;
        
    case 1
        close all
        plot_bool = varargin{1} ;
        figure( 1 ) ; set( gcf, 'Position', [ 154 225 740 800 ] ) ; hax_1 = gca ;
        figure( 2 ) ; set( gcf, 'Position', [ 1060 100 820 400 ] ) ;
        subplot( 1,2,1 ) ; hax_2{ 1 } = gca ;
        subplot( 1,2,2 ) ; hax_2{ 2 } = gca ;
    case 0
        plot_bool = 0 ;
        
    otherwise
        return
end


fprintf( '\n\tRendering in 3D...' )
%-- get boundary surfaces of cleaned left/right lung
if ~isfield( lungs, 'plot_lung' )
    
    % clean mask for lung outline
    lung_msk = zeros( sz ) ;    lung_msk( pntr(:,1) ) = 1 ;
    cln_msk  = zeros( sz ) ;
    for ii = 1 : size( lung_msk,3 )
        bw = bwlabel( lung_msk( :,:,ii ) ) ;
        rp = regionprops( logical( bw ), 'Area' ) ;
        A  = [ rp.Area ] ;
        aa = find( A <200 ) ;
        
        for jj = 1:length(aa) ; bw( bw == aa(jj) ) = 0 ; end
        cln_msk( :,:,ii ) = lung_msk( :,:,ii ) .* logical( bw ) ;
    end
    cln_msk = cln_msk( pntr(:,1) ) ;
    
    % get boundary and save
    for nn = 1:2
        indL  = pntr( and( pntr(:,3)==nn, cln_msk ), 1 ) ;
        L_msk = zeros( sz ) ;     L_msk( indL ) = 1 ;
        [ x1, x2, x3 ] = ind2sub( sz, find( bwperim( L_msk ) ) ) ;
        k2    = boundary( [ x1 x2 x3 ] ) ;
        lungs.plot_lung{ nn } = { k2, [ x1 x2 x3 ] } ;      % save to lungs
    end
    
end
plot_lung = lungs.plot_lung ;


%-- get boundary surfaces of cluster(s)
if ~isfield( sup_clust, 'plot_clust' )
    for nn = 1:2
        plot_clust = cell( length( sup_clust(nn).rho ), 1 ) ;
        for cl = 1:length( plot_clust )
            ind    = pntr( and( pntr(:,3) ==nn, pntr(:,6) ==cl ), 1 ) ;
            sc_msk = zeros( sz ) ;  sc_msk( ind ) = 1 ;
            [ c1, c2, c3 ] = ind2sub( sz, find( bwperim( sc_msk ) ) ) ;
            ksc    = boundary( [ c1 c2 c3 ], 1 ) ;
            plot_clust{ cl } = { ksc, [ c1 c2 c3 ] } ;
        end
        lungs.sup_clust(nn).plot_clust = plot_clust ;       % save to lungs
    end
end
sup_clust = lungs.sup_clust ;



%-- RENDER super cluster
if plot_bool
    axes( hax_1 )
    
    for nn = 1:2
        % lungs
        kx = plot_lung{nn} ;
        x1 = kx{2}(:,1) ;   x2 = kx{2}(:,2) ;   x3 = kx{2}(:,3) ;
        trisurf( kx{1}, x1, x2, x3, 192*ones( size(x1) ), 'FaceAlpha', 0.3 )
        hold on
        
        % clusters
        for cl = 1:length( sup_clust(nn).rho )
            kc = sup_clust(nn).plot_clust{cl} ;
            c1 = kc{2}(:,1) ;   c2 = kc{2}(:,2) ;   c3 = kc{2}(:,3) ;
            trisurf( kc{1}, c1, c2, c3, 64*ones( size(c1) ), 'FaceAlpha', 0.3 )
            %text( 0, mean(c2), mean(c3), num2str(cl),...
             %   'Color', 'y', 'FontSize', 14, 'FontWeight', 'b' )
        end
    end
    
    % formatting
    [ ii,jj,kk ] = ind2sub( sz, pntr(:,1) ) ;
    C  = round( mean( [ ii jj kk ] ) ) ; sp = 400 ;
    axis( [ C(1)-sp, C(1)+sp, C(2)-sp, C(2)+sp, C(3)-sp, C(3)+sp ] )
    grid off ; axis off ; set( gca, 'ZDir', 'Reverse', 'YDir', 'Reverse' )
    view( -90,9 ) ; shading interp ; colormap copper ; camlight
end


%-- PLOT error bar box
if plot_bool
    fignm = { 'LEFT', 'RIGHT' } ; col = { 'r', 'b', 'g', 'c', 'm' } ;
    for nn = 1:2
        axes( hax_2{ nn } ) %#ok<LAXES>
        for cl = 1:length( sup_clust(nn).rho )
            
            % get centroid of cluster
            rho  = sup_clust(nn).rho{cl} ;
            Cijk = [ ...
                1- rho{1,2}(2,[ 1 3 5 ]) ;...     % flip reference relative to front of lung
                1- rho{2,2}(2,[ 1 3 5 ]) ;...     % flip reference relative to center
                rho{3,2}(2,[ 1 3 5 ]) ...
                ] ;
            
            ci = Cijk(1,2) ;        % center, i-space
            cj = Cijk(2,2) ;        % center, j-space
            ck = Cijk(3,2) ;        % center, k=space
            
            % plot marker
            plot3( ci, cj, ck, 'ko', 'MarkerFaceColor', 'k' ) ; hold on
            plot3( [ ci,1,ci ], [ cj,cj,1 ], [ 0, ck, ck ], 'k.' )
            
            % 'i' density bar
            plot3( Cijk(1,[1 3]), [ cj cj ], [ ck ck ], [ col{cl} '-' ] )
            plot3( Cijk(1,[1 3]), [ 1 1 ], [ ck ck ], [ col{cl} '--' ] )
            plot3( Cijk(1,[1 3]), [ cj cj ], [ 0 0 ], [ col{cl} '--' ] )
            
            % 'j' density bar
            plot3( [ ci ci ], Cijk(2,[1 3]), [ ck ck ], [ col{cl} '-' ] )
            plot3( [ 1 1 ], Cijk(2,[1 3]), [ ck ck ], [ col{cl} '--' ] )
            plot3( [ ci ci ], Cijk(2,[1 3]), [ 0 0 ], [ col{cl} '--' ] )
            
            % 'k' density bar
            plot3( [ ci ci ], [ cj cj ], Cijk(3,[1 3]), [ col{cl} '-' ] )
            plot3( [ 1 1 ], [ cj cj ], Cijk(3,[1 3]), [ col{cl} '--' ] )
            plot3( [ ci ci ], [ 1 1 ], Cijk(3,[1 3]), [ col{cl} '--' ] )
            
            if nn ==1 ; ylabel( 'L <- M' )
            else ylabel( 'M -> L' ) ; end
            
        end
        title( fignm{nn}, 'FontSize', 14 )
        xlabel( 'A -> P' ) ; zlabel( 'Ca -> Cr' )
        axis( [ 0 1 0 1 0 1 ] ) ; grid on
        
    end
end

fprintf( 'Complete.\n' )


