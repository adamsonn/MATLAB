
warning( 'off', 'MATLAB:xlswrite:AddSheet' )


%%% LOAD
sr_dir = 'C:\Users\Suki''s Lab\Desktop\DATA\lung_imaging\lung_structs\-960HU\' ;
fn = 'whole_lung_vol.xls' ;
scan_names = dir( fullfile( sr_dir, 'MD*.mat' ) ) ; n = 3;

% get patient ID's
pt_id = cell( size( scan_names ) ) ;
for ii = 1:length( scan_names )
    str = strsplit( scan_names( ii ).name, '_' ) ;
    pt_id{ii} = str{1} ;
end
pt_id = unique( pt_id ) ;

% parameters to save
Vsc  = zeros( length( pt_id ), n ) ;
fSC  = zeros( length( pt_id ), n ) ;
fTLV = zeros( length( pt_id ), n ) ;


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
        
        % get volumes
        Vsc_j = sum( logical( lungs.pntr(:,6) ) ) ;
        Vlav  = sum( logical( lungs.pntr(:,4) ) ) ;
        TLVct = size( lungs.pntr,1 ) ;
        
        Vsc( ii,jj )  = lungs.vox(1)* Vsc_j  ;
        fSC( ii,jj )  = Vsc_j / Vlav ;
        fTLV( ii,jj ) = Vsc_j / TLVct ;
    end
    
end

% reshape
tits = pt_id ;
tits = reshape( repmat( tits, [ 1 3 ] )', [ 3*length( tits ) 1 ] ) ;
Vsc  = reshape( Vsc', [ 3*length( pt_id ) 1 ] ) ;
fSC  = reshape( fSC', [ 3*length( pt_id ) 1 ] ) ;
fTLV = reshape( fTLV', [ 3*length( pt_id ) 1 ] ) ;


%%% SAVE
if exist( fn, 'file' ) ; delete( fn ) ; end
xlswrite( fn, [ tits num2cell( [ Vsc fSC fTLV ] ) ], 'Sheet1' )




