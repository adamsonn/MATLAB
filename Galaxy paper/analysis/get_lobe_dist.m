
close all


%-- PARAMETERS
th = 0.90 ;             % threshold for lobe localization

% directories
sr_dir = 'C:\Users\Suki''s Lab\Desktop\DATA\lung_imaging\lung_structs\-960HU\' ;

% get individual pt names
scan_names = dir( [ sr_dir '*.mat' ] ) ;
pt_id = cell( size( scan_names ) ) ;
for ii = 1:length( scan_names )
    str = strsplit( scan_names( ii ).name, '_' ) ;
    pt_id{ii} = str{1} ;
end
pt_id = unique( pt_id ) ; disp( pt_id )


%-- ANALYZE LOBES
z0 = zeros( length( pt_id ), 7 ) ;  % [ RU RM RL LU LL R* L* ]
lobe_prim = [] ;                    % saves primary lobes for super clusters
lobe_freq = { z0, z0, z0 } ;        % saves lobar frequency of super clusters

% loop through pt
for pt = 1:length( pt_id )
    pt_scans = dir( [ sr_dir pt_id{pt} '*.mat' ] ) ;
    pt_scans = { pt_scans.name } ;
    
    % loop through time points
    for ps = 1:length( pt_scans )
        load( [ sr_dir pt_scans{ps} ] )
        
        % loop each lung
        for nn = 1:2
            lobe = lungs.sup_clust(nn).lobe ;
            
            % relative freq of primary lobe
            [ ~,ind ] = max( lobe,[],2 ) ;
            lobe_prim = [ lobe_prim ; ind ] ;   %#ok<AGROW>
            
            % lobe restriction
            tmp = lobe >= th ;
            lobe_freq{ps}( pt,1:5 )  = sum( tmp,1 ) + lobe_freq{ps}( pt,1:5 ) ;
            lobe_freq{ps}( pt,8-nn ) = sum( all( ~tmp,2 ) ) ;
            
        end
    end
end

% single vs multi-lobe
all_lungs = logical( [ lobe_freq{1} ; lobe_freq{2} ; lobe_freq{3} ] ) ;
lobe_mult = zeros( size( all_lungs,1 ), 6 ) ;	% saves single vs multiple lobes
for jj = 1:size( all_lungs,1 )
    % right lung
    if sum( all_lungs( jj,1:3 ) ) >1 || all_lungs( jj,6 ) >0
        lobe_mult( jj,2 ) = 1 ;
        if all_lungs( jj,6 ) >0
            lobe_mult( jj,3 ) = 1 ;
        end
    else
        lobe_mult( jj,1 ) = 1 ;
    end
    
    % left lung
    if sum( all_lungs( jj,4:5 ) ) >1 || all_lungs( jj,7 ) >0
        lobe_mult( jj,5 ) = 1 ;
        if all_lungs( jj,7 ) >0
            lobe_mult( jj,6 ) = 1 ;
        end
    else
        lobe_mult( jj,4 ) = 1 ;
    end
end

% lobe frequency of singles
sing_freq = [ ...
    sum( all_lungs( logical( lobe_mult(:,1) ), 1:3 ) ) ...
    sum( all_lungs( logical( lobe_mult(:,4) ), 4:5 ) ) ...
    ] ;


%-- PLOT
figure() ; set( gcf, 'Position', [ 667  591  1250  420 ] )

a = histc( lobe_prim, 0.5:1.0:5.5 ) ;
b = { 'RU', 'RM', 'RL', 'LU', 'LL' } ;
subplot( 1,3,1 ) ; bar( 1:5, a(1:5) ) ; set( gca, 'XTickLabel', b )
title( 'Primary Lobe Frequency' )

l = 2*size( lobe_mult,1 ) ;
c = sum( lobe_mult(:,1) ) + sum( lobe_mult(:,4) ) ;
d = sum( lobe_mult(:,2) ) + sum( lobe_mult(:,5) ) ;
f = sum( lobe_mult(:,3) ) + sum( lobe_mult(:,6) ) ;
subplot( 1,3,2 ) ; bar( 1:3, [ c d f ] ) ; set( gca, 'XTickLabel', { 'single', 'multi', 'span' } )
title( 'Single vs. Multi Lobe' )

subplot( 1,3,3 ) ; bar( 1:5, sing_freq ) ; set( gca, 'XTickLabel', b )
title( 'Single Lobe Frequency' )


% disp( lobe_freq{1} )
% disp( lobe_freq{2} )
% disp( lobe_freq{3} )


