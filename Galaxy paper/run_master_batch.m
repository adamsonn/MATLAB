

% search directory
sr_dir = 'C:\Users\Suki''s Lab\Desktop\DATA\lung_imaging\scans\' ;

% save directory
sv_dir = 'C:\Users\Suki''s Lab\Desktop\DATA\lung_imaging\lung_structs\' ;

% get patient ID's
scan_names = dir( [ sr_dir 'KIT' '*.mat' ] ) ;
pt_id = cell( size( scan_names ) ) ;
for ii = 1:length( scan_names )
    str = strsplit( scan_names( ii ).name, '_' ) ;
    pt_id{ii} = str{1} ;
end
pt_id    = unique( pt_id ) ;
tot_scan = length( scan_names ) ;
cur_scan = 1 ;


wb = waitbar( 0 ) ; tic
for pt_num = 1:length( pt_id )
    
    % get scans for each patient
    pt_scans = dir( [ sr_dir pt_id{pt_num} '*.mat' ] ) ;
    pt_scans = { pt_scans.name } ;
    fprintf( [ pt_id{ pt_num } '\n' ] )
    
    for scan_num = 1:length( pt_scans )
        waitbar( (cur_scan-1)/tot_scan, wb, ...     % update waitbar
            sprintf( 'Scan %d of %d...', cur_scan, tot_scan ) )
        
        fprintf( '\n\tLoading DICOM...' )           % load processed DICOM data
        lung = load( [ sr_dir pt_scans{scan_num} ] ) ;
        s    = lung.lung_3D ;
        fprintf( 'Complete.\n\n' )
        
        lungs = divide_LR( s ) ; clear s lung       % load CT and divide into L/R
        lungs = analyze_clusters( lungs ) ;         % get LAV distributions
        lungs = analyze_super_clust( lungs ) ;      % analyze individual super clusters
        % lungs = render_sup_clust( lungs ) ;         % get plotting parameters
        
        proj_time = ( 1/60 )*( toc/cur_scan )*( tot_scan-cur_scan ) ;
        fprintf( 'Estimated time remaining: %.2f mins\n', proj_time )
        
        cur_scan = cur_scan +1 ;                            % update current scan
        save( [ sv_dir pt_scans{ scan_num } ], 'lungs' )    % save scan
        
    end
end
close( wb )
fprintf( '\n\t\tFINISHED!!  Total run time = %.2f mins\n', toc/60 )
clearvars