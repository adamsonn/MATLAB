

close all
clearvars


%-- select folders for lobe mask      --CT dicom, airways mask, and otsu lung mask
sdir = 'C:\Users\Suki''s Lab\Desktop\CT_PATIENTS\' ;
%sdir = '/Users/jarredmondonedo/Documents/Suki_lab/CT' ;
qry  = { 'Select CT...', 'Select airways...', 'Select lungs...' } ;
fldr = cell( 1, numel( qry ) ) ;
for ii = 1 : numel( qry )
    fldr_i = uigetdir( sdir, qry{ ii } ) ;
    if isequal( fldr_i, 0 ) ; return ; end              % stop if 'cancel'
    fldr{ ii } = fldr_i ;
end


%-- read in each dicom folder
wbl = { 'Reading CT...', 'Reading Airways...', 'Reading lungs...' } ;
out = cell( 1, numel( qry ) ) ;
for msk_num = 1 : numel( qry )
    
    fns = dir( fldr{ msk_num } ) ;                      % get filenames
    fns = { fns.name }' ; fns( 1:2,: ) = [] ;
    msk = zeros( 512,512,numel( fns ) ) ;               % collects extracted data
    
    wb = waitbar( 0, wbl{ msk_num } ) ;                 % begin to read in dicom
    for slice_num = 1:numel( fns )                      % loop through slices
        tmp       = dicominfo( [ fldr{ msk_num } filesep fns{ slice_num } ] ) ;
        slice_HU  = dicomread( tmp ) * tmp.RescaleSlope + tmp.RescaleIntercept ;    % convert to HU
        msk( :,:,slice_num ) = slice_HU ;
        waitbar( slice_num / numel( fns ) ) ;
    end
    
    out{ msk_num } = msk ;                              % save each dicom output
    close( wb )
end


%-- ADD to existing structure
% sv_dir     = 'C:\Users\Suki''s Lab\Desktop\DATA\lung_imaging\scans\' ;
% pn         = strsplit( fldr_i, '\' ) ;
% s          = load( [ sv_dir 'old\' pn{ end } '.mat' ] ) ;
% lung_3D    = s.lung_3D ;
% lung_3D{5} = out{1} ;

% save
% save( [ sv_dir pn{ end } '.mat' ], 'lung_3D', '-v7.3' )


%-- BUILD struct
% run_master_single


%-- use lungs and airway masks to segment CT data
wb = waitbar( 0, 'Saving data...' ) ;
out{ 4 } = out{1} .* ~out{2} .* out{3} ;                % segmented lung
lung_3D  = out ;


%-- save data
fldr_name = strsplit( fldr{1}, '\' ) ; % [ ~, fldr_name, ~ ] = fileparts( fldr{ 1 } ) ;
sfn = [ 'C:\Users\Suki''s Lab\Desktop\' fldr_name{ end-1 } '.mat' ] ; % '_lung_3D.mat' ] ;
save( sfn, 'lung_3D', '-v7.3' )
close( wb )


