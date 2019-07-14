
close all


%-- PARAMETERS
th = [ 0.90 0.05 ] ;             % threshold for lobe localization

% directories
sr_dir = 'C:\Users\Suki''s Lab\Desktop\DATA\lung_imaging\lung_structs\-960HU\' ;

% get individual pt names
scan_names = dir( [ sr_dir 'MD*.mat' ] ) ;
pt_id = cell( size( scan_names ) ) ;
for ii = 1:length( scan_names )
    str = strsplit( scan_names( ii ).name, '_' ) ;
    pt_id{ii} = str{1} ;
end
N     = pt_id ;
pt_id = unique( pt_id ) ; disp( pt_id )


%-- ANALYZE LOBES
z0 = zeros( length( pt_id ), 9 ) ;  % [ RU  RM  RL  LU  LL  RU-RM  RL-RM  RU-RM-RL  LU-LL ]
lobe_freq = { z0, z0, z0 } ;        % saves lobar frequency of super clusters

% loop through pt
for pt = 1:length( pt_id )
    pt_scans = dir( [ sr_dir pt_id{pt} '*.mat' ] ) ;
    pt_scans = { pt_scans.name } ;
    
    % loop through time points
    for ps = 1:length( pt_scans )
        load( [ sr_dir pt_scans{ps} ] )
        
        % loop each super cluster
        tmp  = [ lungs.sup_clust(1).lobe ; lungs.sup_clust(2).lobe ] ;
        lobe = tmp >= th(1) ;
        for nn = 1:size( lobe,1 )
            
            % save super 
            if all( ~lobe( nn,: ) )
                lobe_sc = tmp( nn,: ) >= th(2) ;
                
                if sum( lobe_sc ) == 3 ;        tmp_ind = 8 ;       % RU-RM-RL
                elseif any( lobe_sc( 4:5 ) ) ;  tmp_ind = 9 ;       % LU-LL
                elseif lobe_sc( 1 ) >0 ;        tmp_ind = 6 ;       % RU-RM
                elseif lobe_sc( 2 ) >0 ;        tmp_ind = 7 ;       % RL-RM
                else                            tmp_ind = 0 ;       % error
                    % disp( [ 'Error: no super clusters in ' pt_scans{ps} ] )
                end
                
                if tmp_ind >0 ; lobe_freq{ps}( pt, tmp_ind ) = 1 ; end
            else
                lobe_freq{ps}( pt,1:5 ) = lobe_freq{ps}( pt,1:5 ) + lobe( nn,: ) ;
            end
            
        end
    end
end


%-- LOBAR FREQUENCY
all_lungs  = logical( [ lobe_freq{1} ; lobe_freq{2} ; lobe_freq{3} ] ) ;
lobar_freq = sum( all_lungs,1 ) / sum( all_lungs(:) ) ;
lung_freq  = [ sum( lobar_freq( 1:5 ) ) sum( lobar_freq( 6:9 ) ) ...
    sum( lobar_freq( :,[ 1:3 6:8 ] ) ) sum( lobar_freq( :,[ 4 5 9 ] ) )
    ] ;
disp( 100*lobar_freq )
disp( 100*lung_freq )








% ind1R = and( all( ~all_lungs( :,6:8 ),2 ), sum( all_lungs( :,1:3 ),2 ) ==1 ) ;
% ind2R = ~ind1R ;
% ind1L = and( ~all_lungs( :,9 ), sum( all_lungs( :,4:5 ), 2 ) == 1 ) ;
% ind2L = logical( ~all_lungs( :,9 ) - ind1L ) ;
% 
% Ruml = any( [ all_lungs( ind2R,8 ) ...
%     and( all_lungs( ind2R,3 ), all_lungs( ind2R,6 ) ) ...
%     and( all_lungs( ind2R,1 ), all_lungs( ind2R,7 ) ) ], 2 ) ;
% 
% tmp2R = find( ind2R ) ; tmp2R = tmp2R( ~Ruml ) ;
% 
% Rum = any( [ all_lungs( tmp2R,6 ) and( all_lungs( tmp2R,1 ), all_lungs( tmp2R,2 ) ) ], 2 ) ;
% Rml = any( [ all_lungs( tmp2R,7 ) and( all_lungs( tmp2R,2 ), all_lungs( tmp2R,3 ) ) ], 2 ) ;
% Rul = and( all_lungs( tmp2R,1 ), all_lungs( tmp2R,3 ) ) ;
% 
% % relative frequencies
% lobar_freq = [ ...
%     sum( all_lungs( ind1R,1:3 ),1 ) ...                 %  RU, RM, RL
%     sum( all_lungs( ind1L,4:5 ),1 ) ...                 %  LU, LL
%     sum( Rum ) sum( Rml ) sum( Rul ) sum( Ruml ) ...    %  RU-RM, RM-RL, RU-RL, R-all
%     sum( all_lungs( :,9 ) ) ] ; % + sum( ind2L ) ...          %  LU-LL
% N = sum( lobar_freq ) ;
% 
% single_multiple_freq = [ sum( lobar_freq(1:5) )/2  sum( lobar_freq(6:10) )/2 ] ;
% prob_RL = [ sum( logical( sum( all_lungs(:,[ 1:3 6:8 ]),2 ) ) ) ...
%     sum( logical( sum( all_lungs(:,[ 4:5 9 ]),2 ) ) ) ] /N ;
% 
% % print results
% disp( lobar_freq )
% disp( single_multiple_freq )
% disp( prob_RL )


