
close all
clearvars -except lungs
tic

if ~exist( 'lungs', 'var' )
    % load('/Users/jarredmondonedo/Documents/Suki_lab/CT/lung_structs/MD0119_01.mat')
    load('C:\Users\Suki''s Lab\Desktop\DATA\lung_imaging\lung_structs\MD0119_01.mat')
end

%%% unpack lungs structure
nn    = 2 ;                         % select lung
sz   = lungs.sz ;                   % size of matrix
pntr = lungs.pntr ;                 % [ ind  HUct  L/R  emph?  clust#  sc#  lobe ]
vsf  = lungs.vox(1) ;              	% scaling factor for voxel in L
LAV  = lungs.LAV(nn+1) ;            % total LAV of lung

%%% model parameters
seed_perc = .080 ;                  % percentage - initial
step_perc = .010 ;                  % percentage - step
fperc     = 1.00 ;                  % fraction of force based failure
rperc     = 1-fperc ;               % fraction of random failure
sigma     = 2.00 ;                  % SD of Gaussian kernel
filt_sz   = 3.00 ;                  % filter size representing penumbra
prog_type = 'force' ;               % select 'rand' or 'force'

switch prog_type                    % max LAV to end simulation
    case 'rand' ;   max_perc = .35 ;
    case 'force' ;  max_perc = .01*round( LAV,1 ) ;
end

%%% parameters
nbins = 70 ;                        % number of bins for distribution
conn  = 6 ;                         % connectivity
sr_th = 0.5 ;                       % outlier threshold


%-- SEED emphysema in healthy lung based on known final lobar percentage
emph_ind  = and( pntr(:,3) ==nn, pntr(:,4) ) ;      % emphysema index for lung
emph_lobe = zeros( 5,1 ) ;                          % percentages in each lobe
for ll = 4:8        % loop through lobes
    emph_lobe( ll-3 ) = sum( pntr( emph_ind,7 ) ==ll ) / sum( emph_ind ) ;
end

lung_ind = pntr( pntr(:,3) ==nn, 1 ) ;              % lung indices
num_lung = length( lung_ind ) ;                     % number in lung
num_lobe = round( seed_perc*num_lung*emph_lobe ) ;  % number to change in lobe

LAV_ind = [] ;      % get indices to change
for ll = 4:8
    lobe_ind = pntr( pntr(:,7) ==ll, 1 ) ;
    LAV_tmp  = lobe_ind( randperm( length( lobe_ind ), num_lobe( ll-3 ) ) ) ;
    LAV_ind  = [ LAV_ind ; reshape( LAV_tmp, [ length( LAV_tmp ), 1 ] ) ] ; %#ok<AGROW>
end

emph3D = zeros( sz ) ;                              % rebuild emphysema
emph3D( LAV_ind ) = 1 ;

pntr2        = zeros( num_lung,2 ) ;                % new pointer matrix
pntr2( :,1 ) = lung_ind ;
pntr2( :,2 ) = emph3D( pntr2(:,1) ) ;

num_emph = round( step_perc * num_lung ) ;          % num to change each step
num_step = ( max_perc - seed_perc ) / step_perc ;   % number of steps to simulate

N = ceil( 100*( max_perc - seed_perc ) ) ;
if N > 25
    rows = ceil( N/5 ) ;
else
    rows = 5 ;
end


%%% begin simulation %%%
stats = zeros( round( num_step ),7 ) ;            	% collects data for each step
LAN   = zeros( round( num_step ),1 ) ;            	% number of clusters
dist  = {} ;                                        % save distribution plots
wb = waitbar( 0, sprintf( 'Running lung %d', nn ), 'Position', [ 2152 491 360 75 ] ) ; % [ 1900 1320 360 75 ]
figure( nn ) ; set( gcf,'Position', [ 9 -591 1862 1308 ] ) ; cnt = 1 ;     % [ 300 150 2000 1000 ]

for ii = 1:round( num_step )
    
    %-- SIMULATE emphysema progression
    risk_ind = pntr2( ~pntr2(:,2), 1 ) ;                            % remaining healthy tissue
    switch prog_type
        case 'rand'
            ind_chng = randperm( length( risk_ind ), num_emph ) ;   % change healthy to emphysema
            LAV_ind  = risk_ind( ind_chng ) ;                       % new LAV indices
            
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
            if num_emph < len1
                Nrand     = round( rperc*num_emph ) ;
                Nforce    = round( fperc*num_emph ) ;
                ind_rand  = randperm( len2, Nrand ) ;               % baseline change to emphysema
                ind_force = randperm( len1, Nforce ) ;              % force driven change to emphysema
                LAV_ind   = [ rand_LAV( ind_rand ) ; ...
                    risk_LAV( ind_force ) ] ;                       % new LAV indices
            else
                ind_chng = risk_ind( risk_rel <= r ) ;              % add random if not enough forces
                ind_chng = randperm( length( ind_chng ), num_emph - len1 ) ;
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
    if abs( LAVi-round(LAVi) ) < 100*0.8*step_perc
        figure( nn ) ; subplot( rows,5,cnt ) ;
        loglog( X0, Y0, 'bo' ) ; hold on ; loglog( X, Yfit, 'r--' )
        loglog( X0( length(X)+1:end ), Y0( length(X)+1:end ), 'c*' )
        title( sprintf( 'Percent = %.1f', LAVi ) )
        xlabel( 'Cluster Size (#vox)' ) ; ylabel( 'Cum # of clusters' )
        xlim( [ 1 1e7 ] ) ; ylim( [ 1 1e7 ] )
        
        dist{ cnt } = { LAVi, [ X0; Y0 ], [ X; Yfit ] } ;   %#ok<SAGROW>
        cnt = cnt +1 ;
    end
    waitbar( ii / num_step )
    
end
close( wb )


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

save stats.mat stats p LAN dist


%-- PLOT results
plot_sim_results
disp( stats(end,:) )
disp( [ lungs.LAV(nn+1)  lungs.dist{1,nn}  lungs.sup_clust(nn).vol{1}(1:2) ] )
disp( [ LAN(end) lungs.LAN(nn) ] )

toc


