
close all

if ~exist( 'b', 'var' ) ; load sc_data.mat ; end

tits = { ...
    'LAV   ', 'Vsc   ', 'fsc   ', 'fTLV  ',...
    'LAVadj', 'D     ', 'LAN   ', 'Df    ', 'Df*   ', ...
    } ;


%%% correlation
for ii = 8:9 %1:size( b,2 )
    for jj = 1:size( b,2 )
        tmp = [ b(:,ii) b(:,jj) ] ;
        ind = all( tmp >0, 2 ) ;
        [ p,R2,cc ] = lin_reg( tmp( ind,: ), 1, 1 ) ;
        ylabel( tits{jj} ) ; xlabel( tits{ii} )
        if or( cc(1,4)>.05, ii==jj )
            close(gcf)
        else
            fprintf( '\n\t\t%s\t%s\t%.3f\t%.3f\t%d', ...
                tits{ii}, tits{jj}, cc(1,2), cc(1,4), cc(1,4)<.05 )
        end
    end
end
fprintf( '\n\n' )

return

%%% annual change
b2   = b ; b2( 4:6,: ) = [] ;
ind1 = 1:3:size(b2,1)-2 ;
ind2 = 2:3:size(b2,1)-1 ;       del1 = b2( ind2,: ) - b2( ind1,: ) ;
ind3 = 3:3:size(b2,1) ;     	del2 = b2( ind3,: ) - b2( ind2,: ) ;
d    = [ del1 ; del2 ] ;

for ii = [ 2 5 ] % 1:size( b2,2 )
    for jj = 1:size( b2,2 )
        [ p,R2,cc ] = lin_reg( [ d(:,ii) d(:,jj) ], 1, 1 ) ;
        ylabel( tits{jj} ) ; xlabel( tits{ii} )
        if or( cc(1,4)>.05, ii==jj )
            close(gcf)
        else
            fprintf( '\n\t\t%s\t%s\t%.3f\t%.3f\t%d', ...
                tits{ii}, tits{jj}, cc(1,2), cc(1,4), cc(1,4)<.05 )
        end
    end
end
fprintf( '\n\n' )

d_ave = [ tits' num2cell( [ mean( d,1 ); std( d,[],1 ); min(d); max(d) ]' ) ] ;

warning( 'off', 'MATLAB:xlswrite:AddSheet' )
xlswrite( 'sc_data_annual.xls', num2cell( d ) )
xlswrite( 'sc_data_annual.xls', d_ave, 'Sheet2' )
warning( 'on', 'MATLAB:xlswrite:AddSheet' )


