
function a = extract_parameters( sr_dir )
% clearvars
% close all
tic


% search directory
if nargin <1
    sr_dir = 'C:\Users\Suki''s Lab\Desktop\DATA\lung_imaging\lung_structs\-910HU\' ;
end
group  = 'COPD' ;         % 'control' or 'COPD'

switch group
    case 'control'
        mn = 'ctrl_new.mat' ;
        fn = 'ctrl_data_new.xls' ;
        scan_names = dir( fullfile( sr_dir, 'KIT*.mat' ) ) ; n = 1;
        
    case 'COPD'
        mn = 'emph_new.mat' ;
        fn = 'emph_data_new.xls' ;
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
pt_id    = unique( pt_id ) ;


% parameters to save
tmp_mat = zeros( length( pt_id ), n ) ;
TLCct = tmp_mat ;                           % total lung volume
Vr    = tmp_mat ;   Vl    = tmp_mat ;       % lung volume
SCr   = tmp_mat ;   SCl   = tmp_mat ;       % super cluster volume
LAVr  = tmp_mat ;   LAVl  = tmp_mat ;       % LAV
fLAVr = tmp_mat ;   fLAVl = tmp_mat ;       % fraction of LAV
fTLVr = tmp_mat ;   fTLVl = tmp_mat ;       % fraction of TLV

LAV2r = tmp_mat ;   LAV2l = tmp_mat ;       % adjusted LAV
D3dr  = tmp_mat ;   D3dl  = tmp_mat ;       % distribution exponent
Dfr   = tmp_mat ;   Dfl   = tmp_mat ;       % fractal dimension, super cluster
LANr  = tmp_mat ;   LANl  = tmp_mat ;       % LAN
Df2r  = tmp_mat ;   Df2l  = tmp_mat ;       % fractal dimension, non-sc


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
        
        % lung volumes
        TLCct( ii,jj ) = lungs.TLVct(1) ;
        Vr( ii,jj )    = lungs.TLVct(2) ;
        Vl( ii,jj )    = lungs.TLVct(3) ;
        
        % LAV
        LAVr( ii,jj ) = lungs.LAV(2) ;
        LAVl( ii,jj ) = lungs.LAV(3) ;
        
        % LAN
        LANr( ii,jj ) = lungs.LAN(1) ;
        LANl( ii,jj ) = lungs.LAN(2) ;
        
        % power law distribution
        LAV2r( ii,jj ) = lungs.dist{1,1}(1) ;
        LAV2l( ii,jj ) = lungs.dist{1,2}(1) ;
        D3dr( ii,jj )  = lungs.dist{1,1}(2) ;
        D3dl( ii,jj )  = lungs.dist{1,2}(2) ;
        
        
        % super cluster parameters
        if isempty( lungs.sup_clust(1).vol{1} )
            SCr( ii,jj )   = 0 ;
            fLAVr( ii,jj ) = 0 ;
            fTLVr( ii,jj ) = 0 ;
            Dfr( ii,jj )   = 0 ;
            Df2r( ii,jj )  = 0 ;
        else
            SCr( ii,jj )   = lungs.sup_clust(1).vol{1}(1) ;
            fLAVr( ii,jj ) = lungs.sup_clust(1).vol{1}(2) ;
            fTLVr( ii,jj ) = lungs.sup_clust(1).vol{1}(3) ;
            Dfr( ii,jj )   = -lungs.sup_clust(1).Df{1}(1) ;
        end
        Df2r( ii,jj ) = -lungs.sup_clust(1).Df{3}(1) ;
        
        if isempty( lungs.sup_clust(2).vol{1} )
            SCl( ii,jj )   = 0 ;
            fLAVl( ii,jj ) = 0 ;
            fTLVl( ii,jj ) = 0 ;
            Dfl( ii,jj )   = 0 ;
            Df2l( ii,jj )  = 0 ;
        else
            SCl( ii,jj )   = lungs.sup_clust(2).vol{1}(1) ;
            fLAVl( ii,jj ) = lungs.sup_clust(2).vol{1}(2) ;
            fTLVl( ii,jj ) = lungs.sup_clust(2).vol{1}(3) ;
            Dfl( ii,jj )   = -lungs.sup_clust(2).Df{1}(1) ;
        end
        Df2l( ii,jj ) = -lungs.sup_clust(2).Df{3}(1) ;
        
    end
end

% save
save( mn, 'pt_id', 'TLCct', 'Vr', 'Vl', 'SCr', 'SCl', 'LAVr', 'LAVl', ...
    'fLAVr', 'fLAVl', 'fTLVr', 'fTLVl', 'LANr', 'LANl', 'LAV2r', ...
    'LAV2l', 'D3dr', 'D3dl', 'Dfr', 'Dfl', 'Df2r', 'Df2l' )

toc


% export to xls
a = [ ...
    reshape( LAVr', [],1 ) ...           % 1
    reshape( SCr', [],1 ) ...            % 2
    reshape( fLAVr', [],1 )...           % 3
    reshape( fTLVr', [],1 ) ...          % 4
    reshape( LAV2r', [],1 ) ...          % 5
    reshape( D3dr', [],1 ) ...           % 6
    reshape( LANr', [],1 ) ...           % 8 switched
    reshape( Dfr', [],1 ) ...            % 7 ^^
    reshape( Df2r', [],1 ) ; ...         % 9
    
    reshape( LAVl', [],1 ) ...
    reshape( SCl', [],1 ) ...
    reshape( fLAVl', [],1 ) ...
    reshape( fTLVl', [],1 ) ...
    reshape( LAV2l', [],1 ) ...
    reshape( D3dl', [],1 ) ...
    reshape( LANl', [],1 ) ...
    reshape( Dfl', [],1 ) ...
    reshape( Df2l', [],1 ) ...
    ] ;

x1 = 5:5:45 ;
x2 = 0:0.1:1 ;
x3 = 1e5:5e4:6e5 ;
ind = a(:,2) >0 ;
plot_bool = 0 ;

[ p2,~ ] = lin_reg( [ a(ind,1) a(ind,2) ], 1, plot_bool ) ;
[ p3,~ ] = lin_reg( [ a(ind,1) a(ind,3) ], 1, plot_bool ) ;
[ p4,~ ] = lin_reg( [ a(ind,1) a(ind,4) ], 1, plot_bool ) ;

[ p8,~ ] = lin_reg( [ a(ind,3) a(ind,8) ], 1, plot_bool ) ;
[ p7,~ ] = lin_reg( [ a(:,7) a(:,9) ], 1, plot_bool ) ;

[ pc2,pv2 ] = corrcoef( a(ind,1), a(ind,2) ) ; disp( [ pc2 pv2 ] )
[ pc3,pv3 ] = corrcoef( a(ind,1), a(ind,3) ) ; disp( [ pc3 pv3 ] )
[ pc4,pv4 ] = corrcoef( a(ind,1), a(ind,4) ) ; disp( [ pc4 pv4 ] )

[ pc8,pv8 ] = corrcoef( a(ind,3), a(ind,8) ) ; disp( [ pc8 pv8 ] )
[ pc7,pv7 ] = corrcoef( a(:,7), a(:,9) ) ;     disp( [ pc7 pv7 ] )

y2 = polyval( p2,x1 ) ;
y3 = polyval( p3,x1 ) ;
y4 = polyval( p4,x1 ) ;

y8 = polyval( p8,x2 ) ;
y7 = polyval( p7,x3 ) ;

tits = { 'PT', 'LAV', 'SCvol', 'fLAV', 'fTLV', 'LAV*', 'D', 'Df', 'LAN', 'Df*' } ;

warning( 'off', 'MATLAB:xlswrite:AddSheet' )
xlswrite( fn, [ tits; [ my_scans my_scans ]' num2cell(a) ], 'Sheet1' )
xlswrite( fn, num2cell( [ x1' y2' y3' y4' ] ), 'Vol_Frac_Fit' )
xlswrite( fn, num2cell( [ x2' y8' ] ), 'Df_vs_fLAV' )
xlswrite( fn, num2cell( [ x3' y7' ] ), 'Df2_vs_LAN' )
warning( 'on', 'MATLAB:xlswrite:AddSheet' )




