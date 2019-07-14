
out = zeros( size( a,2 ), 3 ) ;
for ii = 1:size( a,2 )
    p  = prctile( a(:,ii), [ 25 50 75 ] ) ;
    out( ii,: ) = p' ;
end
xlswrite( 'prct_data.xls', num2cell( out ) )