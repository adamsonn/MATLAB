
close all
clearvars -except lungs lung_3D

%-- PARAMETERS
pntr    = lungs.pntr ;                      % lung pointer matrix
sz      = lungs.sz ;                        % scan size
imsz    = [ 512 512 ] ;                     % slice size
sl_num  = [ 170 755 ] ;                     % slice number start / end

% video
bool_vid  = 1 ;
vdir      = 'C:\Users\Suki''s Lab\Desktop\Media\Videos\' ;
vfn       = 'MD0150_03_masks' ;
frm_rt    = 100 ;
if bool_vid
    F( length( sl_num:sz(3) ) ) = struct( 'cdata', [], 'colormap', [] ) ;
end

% masks
lung_ct  = lung_3D{1} ;                     % original CT
arwy_msk = lung_3D{2} ;                     % airway mask
lung_msk = zeros( sz ) ;                    % lung mask
lung_msk( pntr(:,1) ) = 1 ;
emph_msk = zeros( sz ) ;                    % emphysema msk
emph_msk( pntr( pntr(:,4) ==1, 1 ) ) = 1 ;

% get right / left lung
ind_L   = pntr( pntr(:,3) ==1, 1 ) ;
lungs_L = zeros( sz ) ;                 lungs_L( ind_L ) = 1 ;
ind_R   = pntr( pntr(:,3) ==2, 1 ) ;
lungs_R = zeros( sz ) ;                 lungs_R( ind_R ) = 1 ;

% overlay colors
col_em  = cat( 3, ones( imsz ), zeros( imsz ), zeros( imsz ) ) ;
col_bd  = cat( 3, zeros( imsz ), ones( imsz ), ones( imsz ) ) ;


%-- PLOT
figure() ; set( gcf, 'Position', [ 680   210   490   826 ], 'Color', 'w' )
for sl = sl_num(1):sl_num(2)
    subplot( 3,2,1:4 ) ; imshow( lung_ct( :,:,sl ) ) ; hold on
    h1 = imshow( col_em ) ; set( h1, 'AlphaData', .5*emph_msk( :,:,sl ) ) ;
    h2 = imshow( col_bd ) ; set( h2, 'AlphaData', bwperim( lung_msk( :,:,sl ) ) ) ;
    text( 25,25, 'Emphysema', 'Color', 'r', 'FontSize', 12 )
    set( gca, 'Clim', [ -1024 1024 ] )
    title( 'Original CT', 'FontSize', 14 ) ; hold off
    
    subplot( 3,2,5 ) ; imshow( lungs_R( :,:,sl ) )
    title( 'Right lung', 'FontSize', 14 )
    
    subplot( 3,2,6 ) ; imshow( lungs_L( :,:,sl ) )
    title( 'Left lung', 'FontSize', 14 )
    
    F( sl ) = getframe( gcf ) ;
end


% figure() ; set( gcf, 'Position', [ 881  49  1471  826 ], 'Color', 'w' )
% for sl = sl_num(1):sl_num(2)
%     subplot( 2,2,1 ) ; imshow( lung_ct( :,:,sl ) )
%     set( gca, 'Clim', [ -1024 1024 ] )
%     title( 'Original CT', 'FontSize', 14 )
%     
%     subplot( 2,2,3 ) ; imshow( lungs_R( :,:,sl ) )
%     title( 'Right lung', 'FontSize', 14 )
%     
%     subplot( 2,2,4 ) ; imshow( lungs_L( :,:,sl ) )
%     title( 'Left lung', 'FontSize', 14 )
%     
%     subplot( 2,2,2 ) ; imshow( lung_msk( :,:,sl ) ) ; hold on
%     h1 = imshow( col_em ) ; set( h1, 'AlphaData', emph_msk( :,:,sl ) ) ;
%     % h1 = imshow( col_aw ) ; set( h1, 'AlphaData', arwy_msk( :,:,sl ) ) ;
%     text( 25,25, 'Normal', 'Color', 'w', 'FontSize', 12 )
%     text( 25,50, 'Emphysema', 'Color', 'r', 'FontSize', 12 )
%     %text( 25,75, 'Airways', 'Color', 'b', 'FontSize', 12 )
%     title( 'Threshold', 'FontSize', 14 ) ; hold off
%     
%     F( sl ) = getframe( gcf ) ;
% end


%-- Build MOVIE
if bool_vid
    vid = VideoWriter( [ vdir vfn ] ) ;
    vid.FrameRate = frm_rt ;
    
    open( vid )
    for ii = sl_num(1):sl_num(2)
        writeVideo( vid, F(ii) )
    end
    close( vid )
end


