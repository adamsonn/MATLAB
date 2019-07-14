

%-- PARAMETERS
N  = 1 ;
az = ( 0:1:360-1 ) - 90 ;
az = repmat( az, 1, N ) ;
el = 0 ;
h  = findobj( gcf, 'Type', 'Light' ) ;

bool_vid  = 0 ;
vdir      = 'C:\Users\Suki''s Lab\Desktop\Media\Videos\' ;
vfn       = 'MD0150_03_rot_mov' ;

if bool_vid
    F( length( az ) ) = struct( 'cdata', [], 'colormap', [] ) ;
end


%-- ROTATE
set( gcf, 'Color', 'w' ) ; axis vis3d
for ii = 1:length( az )
    view( [ az(ii) el ] ) ;
    delete( h ) ; h = camlight ;
    F( ii ) = getframe( gcf ) ;
end


%-- Build MOVIE
if bool_vid
    vid = VideoWriter( [ vdir vfn ] ) ;
    vid.FrameRate = 75 ;                            % 4 secs per rotation
    
    open( vid )
    for ii = 1:length( F )
        writeVideo( vid, F(ii) )
    end
    close( vid )
end