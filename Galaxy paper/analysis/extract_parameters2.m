

% search directory
sr_dir = 'C:\Users\Suki''s Lab\Desktop\DATA\lung_imaging\lung_structs\-990HU\' ;

% get patient ID's
scan_names = dir( [ sr_dir 'MD' '*.mat' ] ) ;
pt_id = cell( size( scan_names ) ) ;
for ii = 1:length( scan_names )
    str = strsplit( scan_names( ii ).name, '_' ) ;
    pt_id{ii} = str{1} ;
end
pt_id    = unique( pt_id ) ; disp( pt_id )

% % patient ID to plot
% pt_id = { 'MD0023', 'MD0029', 'MD0045', 'MD0119', 'MD0150', 'MD0163' } ;

% parameters to save [ LAV  Vsc  fsc  fTLV  LAVadj  D  LAN  Df  Df* ]
len = 3*length( pt_id ) ;
LV  = zeros( len, 2 ) ;
M   = zeros( len, 18 ) ;
pts = cell( len, 1 ) ;



%%% extract
cnt = 1 ;
for nn = 1:length( pt_id )
    
    % get scans for patient
    pt_scans = dir( [ sr_dir pt_id{nn} '*.mat' ] ) ;
    pt_scans = { pt_scans.name } ;
    
    for ii = 1:length( pt_scans )
        pts{ cnt } = pt_id{nn} ;                    	% pt
        tmp   = load( [ sr_dir pt_scans{ ii } ] ) ; 	% load
        lungs = tmp.lungs ;
        LV( cnt,: ) = lungs.TLVct( 2:3 ) ;              % TLVct
        
        for jj = 1:2
            
            M( cnt,jj )    = lungs.LAV( jj+1 ) ;                    % LAV
            M( cnt,jj+8 )  = lungs.dist{1,jj}(1) ;                  % LAVadj
            M( cnt,jj+10 ) = lungs.dist{1,jj}(2) ;                  % D
            M( cnt,jj+12 ) = lungs.LAN( jj ) ;                      % LAN
            
            if isempty( lungs.sup_clust(jj).vol{1} )
                M( cnt,[ jj+2 jj+4 jj+6 jj+14 ] ) = 0 ;
            else
                M( cnt,jj+2 )  = lungs.sup_clust(jj).vol{1}(1) ;    % Vsc
                M( cnt,jj+4 )  = lungs.sup_clust(jj).vol{1}(2) ;    % fsc
                M( cnt,jj+6 )  = lungs.sup_clust(jj).vol{1}(3) ;    % fTLV
                M( cnt,jj+14 ) = -lungs.sup_clust(jj).Df{1}(1) ;    % Df
            end
            M( cnt,jj+16 )     = -lungs.sup_clust(jj).Df{3}(1) ;    % Df*
            
        end
        cnt = cnt +1 ;
    end
end

% combine parameters for single lung value
Vsc  = sum( M( :,3:4 ),2 ) ;
fsc  = sum( LV.*M( :,5:6 ),2 )./sum( LV,2 ) ;
fTLV = sum( LV.*M( :,7:8 ),2 )./sum( LV,2 ) ;


%%% save
pts2 = [ pts ; pts ] ;
M2   = [ pts2 num2cell( [ M( :,1:2:17 ) ; M( :,2:2:18 ) ] ) ] ;

warning( 'off', 'MATLAB:xlswrite:AddSheet' )
xlswrite( 'HU_thresh.xls', M2, '-990HU' ) ;
% xlswrite( 'emph_-930HU.xls', [ pts num2cell( [ Vsc fsc fTLV ] ) ], 'Sheet2' )
warning( 'on', 'MATLAB:xlswrite:AddSheet' )


