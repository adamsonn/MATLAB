
function [ out, pntr0 ] = simulate_emphysema_subf( lungs, nn, seed_perc, prog_type, pntr0 )


%%% unpack lungs structure
sz   = lungs.sz ;                   % size of matrix
pntr = lungs.pntr ;                 % [ ind  HUct  L/R  emph?  clust#  sc#  lobe ]
vsf  = lungs.vox(1) ;              	% scaling factor for voxel in L
LAV  = lungs.LAV(nn+1) ;            % total LAV of lung

%%% model parameters
step_perc = .010 ;                  % percentage - step
fperc     = 0.98 ;                  % fraction of force based failure
rperc     = 1-fperc ;               % fraction of random failure
sigma     = 2.00 ;                  % SD of Gaussian kernel
filt_sz   = 3 ;                     % filter size representing penumbra
max_perc  = .01*round( LAV,1 ) ;    % max LAV to end simulation

%%% parameters
nbins = 70 ;                        % number of bins for distribution
conn  = 6 ;                         % connectivity
sr_th = 0.5 ;                       % outlier threshold



%-- SEED emphysema in healthy lung based on known final lobar percentage
lung_ind = pntr( pntr(:,3) ==nn, 1 ) ;              % lung indices
lung3D   = zeros( sz ) ; lung3D( lung_ind ) = 1 ;   % rebuild lung mask
num_lung = length( lung_ind ) ;                     % number in lung
num_seed = round( seed_perc*num_lung ) ;            % number to change in lobe

switch prog_type
    case 'force'
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
        pntr0        = pntr2 ;                              % save initial distribution
        
    case 'rand'
        pntr2  = pntr0 ;
        emph3D = zeros( sz ) ; emph3D( pntr2(:,1) ) = pntr2( :,2 ) ;
end

LAV_step = unique( [ seed_perc : step_perc : max_perc max_perc ] ) ;    % LAV at each step
num_step = length( LAV_step )-1 ;                   % number of steps to simulate
num_emph = round( diff( LAV_step )*num_lung ) ;     % num to change each step



%%% begin simulation %%%
stats  = zeros( round( num_step ),7 ) ;            	% collects data for each step
LAN    = zeros( round( num_step ),1 ) ;            	% number of clusters
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
    
    stats( ii,: ) = LAVdist{ 1 } ;                  % save output data
end


%-- ERROR
a = [ stats(end,6) stats(end,2) stats(end,3) LAN(end) ] ;
b = [ lungs.sup_clust(nn).vol{1}(2) lungs.dist{1,nn}(1:2) lungs.LAN(nn) ] ;
wgt     = [ .4 .2 .2 .2 ] ;      % [ f_LAV  LAVadj  D  LAN ]
wgt_err = wgt .* abs( (a-b)./b ) ;


%-- OUT
out{ 1 } = [ seed_perc  sum( wgt_err )  stats(end,:)  LAN(end) ] ;
out{ 2 } = [ lungs.LAV(nn+1)  lungs.dist{1,nn}  lungs.sup_clust(nn).vol{1}(1:2)  lungs.LAN(nn) ] ;


