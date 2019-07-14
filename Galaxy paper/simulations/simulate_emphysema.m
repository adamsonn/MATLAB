
close all
clearvars -except lungs
tic

if ~exist( 'lungs', 'var' )
    load('/Users/jarredmondonedo/Documents/Suki_lab/CT/lung_structs/MD0150_01.mat')
end

%%% unpack lungs structure
nn    = 1 ;                         % select lung
sz   = lungs.sz ;                   % size of matrix
pntr = lungs.pntr ;                 % [ ind  HUct  L/R  emph?  clust#  sc# ]
vsf  = lungs.vox(1) ;              	% scaling factor for voxel in L
LAV  = lungs.LAV(nn+1) ;            % total LAV of lung

%%% model parameters
seed_perc = .030 ;                  % percentage - initial
step_perc = .001 ;                  % percentage - step
fperc     = 0.98 ;                  % fraction of force based failure
rperc     = 1-fperc ;               % fraction of random failure
sigma     = 2.00 ;                  % SD of Gaussian kernel
filt_sz   = 3.00 ;                  % filter size representing penumbra
prog_type = 'rand' ;                % select 'rand' or 'force'

switch prog_type                    % max LAV to end simulation
    case 'rand' ;   max_perc = .35 ;
    case 'force' ;  max_perc = .01*round( LAV,1 ) ;
end

%%% parameters
nbins = 70 ;                        % number of bins for distribution
conn  = 6 ;                         % connectivity
sr_th = 0.5 ;                       % outlier threshold


%-- SEED emphysema in healthy lung
lung_ind = pntr( pntr( :,3 ) ==nn, 1 ) ;
num_vox  = length( lung_ind ) ;

[ ~,~,x3 ] = ind2sub( sz, lung_ind ) ;
top        = min( x3 ) ;            % top of lung
bot        = max( x3 ) ;            % bottom of lung

tmp = ( ( bot-x3 )/( bot-top ) ).^2 ;               % vertical probability gradient
r   = rand( size(tmp) ) ;
ind = lung_ind( tmp >r ) ;

chng_vox = round( seed_perc*num_vox ) ;
LAV_ind  = randperm( length( ind ), chng_vox ) ;    % random distribution
LAV_ind  = ind( LAV_ind ) ;
% LAV_ind  = randperm( num_vox, chng_vox ) ;

emph3D = zeros( sz ) ;                              % rebuild emphysema
emph3D( LAV_ind ) = 1 ;
% emph3D( pntr( LAV_ind, 1 ) ) = 1 ;

pntr2        = zeros( num_vox,2 ) ;                 % new pointer matrix
pntr2( :,1 ) = lung_ind ;
pntr2( :,2 ) = emph3D( pntr2(:,1) ) ;

num_emph = round( step_perc * num_vox ) ;           % num to change each step
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
wb = waitbar( 0, sprintf( 'Running lung %d', nn ), 'Position', [ 1900 1320 360 75 ] ) ;
figure( nn ) ; set( gcf,'Position', [ 300 150 2000 1000 ] ) ; cnt = 1 ;

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
    
    LAVdist = calc_dist( LAVc, num_vox, nbins, sr_th, vsf ) ;
    X0 = LAVdist{2}(:,1) ;      X    = LAVdist{3}(:,1) ;
    Y0 = LAVdist{2}(:,2) ;      Yfit = LAVdist{3}(:,3) ;
    
    stats( ii,: ) = LAVdist{ 1 } ;                  % save output data
    
    
    %-- PLOT
    LAVi = 100*sum( emph3D(:) )/num_vox ;
   if abs( LAVi-round(LAVi) ) < step_perc
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



%     bins  = logspace( 0, ceil( log10( max(LAVc) ) ), nbins+1 ) ;
%     binc  = 0.5*( bins( 1:end-1 ) + bins( 2:end ) ) ;
%     count = histc( LAVc, bins ) ;
%     count = count( 1:end-1 ) ;
%     X0    = binc( count >0 ) ;
%     Y0    = fliplr( cumsum( fliplr( count( count >0 ) ) ) ) ;
%     
%     [ p,R2 ] = lin_reg( log10( [ X0;Y0 ]' ), 1, 0 ) ;   % fit
%     Yfit     = 10^p(2) * X0.^p(1) ;

%             emph_sz  = zeros( sz ) ;                                % generate size map
%             CC       = bwconncomp( emph3D, conn ) ;
%             LAVi1    = CC.PixelIdxList ;
%             LAVc1    = cellfun( @numel, LAVi1 ) ;
%             for cl   = 1:length( LAVc1 )
%                 emph_sz( LAVi1{cl} ) = LAVc1(cl)^3 ;
%             end
%             emph_sz  = imgaussfilt3( emph_sz, 'FilterSize', 7 ) ;
%             emph_sz  = emph_sz / max( emph_sz( risk_ind ) ) ;       % normalize to 1
%             risk_msk = emph_pen + emph_sz ;                         % total risk map
