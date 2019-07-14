

F( length( LAV_step ) ) = struct( 'cdata', [], 'colormap', [] ) ;

figure() ; set( gcf, 'Color', 'k' )
for ii = 1:length( LAV_step )
    title( sprintf( 'LAV%% = %.1f', 100*LAV_step(ii) ), 'Color', 'w' )
    F( ii ) = getframe( gcf ) ;
end

F( end+1:end+16 ) = F(end) ;

vid2 = VideoWriter( [ vdir 'LAV_label' ] ) ;
vid2.FrameRate = 8 ;

open( vid2 )
for ii = 1:length( F )
    writeVideo( vid2, F(ii) )
end
close( vid2 )