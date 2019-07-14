
close all
clearvars

tits = { 'Vsc', 'fsc', 'fTLC', ...
    'FEV1   ', '%FEV1  ', 'FVC    ', '%FVC   ', 'FEV1%  ', 'VC     ', '%VC    ', 'TV     ', ...
    'ERV    ', 'IRV    ', 'IC     ', 'FRC    ', 'RV     ', 'TLC    ', 'RV/TLC ', 'IC/TLC ', ...
    'DLCO   ', 'DLCO/VA', 'pH     ', 'PaO2   ', 'PaCO2  ', 'AaDO2  ' ...
    } ;

bool = 1 ;      % all data (1) or annual change (2)
sc   = 3 ;      % parameter to compare

switch bool
    case 1
        load sc_pft_data.mat
    case 2
        load annual_change.mat
    otherwise
        return
end



%%% correlation
for ii = 4:size( a,2 )
	ind = a(:,ii) > 0 ;
    [ p,R2,cc ] = lin_reg( [ a( ind,sc ) a( ind,ii ) ], 1, 1 ) ;
    xlabel( tits{sc} ) ; ylabel( tits{ii} ) ; hold on
    plot( [ 0 0 ], [ min( a(:,ii) ) max( a(:,ii) ) ], 'b' )
    plot( [ min( a(:,sc) ) max( a(:,sc) ) ], [ 0 0 ], 'b' )
    tmp = [ tits{sc} ' vs ' tits{ii} ] ;
    title( tmp )
    if cc(1,4)>.05 
        close(gcf) 
    else
    end
    fprintf( '\n\t\t%s\t%.3f\t%.3f\t%d', tmp, cc(1,2), cc(1,4), cc(1,4)<.05 )
end
fprintf( '\n\n' )


% %%% annual change
% ind1 = 1:3:size(a,1)-2 ;
% ind2 = 2:3:size(a,1)-1 ;    del1 = a( ind2,: ) - a( ind1,: ) ;
% ind3 = 3:3:size(a,1) ;     	del2 = a( ind3,: ) - a( ind2,: ) ;
% d    = [ del1 ; del2 ] ;
% 
% for ii = 4:size( d,2 )
%     [ p,R2,cc ] = lin_reg( [ d(:,1) d(:,ii) ], 1, 1 ) ;
%     title( [ '\Delta' tits{ ii } ] )
%     if cc(1,4)>.05 ; close(gcf) ; end
%     fprintf( '\n\t\t%s\t%.3f\t%.3f\t%d', tits{ ii }, cc(1,2), cc(1,4), cc(1,4)<.05 )
% end
% fprintf( '\n\n' )
% 
% d_ave = [ tits' num2cell( [ mean( d,1 ); std( d,[],1 ); min(d); max(d) ]' ) ] ;


