
close all

%%% MOVIE SPECS
bool_vid  = 1 ;
vdir      = 'C:\Users\Suki''s Lab\Desktop\Media\Videos\' ;
vfn       = 'model_simulation3b' ;

if bool_vid
    F( length( length( dist ) ) ) = struct( 'cdata', [], 'colormap', [] ) ;
end





gs = fliplr( linspace( 0, 0.7, length( dist ) ) ) ;
LAV_step = unique( [ p.seed_perc : p.step_perc : p.max_perc p.max_perc ] ) ;

figure() ; set( gcf, 'Position', [ 704   377   900   700 ], 'Color', [ 1 1 1 ] ) ; r= 3 ; c= 3 ;
for ii = 1:length( dist )
    
    %%% Distribution
    subplot( r,c,1:6 )
    for jj = 1:ii
        X0 = dist{jj}{2}( :,1 ) ;  Y0   = dist{jj}{2}( :,2 ) ;
        X  = dist{jj}{3}( :,1 ) ;  Yfit = dist{jj}{3}( :,2 ) ;
        
        if jj==ii
            loglog( X0, Y0, 'LineStyle', 'none', 'Marker', 'o', ...
                'MarkerEdgeColor', [ 0 0 0 ], 'MarkerFaceColor', [ gs(jj) gs(jj) gs(jj) ] ) ; hold on
            loglog( X, Yfit, 'r-', 'LineWidth', 2 )
            loglog( X0( length(X)+1:end ), Y0( length(X)+1:end ), 'ko', 'MarkerFaceColor', 'b' )
        else
            loglog( X0, Y0, 'LineStyle', 'none', 'Marker', 'o', ...
                'MarkerEdgeColor', [ gs(jj) gs(jj) gs(jj) ] ) ; hold on
        end
        
    end
    xlabel( 'Cluster Size (voxels)' ) ; xlim( [ 1 1e7 ] )
    ylabel( 'Cumulative Number of Clusters', 'FontWeight', 'b' ) ; ylim( [ .7 1e7 ] )
    title( sprintf( 'LAV%% = %.1f', round( 100*LAV_step(ii),1 ) ), 'FontWeight', 'b', 'FontSize', 18 )
    hold off
    
    %%% Super Cluster Volume
    subplot( r,c,7 )
    plot( stats(ii,1), stats(ii,5), 'ko', 'MarkerFaceColor', 'b', 'MarkerSize', 5 ) ; hold on
    plot( lungs.LAV(nn+1), lungs.sup_clust(nn).vol{1}(1), 'k^', 'MarkerFaceColor', 'g', 'MarkerSize', 7 )
    xlabel( 'LAV_t_o_t (%)' ) ; xlim( [ 0 40 ] )
    ylabel( 'Super Cluster Volume (L)', 'FontWeight', 'b' ) ; ylim( [ 0 0.5 ] )
    legend( 'Location', 'NorthWest', 'Model', 'CT' ) ; legend boxoff
    
    %%% Slope D
    ind = find( stats(:,4) > .98, 1, 'First' ) ;
    subplot( r,c,8 )
    plot( lungs.dist{1,nn}(1), lungs.dist{1,nn}(2), 'k^', 'MarkerFaceColor', 'g', 'MarkerSize', 7 ) ; hold on
    plot( stats(1:ii,2), stats(1:ii,3), 'ro', 'MarkerSize', 5 )
    plot( stats(ind:ii,2), stats(ind:ii,3), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 5 )
    plot( lungs.dist{1,nn}(1), lungs.dist{1,nn}(2), 'k^', 'MarkerFaceColor', 'g', 'MarkerSize', 7 )
    xlabel( 'LAV_a_d_j (%)' ) ; xlim( [ 0 40 ] )
    ylabel( 'D', 'FontWeight', 'b' ) ; ylim( [ 1 4 ] )
    legend( 'Location', 'NorthEast', 'CT', 'Model' ) ; legend boxoff
    
    %%% LAV
    subplot( r,c,9 )
    plot( stats(1:ii,1), LAN(1:ii), 'ko', 'MarkerSize', 5 ) ; hold on
    plot( lungs.LAV(nn+1), lungs.LAN(nn), 'k^', 'MarkerFaceColor', 'g', 'MarkerSize', 7 )
    xlabel( 'LAV_t_o_t (%)' ) ; xlim( [ 0 40 ] )
    ylabel( 'LAN', 'FontWeight', 'b' ) ; ylim( [ 1e5 8e5 ] )
    legend( 'Location', 'SouthWest', 'Model', 'CT' ) ; legend boxoff
    
    % get frame
    F( ii ) = getframe( gcf ) ;
end



%%% BUILD MOVIE
if bool_vid
    F( end+1:end+6 ) = F(end) ;
    vid = VideoWriter( [ vdir vfn ] ) ;
    vid.FrameRate = 3 ;
    
    open( vid )
    for ii = 1:length( F )
        writeVideo( vid, F(ii) )
    end
    close( vid )
end


