

function lungs = analyze_super_clust( lungs )


%-- UNPACK lungs
sz   = lungs.sz ;
pntr = lungs.pntr ;                 % [ ind  HUct  L/R  emph?  clust#  sc# ]
vsf  = lungs.vox(1) ;               % scaling factor for voxel in liters

%-- PARAMETERS
rd = [ 2 3; 1 3 ; 1 2 ] ;           % dimensions for density summing


fprintf( '\n\tAnalyzing super clusters...' )
for nn = 1:2        % loop through each lung
    
    N_sc = max( pntr( pntr(:,3) ==nn, 6 ) ) ;       % number of super clusters
    vol  = zeros( N_sc, 3 ) ;                   	% volume fractions
    rho  = cell( N_sc, 1 ) ;                    	% density / centroid in ijk-space
    Df   = zeros( N_sc, 2 ) ;                   	% fractal dimension
    lobe = zeros( N_sc, 5 ) ;                       % percentage in each lobe
    
    for sc = 1:N_sc     % loop through clusters
        
        %-- REBUILD in 3D
        ind_sc = pntr( and( pntr(:,3) ==nn, pntr(:,6) ==sc ), 1 ) ;
        sc_msk = zeros( sz ) ;      sc_msk( ind_sc ) = 1 ;      % super cluster
        
        ind_emph = pntr( and( pntr(:,3) ==nn, pntr(:,4) ), 1 ) ;
        emph_msk = zeros( sz ) ;    emph_msk( ind_emph ) = 1;   % emphysema
        
        ind_lung = pntr( pntr(:,3) ==nn, 1 ) ;
        lung_msk = zeros( sz ) ;    lung_msk( ind_lung ) = 1 ;  % lung voxels
        
        
        %-- VOLUME and fractions
        vol( sc,: ) = [ ...
            vsf*sum( sc_msk(:) ) ...                        % volume (L)
            sum( sc_msk(:) ) / sum( emph_msk(:) ) ...       % fraction of LAVtot
            sum( sc_msk(:) ) / sum( lung_msk(:) ) ...       % fraction of TLV
            ] ;
        
        
        %-- LOBAR percentages
        sc_lobe = pntr( and( pntr(:,3) ==nn, pntr(:,6) ==sc ), 7 ) ;
        for ll = 4:8
            lobe( sc,ll-3 ) = sum( sc_lobe ==ll ) / length( sc_lobe ) ;
        end
        
        
        %-- Get DENSITY and CENTROID in ijk-space
        rho_sc = cell( 3,2 ) ;
        for jj = 1:3
            a = sum( sum( sc_msk, rd(jj,1) ), rd(jj,2) ) ;
            a = reshape( a,numel(a),1 ) ;
            
            b = sum( sum( lung_msk, rd(jj,1) ), rd(jj,2) ) ;
            b = reshape( b,numel(b),1 ) ;
            
            ab  = a./b ;
            abn = zeros( size(a) ) ;
            
            abn( ab >0 ) = ab( ab >0 ) ;
            rho_sc{ jj,1 } = [ abn a b ] ;      % density distribution
            
            out = sc_centroid( [ abn a b ] ) ;
            rho_sc{ jj,2 } = out ;              % centroid
        end
        rho{ sc,1 } = rho_sc ;
        
        
        %-- Estimate FRACTAL dimension
        [ Df_sc, R2 ] = fractal_dimension( sc_msk, sz ) ;
        Df( sc,: )    = [ Df_sc R2 ] ;
        
    end
    
    
    %-- Estimate FRACTAL dimension for combined super clusters
    if N_sc >1
        ind    = pntr( and( pntr(:,3) ==nn, logical( pntr(:,6) ) ), 1 ) ;
        sc_tot = zeros( sz ) ;      sc_tot( ind ) = 1 ;
        [ Df_t, R2 ] = fractal_dimension( sc_tot, sz ) ;
        Df_tot = [ Df_t R2 ] ;
        
        vol_tot = [ ...
            vsf*sum( sc_tot(:) ) ...
            sum( sc_tot(:) ) / sum( emph_msk(:) ) ...
            sum( sc_tot(:) ) / sum( lung_msk(:) ) ...
            ] ;
    else
        Df_tot  = Df ;
        vol_tot = vol ;
    end
    
    
    %-- Estimate FRACTAL dimension of remaining clusters
    ind_rc = [ pntr(:,3) ==nn, pntr(:,4), ~logical( pntr(:,6) ) ] ;
    ind_rc = pntr( all( ind_rc,2 ), 1 ) ;
    rc_msk = zeros( sz ) ;      rc_msk( ind_rc ) = 1 ;
    [ Df_rc, R2_rc ] = fractal_dimension( rc_msk, sz ) ;
    
    
    %-- save locally
    sup_clust( nn ).vol  = { vol_tot, vol } ;        %#ok<*AGROW>
    sup_clust( nn ).rho  = rho ;
    sup_clust( nn ).Df   = { Df_tot, Df, [ Df_rc R2_rc ] } ;
    sup_clust( nn ).lobe = lobe ;
    
end


%--SAVE
lungs.sup_clust = sup_clust ;
fprintf( 'Complete.\n' )


