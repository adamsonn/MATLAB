
% clearvars
close all


vid_opt = 'both' ;        % <<<< Select which video to  make [ 2D  3D  both ]


tic
%%% LOAD
pn  = 'C:\Users\Suki''s Lab\Desktop\DATA\lung_imaging\' ; % '/Users/jarredmondonedo/Pictures/Suki Lab' ;
fn1 = 'lung_structs\-960HU\MD0150_03.mat' ;
fn2 = 'scans\MD0150_03.mat' ;
if ~exist( 's', 'var' ) ;
    s = load( fullfile( pn,fn1 ) ) ;
end

% s = load( fullfile( pn,fn2 ) ) ;
% dcm = s.lung_3D{1} ;

plot_lung = s.lungs.plot_lung ;
sup_clust = s.lungs.sup_clust ;
sz        = s.lungs.sz ;
pntr      = s.lungs.pntr ;
lung_msk  = zeros( sz ) ;  lung_msk( pntr(:,1) ) = 1 ;
sc_msk    = zeros( sz ) ;  sc_msk( pntr( pntr(:,6)>0, 1 ) ) = 1 ;
sl_num    = [ 164  759 ] ; % size( sc_msk,3 ) ] ;




%%% VIDEO PARAMS
figure( 'Position', [ 1289  49  1264  1308 ], 'Color', 'k', 'InvertHardcopy', 'off' ) % [ 80  160  1200  1000 ]
bool_vid  = 1 ;
vdir      = 'C:\Users\Suki''s Lab\Desktop\MEDIA\Videos\' ; % '/Users/jarredmondonedo/Desktop' ;
vfn       = 'MD0150_03_sc_vertbar' ;
frm_rt    = 60 ;
if bool_vid
    F( length( sl_num(1):sl_num(2) ) ) = struct( 'cdata', [], 'colormap', [] ) ;
end
N  = 2 ;
az = linspace( 0-90, 360-1-90, round( length( sl_num(1):sl_num(2) ) )/N ) ;   % ( 0:1:360-1 ) - 90 ;
az = repmat( az, 1, N ) ;
el = 0 ;
h  = findobj( gcf, 'Type', 'Light' ) ;



switch vid_opt
    case 'both'
        hax1 = axes( 'Position', [ 0.05 0.05 0.85 0.85 ] ) ;
        hax2 = axes( 'Position', [ 0.65 0.69 0.3 0.25 ] ) ;
        
        %%% 3D LUNGS
        axes( hax2 )
        for nn = 1:2
            % lungs
            kx = plot_lung{nn} ;
            x1 = kx{2}(:,1) ;   x2 = kx{2}(:,2) ;   x3 = kx{2}(:,3) ;
            trisurf( kx{1}, x1, x2, x3, 192*ones( size(x1) ), 'FaceAlpha', 0.3 )
            hold on
            
            % clusters
            for cl = 1:length( sup_clust(nn).rho )
                kc = sup_clust(nn).plot_clust{cl} ;
                c1 = kc{2}(:,1) ;   c2 = kc{2}(:,2) ;   c3 = kc{2}(:,3) ;
                trisurf( kc{1}, c1, c2, c3, 64*ones( size(c1) ), 'FaceAlpha', 0.3 )
            end
        end
        % formatting
        [ ii,jj,kk ] = ind2sub( sz, pntr(:,1) ) ;
        C  = round( mean( [ ii jj kk ] ) ) ; sp = 400 ;
        axis( [ C(1)-sp, C(1)+sp, C(2)-sp, C(2)+sp, C(3)-sp, C(3)+sp ] )
        grid off ; set( gca, 'Color', 'w', 'XTick', [], 'XTickLabel', [],...
            'YTick', [], 'YTickLabel', [], 'ZTick', [], 'ZTickLabel', [], ...
            'ZDir', 'Reverse', 'YDir', 'Reverse' ) ;
        view( -90,5 ) ; shading interp ; colormap copper ; camlight( 'headlight' )
        h  = findobj( gcf, 'Type', 'Light' ) ;
        axis vis3d
        
        
        %%% LOOP through slices
        frm = 1 ;
        for sl = 500 ; % sl_num(1):sl_num(2)
            axes( hax1 ) %#ok<*LAXES>
            CC = bwconncomp( sc_msk(:,:,sl), 4 ) ;
            L  = label2rgb( labelmatrix(CC), @parula, [ 0 0 0 ], 'shuffle' ) ;
            imshow( L ) ; hold on
            [ B,~ ] = bwboundaries( lung_msk(:,:,sl) ) ;
            for ii = 1:length(B)
                plot( B{ii}(:,2), B{ii}(:,1), 'w-' ) ;
            end
            
            axes( hax2 )
            [ x,y ] = meshgrid( 1:size( sc_msk,1 ) ) ;
            z = sl + zeros( size( x,1 ) ) ;
            if exist( 'p', 'var' ) ; delete( p ) ; end
            p = surf( x, y, z, 'LineWidth', 2, 'EdgeColor', 'b' ) ; 
%             % view( [ az( frm ) el ] ) ;
            colormap copper
            delete( h ) ; h = camlight( 'headlight' ) ;
            
            F( frm ) = getframe( gcf ) ; frm = frm +1 ;
        end
        
    case '2D'
        
        %%% LOOP through slices
        frm = 1 ;
        for sl = sl_num(1):sl_num(2)
            CC = bwconncomp( sc_msk(:,:,sl), 4 ) ;
            L  = label2rgb( labelmatrix(CC), @parula, [ 0 0 0 ], 'shuffle' ) ;
            figure(1) ; imshow( L ) ; hold on
            [ B,~ ] = bwboundaries( lung_msk(:,:,sl) ) ;
            for ii = 1:length(B)
                plot( B{ii}(:,2), B{ii}(:,1), 'w-' ) ;
            end
            F( frm ) = getframe( gcf ) ; frm = frm +1 ;
        end
        
    case '3D'
        
        
    otherwise
        return
end


% %%% Build MOVIE
% if bool_vid
%     vid = VideoWriter( fullfile( vdir, vfn ) ) ;
%     vid.FrameRate = frm_rt ;
%     
%     open( vid )
%     for ii = 1:length( F )
%         writeVideo( vid, F(ii) )
%     end
%     close( vid )
% end
toc



