

%-- PARAMETERS
pt_id  = { 'MD0018', 'MD0020' } ; % 'MD0006', 'MD0008', 'MD0023', 'MD0029', 'MD0045', 'MD0119', 'MD0136', 'MD0150', 'MD0163' } ;
sr_dir = 'C:\Users\Suki''s Lab\Desktop\DATA\lung_imaging\lung_structs\-960HU\' ;


%-- LOOP each patient
for nn = 1:length( pt_id )
    
    % get patient scans
    pt_scans = dir( [ sr_dir pt_id{nn} '*.mat' ] ) ;
    pt_scans = { pt_scans.name } ;
    
    % model params
    seed_perc = .02 : .01 : .08 ;
    
    
    %-- BEGIN SIMULATION
    for ii = 1:length( pt_scans )                   % scan time points
        s = load( [ sr_dir pt_scans{ii} ] ) ;
        lungs = s.lungs ;
        stats( ii ).name = pt_scans{ii} ; %#ok<*SAGROW>
        disp( [ pt_scans{ii} '  ' datestr(now) ] )
        
        for jj = 1:2 ;                              % lung 1,2
            
            % inititalize
            pforce    = zeros( length( seed_perc ), 10 ) ;
            pntr_tmp  = cell( length( seed_perc ),1 ) ;
            
            if ~isempty( lungs.sup_clust(jj).lobe )
                % force
                for kk = 1:length( seed_perc )      % seed perc
                    [ out, pntr0 ] = simulate_emphysema_subf( ...
                        lungs, jj, seed_perc( kk ), 'force', [] ) ;
                    pforce( kk,: ) = out{1} ;
                    pntr_tmp{ kk } = pntr0 ;
                end
                
                % rand
                [ ~,ind ] = min( pforce( :,2 ) ) ;
                [ out,~ ] = simulate_emphysema_subf( ...
                    lungs, jj, seed_perc( ind ), 'rand', pntr_tmp{ ind } ) ;
            else
                % no super cluster
                ind = 1 ;
                out{1} = [] ;
                out{2} = [] ;
            end
            
            % save
            stats( ii ).lung( jj ).p_all  = pforce ;
            stats( ii ).lung( jj ).pforce = pforce( ind,: ) ;
            stats( ii ).lung( jj ).prand  = out{1} ;
            stats( ii ).lung( jj ).plung  = out{2} ;
            
        end
        
        disp( [ pt_scans{ii} '  ' datestr(now) ] )
    end
    
    save( [ pt_id{nn} '_model.mat' ], 'stats' )
end