
tic
clearvars
close all

%%% PARAMS
pn    = 'C:\Users\Suki''s Lab\Desktop\DATA\lung_imaging\lung_structs\-960HU' ;
fn    = 'MD0119_01.mat' ;
nbins = 50 ;

%%% LOAD
s    = load( fullfile( pn,fn ) ) ;
sz   = s.lungs.sz ;
pntr = s.lungs.pntr ;

% get cluster sizes
LAA_L = cell( sz(3),1 ) ;   sc_L = zeros( sz ) ;
LAA_R = cell( sz(3),1 ) ;   sc_R = zeros( sz ) ;

sc_L( pntr( and( pntr(:,3)==1, pntr(:,6)>0 ), 1 ) ) = 1 ;
sc_R( pntr( and( pntr(:,3)==2, pntr(:,6)>0 ), 1 ) ) = 1 ;

for sl = 1:sz(3)
    CC = bwconncomp( sc_L(:,:,sl), 4 ) ;
    cl_ind = CC.PixelIdxList ;
    LAA_L{ sl } = cellfun( @numel, cl_ind ) ;
    
    CC = bwconncomp( sc_R(:,:,sl), 4 ) ;
    cl_ind = CC.PixelIdxList ;
    LAA_R{ sl } = cellfun( @numel, cl_ind ) ;
end
LAAs{1} = [ LAA_L{:} LAA_R{:} ] ;
% LAAs{1} = [ LAA_L{:} ] ;
% LAAs{2} = [ LAA_R{:} ] ;


%%% POWER LAW distribution
for ll = 1:length( LAAs )
    bins  = logspace( 0, ceil( log10( max( LAAs{ll} ) ) ), nbins+1 ) ;
    binc  = 0.5*( bins( 1:end-1 ) + bins( 2:end ) ) ;
    count = histc( LAAs{ll}, bins ) ;
    count = count( 1:end-1 ) ;
    X     = binc( count >0 ) ;
    Y     = fliplr( cumsum( fliplr( count( count >0 ) ) ) ) ;
    
    % fit and plot
    [ p,R2 ] = lin_reg( log10( [ X;Y ]' ), 1, 1 ) ;
    disp( [ p R2 ] )
end




% Yfit     = 10^p(2) * X.^p(1) ;
% out1 = [ X; Y; Yfit ]' ;
% out2 = [ p R2 cl_N ] ;
toc