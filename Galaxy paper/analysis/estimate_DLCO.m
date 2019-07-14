
warning( 'off', 'MATLAB:xlswrite:AddSheet' )


%%% LOAD
sr_dir = 'C:\Users\Suki''s Lab\Desktop\DATA\lung_imaging\lung_structs\-960HU\' ;
group  = 'control' ;         % 'control' or 'COPD'

switch group
    case 'control'
        mn = 'DLCO_ctrl.mat' ;
        fn = 'DLCO_ctrl.xls' ;
        scan_names = dir( fullfile( sr_dir, 'KIT*.mat' ) ) ; n = 1;
        
    case 'COPD'
        mn = 'DLCO_emph.mat' ;
        fn = 'DLCO_emph.xls' ;
        scan_names = dir( fullfile( sr_dir, 'MD*.mat' ) ) ; n = 3;
        
    otherwise
        return
end

if exist( mn, 'file' ) ; delete( mn ) ; end
if exist( fn, 'file' ) ; delete( fn ) ; end


% get patient ID's
pt_id = cell( size( scan_names ) ) ;
for ii = 1:length( scan_names )
    str = strsplit( scan_names( ii ).name, '_' ) ;
    pt_id{ii} = str{1} ;
end
pt_id = unique( pt_id ) ;

% parameters to save
SAvox  = zeros( length( pt_id ), n ) ;
SAnorm = zeros( length( pt_id ), n ) ;


%%% SURFACE AREA
my_scans = [] ;
for ii = 1:length( pt_id )
    % get scans for patient
    pt_scans = dir( fullfile( sr_dir, [ pt_id{ii} '*.mat' ] ) ) ;
    pt_scans = { pt_scans.name } ; disp( pt_scans )
    my_scans = [ my_scans pt_scans ] ; %#ok<*AGROW>
    
    for jj = 1:length( pt_scans )
        % load processed .mat file
        tmp   = load( fullfile( sr_dir, [ pt_scans{ jj } ] ) ) ;
        lungs = tmp.lungs ;
        
        % get healthy lung voxels
        SAvox( ii,jj )  = sum( ~lungs.pntr(:,4) ) ;
        SAnorm( ii,jj ) = sum( ~lungs.pntr(:,4) ) / size( lungs.pntr,1 ) ;
    end
    
end

% reshape
tits = pt_id ;
if strcmp( group, 'COPD' )
    tits   = reshape( repmat( tits, [ 1 3 ] )', [ 3*length( tits ) 1 ] ) ;
    SAvox  = reshape( SAvox', [ 3*length( pt_id ) 1 ] ) ;
    SAnorm = reshape( SAvox', [ 3*length( pt_id ) 1 ] ) ;
end


%%% SAVE
if exist( fn, 'file' ) ; delete( mn ) ; end
xlswrite( fn, [ tits num2cell( SAvox ) num2cell( SAnorm ) ], 'Sheet1' )




