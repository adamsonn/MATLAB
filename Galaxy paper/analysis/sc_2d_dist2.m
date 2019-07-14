
tic
clearvars
close all


%%% PARAMS
%pn     = 'C:\Users\Suki''s Lab\Desktop\DATA\lung_imaging\lung_structs\-960HU' ;
pn     = 'E:\Jarred\04_DATA\lung_imaging\lung_structs\-960HU' ;
fn     = 'MD0119_02.mat' ;
nbins  = 50 ;
ax_sel = 'sagittal' ;       %<<<< pick axis to plot


%%% LOAD
s      = load( fullfile( pn,fn ) ) ;
sz     = s.lungs.sz ;
pntr   = s.lungs.pntr ;
sc_msk = zeros( sz ) ;
sc_msk( pntr( pntr(:,6)>0, 1 ) ) = 1 ;

switch ax_sel
    case 'axial'
        sl_num = 1:sz(3)  ;
    case 'sagittal'
        sl_num = 1:sz(2) ;
    case 'coronal'
        sl_num = 1:sz(1) ;
    otherwise
        disp( 'Error: Release Rinzler' ) ; return
end


%%% Get cluster sizes
LAAs = [] ;
for sl = sl_num
    switch ax_sel
        case 'axial'
            tmp = sc_msk(:,:,sl) ;      tmpA(:,:) = tmp(:,:,1) ;
        case 'sagittal'
            tmp = sc_msk(:,sl,:) ;      tmpA(:,:) = tmp(:,1,:) ;
        case 'coronal'
            tmp = sc_msk(sl,:,:) ;      tmpA(:,:) = tmp(1,:,:) ;
    end
    
    CC = bwconncomp( tmpA, 4 ) ;
    cl_ind = CC.PixelIdxList ;
    LAAs = [ LAAs  cellfun( @numel, cl_ind ) ] ; %#ok<AGROW>
end

imshow(tmpA);
j_a=0;
%%% POWER LAW distribution
if j_a
bins  = logspace( 0, ceil( log10( max( LAAs ) ) ), nbins+1 ) ;
binc  = 0.5*( bins( 1:end-1 ) + bins( 2:end ) ) ;
count = histc( LAAs, bins ) ;
count = count( 1:end-1 ) ;
X     = binc( count >0 ) ;
Y     = fliplr( cumsum( fliplr( count( count >0 ) ) ) ) ;

% fit and plot
[ p,R2 ] = lin_reg( log10( [ X;Y ]' ), 1, 1 ) ;
disp( [ p R2 ] )
disp( length( LAAs ) )
end

% Yfit     = 10^p(2) * X.^p(1) ;
% out1 = [ X; Y; Yfit ]' ;
% out2 = [ p R2 cl_N ] ;
toc