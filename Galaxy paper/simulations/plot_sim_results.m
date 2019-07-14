

figure() ; set( gcf, 'Position', [ 86  241  1145  326 ]  ) % [ 886   870   983   277 ] )

subplot( 1,3,1 )
plot( stats(:,1), stats(:,5), 'ro-' ) ; hold on
plot( [ 20  40 ], [ 0.14  0.97 ], 'k--' )
xlabel( 'LAV_t_o_t (%)' ) ; ylabel( 'SC Volume (L)' )
title( 'SuperCluster Volume', 'FontWeight', 'b' )

ind = stats(:,4) > .98 ;
subplot( 1,3,2 )
plot( stats(ind,2), stats(ind,3), 'bo-' ) ; hold on
plot( stats(:,2), stats(:,3), 'c*' )
xlabel( 'LAV_a_d_j (%)' ) ; ylabel( 'D' ) ; %ylim( [ 0.5 3.5 ] )
title( 'D parameter', 'FontWeight', 'b' )

subplot( 1,3,3 )
plot( stats(:,1), LAN, 'ko-' )
xlabel( 'LAV_t_o_t (%)' ) ; ylabel( 'LAN' ) ; ylim( [ 1e5 7e5 ] )
title( 'LAN', 'FontWeight', 'b' )
