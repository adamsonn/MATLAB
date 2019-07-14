
clearvars -except s
close all
tic


ax_sel = 'sagittal' ;       %<<<< pick axis to plot


%%% LOAD
ptn = 'MD0150_03' ;
pn  = 'C:\Users\Suki''s Lab\Desktop\DATA\lung_imaging\' ;
fn1 = 'lung_structs\-960HU\' ;
if ~exist( 's', 'var' ) ;
    s = load( fullfile( pn,fn1,[ ptn '.mat' ] ) ) ;
end
plot_lung = s.lungs.plot_lung ;
sup_clust = s.lungs.sup_clust ;
sz        = s.lungs.sz ;
pntr      = s.lungs.pntr ;
lung_msk  = zeros( sz ) ;  lung_msk( pntr(:,1) ) = 1 ;
sc_msk    = zeros( sz ) ;  sc_msk( pntr( pntr(:,6)>0, 1 ) ) = 1 ;

switch ax_sel
    case 'axial'
        sl_num = 164:2:760 ;
    case 'sagittal'
        sl_num = 31:2:471 ;
    case 'coronal'
        sl_num = 92:2:388 ;
    otherwise
        disp( 'Error: Release Rinzler' ) ; return
end


%%% VIDEO PARAMS
figure( 'Color', 'k', 'InvertHardcopy', 'off' ) ; % 'Position', [ 1  581  1600  784 ],
bool_vid  = 0 ;
vdir      = 'C:\Users\Suki''s Lab\Desktop\MEDIA\Videos\' ;
vfn       = [ ptn '_' ax_sel ] ;
frm_rt    = 10 ;
if bool_vid
    F( length( sl_num ) ) = struct( 'cdata', [], 'colormap', [] ) ;
end


%%% LOOP through slices
frm = 1 ;
for sl = 382 %sl_num
    switch ax_sel
        case 'axial'
            tmp = sc_msk(:,:,sl) ;      tmpA(:,:) = tmp(:,:,1) ;
            tmp = lung_msk(:,:,sl) ;    tmpB(:,:) = tmp(:,:,1) ;
        case 'sagittal'
            tmp = sc_msk(:,sl,:) ;      tmpA(:,:) = tmp(:,1,:) ;
            tmp = lung_msk(:,sl,:) ;    tmpB(:,:) = tmp(:,1,:) ;
        case 'coronal'
            tmp = sc_msk(sl,:,:) ;      tmpA(:,:) = tmp(1,:,:) ;
            tmp = lung_msk(sl,:,:) ;    tmpB(:,:) = tmp(1,:,:) ;
    end
    
    CC = bwconncomp( tmpA, 4 ) ;
    L  = label2rgb( labelmatrix(CC), @parula, [ 0 0 0 ], 'shuffle' ) ;
    figure(1) ; imshow( L ) ; hold on
    
    [ B,~ ] = bwboundaries( tmpB ) ;
    for ii = 1:length(B)
        plot( B{ii}(:,2), B{ii}(:,1), 'w-' ) ;
    end
    F( frm ) = getframe( gcf ) ; frm = frm +1 ;
end



%%% Build MOVIE
if bool_vid
    vid = VideoWriter( fullfile( vdir, vfn ) ) ;
    vid.FrameRate = frm_rt ;

    open( vid )
    for ii = 1:length( F )
        writeVideo( vid, F(ii) )
    end
    close( vid )
end

toc
% close all


