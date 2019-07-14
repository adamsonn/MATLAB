
clearvars

s = load( 'annual_change_sc.mat' ) ;
for ii = 1:size( s.a,2 )
    [ h,p ] = ttest( s.a( :,ii ) ) ;
    fprintf( '\t%s\t%d\t%.3f\n', s.tits{ ii }, h, p )
end
fprintf( '\n' )

s = load( 'annual_change_pft.mat' ) ;
for ii = 1:size( s.a,2 )
    [ h,p ] = ttest( s.a( :,ii ) ) ;
    fprintf( '\t%s\t%d\t%.3f\n', s.tits{ ii }, h, p )
end