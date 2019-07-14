
close all

%%% load processed DICOM data
fprintf( '\n\tLoading DICOM...' )

% sdir  = 'C:\Users\Suki''s Lab\Desktop\DATA\lung_imaging\scans\' ;
% svdir = 'C:\Users\Suki''s Lab\Desktop\DATA\lung_imaging\lung_structs\new\' ;
% [ fn, sdir ] = uigetfile( [ sdir '*.*' ] ) ;
% if isequal( fn, 0 ) ; fprintf( 'Quit.\n' ) ; return ; end
% lung = load( fullfile( pn,fn ) ) ;

lung = load( fullfile( sdir, fn ) ) ;
s    = lung.lung_3D ;

fprintf( 'Complete.\n' )
% s  = lung_3D ;
% fn = pn{ end } ;

%%% --important-- define voxel size and threshold
% vsz = [ .683 .683 .500 ] ;                       % voxel dimensions (mm)
% emph_th = -990 ;                                 % emphysema threshold

%%% load CT and divide into L/R
tic
lungs = divide_LR( s, vsz, emph_th ) ;
toc
clear s         % clearvars -except lungs svdir fn

%%% get LAV distributions
tic
lungs = analyze_clusters( lungs ) ;
toc

%%% analyze individual super clusters
tic
lungs = analyze_super_clust( lungs ) ;
toc

% %%% save plot parameters
% tic
% lungs = render_sup_clust( lungs, 1 ) ;
% toc

%%% save lung struct
save( fullfile( svdir, fn ), 'lungs' )


% close all