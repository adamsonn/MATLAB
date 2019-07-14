
close all
clearvars -except lungs
% tic

if ~exist( 'lungs', 'var' )
    % load('/Users/jarredmondonedo/Documents/Suki_lab/CT/lung_structs/MD0119_01.mat')
    load('C:\Users\Suki''s Lab\Desktop\DATA\lung_imaging\lung_structs\MD0150_01.mat')
end

%%% unpack lungs structure
nn    = 1 ;                         % select lung
sz   = lungs.sz ;                   % size of matrix
pntr = lungs.pntr ;                 % [ ind  HUct  L/R  emph?  clust#  sc#  lobe ]
vsf  = lungs.vox(1) ;              	% scaling factor for voxel in L
LAV  = lungs.LAV(nn+1) ;            % total LAV of lung

%%% model parameters
seed_perc = .050 ;                  % percentage - initial
step_perc = .010 ;                  % percentage - step
fperc     = 1.00 ;                  % fraction of force based failure
rperc     = 1-fperc ;               % fraction of random failure
sigma     = 2.00 ;                  % SD of Gaussian kernel
filt_sz   = 3 ;                     % filter size representing penumbra
prog_type = 'rand' ;               % select 'rand' or 'force'

switch prog_type                    % max LAV to end simulation
    case 'rand' ;   max_perc = .30 ;
    case 'force' ;  max_perc = .01*round( LAV,1 ) ;
end

%%% parameters
nbins = 70 ;                        % number of bins for distribution
conn  = 6 ;                         % connectivity
sr_th = 0.5 ;                       % outlier threshold

%%% movie specs
bool_vid  = 0 ;
vdir      = 'C:\Users\Suki''s Lab\Desktop\Media\Videos\' ;
vfn       = 'model_projections' ;


%-- SEED emphysema in healthy lung based on known final lobar percentage
lung_ind = pntr( pntr(:,3) ==nn, 1 ) ;              % lung indices
lung3D   = zeros( sz ) ; lung3D( lung_ind ) = 1 ;   % rebuild lung mask
num_lung = length( lung_ind ) ;                     % number in lung
num_seed = round( seed_perc*num_lung ) ;            % number to change in lobe

emph_ind = pntr( and( pntr(:,3) ==nn, pntr(:,4) ), 1 ) ;    % emphysema index for lung
seed3D   = zeros( sz ) ; seed3D( emph_ind ) = 1 ;           % rebuild emphysema
seed3D   = lung3D.*imgaussfilt3( seed3D, ...                % smooth to get relative risk
    sigma, 'FilterSize', filt_sz ) ;

seed_ind = find( seed3D >0 ) ;
r        = rand( size( seed_ind ) ) ;               % random vector of thresholds
seed_val = seed3D( seed_ind ) / max( seed3D(:) ) ;
LAV_ind  = seed_ind( seed_val > r ) ;               % supra-threshold LAV indices

if length( LAV_ind ) > num_seed                     % select LAV seed indices
    LAV_ind = LAV_ind( randperm( length( LAV_ind ), num_seed ) ) ;
else
    disp( 'Error: seed percentage too large' )
    return
end
emph3D = zeros( sz ) ; emph3D( LAV_ind ) = 1 ;      % seeded emphysema mask

pntr2        = zeros( num_lung,2 ) ;                % new pointer matrix
pntr2( :,1 ) = lung_ind ;
pntr2( :,2 ) = emph3D( pntr2(:,1) ) ;

LAV_step = unique( [ seed_perc : step_perc : max_perc max_perc ] ) ;    % LAV at each step
num_step = length( LAV_step )-1 ;                   % number of steps to simulate
num_emph = round( diff( LAV_step )*num_lung ) ;     % num to change each step

N = ceil( 100*( max_perc - seed_perc ) ) ;
if N > 25
    rows = ceil( N/5 ) ;
else
    rows = 5 ;
end

% movie
if bool_vid
    F( num_step+1 ) = struct( 'cdata', [], 'colormap', [] ) ;
    F( 1 ) = plot_projections_2( lungs, emph3D, nn, 100*LAV_step(1) ) ;
end


%%% begin simulation %%%
stats = zeros( round( num_step ),7 ) ;            	% collects data for each step
LAN   = zeros( round( num_step ),1 ) ;            	% number of clusters
dist  = {} ;                                        % save distribution plots
wb = waitbar( 0, sprintf( 'Running lung %d', nn ), 'Position', [ 1567 812 270 56 ] ) ;
figure( nn ) ; set( gcf,'Position', [ 9 49 1900 1300 ] ) ; cnt = 1 ;

for ii = 1:num_step
    
    %-- SIMULATE emphysema progression
    risk_ind = pntr2( ~pntr2(:,2), 1 ) ;                            % remaining healthy tissue
    switch prog_type
        case 'rand'
            ind_chng = randperm( length( risk_ind ), num_emph(ii) ) ;   % change healthy to emphysema
            LAV_ind  = risk_ind( ind_chng ) ;                           % new LAV indices
            
        case 'force'
            risk_ind = pntr2( ~pntr2(:,2), 1 ) ;                    % remaining healthy tissue
            emph_pen = imgaussfilt3( emph3D, sigma, ...
                'FilterSize', filt_sz ) ;                           % generate penumbra
            emph_pen = emph_pen / max( emph_pen( risk_ind ) ) ;     % normalize to 1
            risk_rel = emph_pen( risk_ind ) ;                       % relative risk for emphysema
            r        = rand( size( risk_ind ) ) ;                   % random vector of thresholds
            risk_LAV = risk_ind( risk_rel > r ) ;                   % supra-threshold voxels
            rand_LAV = risk_ind( risk_rel <= r ) ;                  % sub-threshold voxels
            
            len1 = length( risk_LAV ) ;
            len2 = length( rand_LAV ) ;
            if num_emph(ii) < len1
                Nrand     = round( rperc*num_emph(ii) ) ;
                Nforce    = round( fperc*num_emph(ii) ) ;
                ind_rand  = randperm( len2, Nrand ) ;               % baseline change to emphysema
                ind_force = randperm( len1, Nforce ) ;              % force driven change to emphysema
                LAV_ind   = [ rand_LAV( ind_rand ) ; ...
                    risk_LAV( ind_force ) ] ;                       % new LAV indices
            else
                ind_chng = risk_ind( risk_rel <= r ) ;              % add random if not enough forces
                ind_chng = randperm( length( ind_chng ), num_emph(ii) - len1 ) ;
                LAV_ind  = [ risk_LAV ; ind_chng' ] ;
                disp( 'Added random emphysema changes' )
            end
            
        otherwise
            return
    end
    emph3D( LAV_ind ) = 1 ;                         % add new LAV voxels
    pntr2( :,2 ) = emph3D( pntr2(:,1) ) ;           % update pointer matrix
    
    
    %-- POWER LAW distribution
    CC      = bwconncomp( emph3D, conn ) ;          % find clusters
    LAVi    = CC.PixelIdxList ;                     % LAV indices
    LAVc    = cellfun( @numel, LAVi ) ;             % LAV cluster sizes
    LAN(ii) = length( LAVc ) ;                      % number of LAV clusters
    
    LAVdist = calc_dist( LAVc, num_lung, nbins, sr_th, vsf ) ;
    X0 = LAVdist{2}(:,1) ;      X    = LAVdist{3}(:,1) ;
    Y0 = LAVdist{2}(:,2) ;      Yfit = LAVdist{3}(:,3) ;
    
    stats( ii,: ) = LAVdist{ 1 } ;                  % save output data
    
    
    %-- PLOT
    LAVi = 100*sum( emph3D(:) )/num_lung ;
    if abs( LAVi-round(LAVi) ) < 100*0.8*step_perc || ii == num_step
        figure( nn ) ; subplot( rows,5,cnt ) ;
        loglog( X0, Y0, 'bo' ) ; hold on ; loglog( X, Yfit, 'r--' )
        loglog( X0( length(X)+1:end ), Y0( length(X)+1:end ), 'c*' )
        title( sprintf( 'Percent = %.1f', LAVi ) )
        xlabel( 'Cluster Size (#vox)' ) ; ylabel( 'Cum # of clusters' )
        xlim( [ 1 1e7 ] ) ; ylim( [ 1 1e7 ] )
        
        dist{ cnt } = { LAVi, [ X0 Y0 ], [ X Yfit ] } ;   %#ok<SAGROW>
        cnt = cnt +1 ;
    end
    waitbar( ii / num_step )
    
    % movie
    if bool_vid
        F( ii+1 ) = plot_projections_2( lungs, emph3D, nn, 100*LAV_step(ii+1) ) ;
    end
    
end
close( wb )


%%% BUILD MOVIE
if bool_vid
    F( end+1:end+16 ) = F(end) ;
    vid = VideoWriter( [ vdir vfn ] ) ;
    vid.FrameRate = 8 ;
    
    open( vid )
    for ii = 1:length( F )
        writeVideo( vid, F(ii) )
    end
    close( vid )
end


%-- ERROR
a = [ stats(end,6) stats(end,3) LAN(end) ] ;
b = [ lungs.sup_clust(nn).vol{1}(2) lungs.dist{1,nn}(2) lungs.LAN(nn) ] ;
wgt     = [ .6 .2 .2 ] ;      % [ f_LAV  D  LAN ]
wgt_err = wgt .* abs( (a-b)./b ) ;


%-- SAVE
p.seed_perc = seed_perc ;
p.step_perc = step_perc ;
p.fperc     = fperc ;
p.rperc     = rperc ;
p.max_perc  = max_perc ;
p.sigma     = sigma ;
p.filt_sz   = filt_sz ;
p.prog_type = prog_type ;

p.nbins = nbins ;
p.conn  = conn ;
p.sr_th = sr_th ;

save stats.mat stats p LAN dist wgt_err


%-- PLOT results
plot_sim_results
disp( seed_perc )
disp( stats(end,:) )
disp( [ lungs.LAV(nn+1)  lungs.dist{1,nn}  lungs.sup_clust(nn).vol{1}(1:2) ] )
disp( [ LAN(end) lungs.LAN(nn) ] )
disp( [ sum( wgt_err ) wgt_err ] )

% toc


