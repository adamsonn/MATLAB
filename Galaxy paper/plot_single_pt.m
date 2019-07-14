
clearvars
close all

% patient ID to plot
pt_id = 'MD0150' ;

% search directory
sr_dir = 'C:\Users\Suki''s Lab\Desktop\DATA\lung_imaging\lung_structs\' ;

% get scans for patient
pt_scans = dir( [ sr_dir pt_id '*.mat' ] ) ;
pt_scans = { pt_scans.name } ;
num_scns = length( pt_scans ) ;

% projection subplots
frc = [ 3 3 8 ] ;
psp = { ...
    [ 2 1 10 9 18 17 ], ...
    [ 5 4 13 12 21 20 ], ...
    [ 8 7 16 15 24 23 ] ...
    } ;

% parameters to print
LAV   = zeros( num_scns, 3 ) ;
TLVct = zeros( num_scns, 3 ) ;
LAN   = zeros( num_scns, 3 ) ;
dist  = zeros( num_scns, 6 ) ;
sc_V  = cell( num_scns, 4 ) ;
sc_D  = cell( num_scns, 6 ) ;


for ii = 1:num_scns
    
    figure(1) ; hax_1    = subplot( 1,3,ii ) ;          % 3D rendering
    figure(2) ; hax_2{1} = subplot( 3,2,2*ii-1 ) ;      % centroids
                hax_2{2} = subplot( 3,2,2*ii ) ;
    figure(3) ; hax_3    = psp{ ii } ;                  % projections
    
    % load processed .mat file
    tmp   = load( [ sr_dir pt_scans{ ii } ] ) ;
    lungs = tmp.lungs ;
    
    % extract parameters
    LAV( ii,: )   = lungs.LAV ;
    TLVct( ii,: ) = lungs.TLVct ;
    LAN( ii,: )   = [ sum( lungs.LAN ), lungs.LAN ] ;
    dist( ii,: )  = [ lungs.dist{1,1} lungs.dist{1,2} ] ;
    sc_V{ ii,1 }  = lungs.sup_clust(1).vol{1} ;
    sc_V{ ii,2 }  = lungs.sup_clust(1).vol{2} ;
    sc_V{ ii,3 }  = lungs.sup_clust(2).vol{1} ;
    sc_V{ ii,4 }  = lungs.sup_clust(2).vol{2} ;
    
    % render super clusters
    render_sup_clust( lungs, 1, { hax_1, hax_2 } ) ;
    
    % plot ijk-projections
    % plot_projections( lungs, frc, hax_3 )
    
end
figure(1) ; h1 = subplot(1,3,1) ; h2 = subplot( 1,3,2 ) ; h3 = subplot( 1,3,3 ) ;
hlink = linkprop( [ h1 h2 h3 ], { 'CameraPosition', 'CameraUpVector', 'CameraTarget' } ) ;
set( gcf, 'Position', [ 826  880  1730  476 ] ) % [ 202  86  1073  380 ] )
figure(2) ; set( gcf, 'Position', [ 9  49  802  1308 ] ) % 624  668 ] )
figure(3) ; set( gcf, 'Position', [ 826  49  1727  739 ] )


% print parameters
fprintf( '\n\tTLVct ( L ):\tTotal\tRight\tLeft\tLAV (%%):' )
for ii = 1:num_scns
    fprintf( '\n\t\t\t\t\t%.2f\t%.2f\t%.2f\t\t\t%.2f\t%.2f\t%.2f', TLVct(ii,:), LAV(ii,:) )
end

fprintf( '\n\tD:\t\t\t\t\t\t\t\t\t\tLAV* (%%):' )
for ii = 1:num_scns
    fprintf( '\n\t\t\t\t\t%c\t\t%.2f\t%.2f\t\t\t%c\t\t%.2f\t%.2f', '-',dist(ii,2),dist(ii,5), '-',dist(ii,1),dist(ii,4) )
end
fprintf( '\n' )

fprintf( '\n\tSCvol_R:\t\tL\t\tfLAV\tfTLV\tSC_vol_L:' )
for ii = 1:num_scns
    fprintf( '\n\t\t\t\t\t%.2f\t%.2f\t%.2f\t\t\t%.2f\t%.2f\t%.2f', sc_V{ii,1}, sc_V{ii,3} )
end
fprintf( '\n\n' )


% save parameters
p.LAV   = LAV ;
p.TLVct = TLVct ;
p.LAN   = LAN ;
p.dist  = dist ;
p.sc_V  = sc_V ;
p.sc_D  = sc_D ;

% save tmp.mat p




% sc_D{ ii,1 }  = lungs.sup_clust(1).Df{1} ;
% sc_D{ ii,2 }  = lungs.sup_clust(1).Df{2} ;
% sc_D{ ii,3 }  = lungs.sup_clust(1).Df{3} ;
% sc_D{ ii,4 }  = lungs.sup_clust(2).Df{1} ;
% sc_D{ ii,5 }  = lungs.sup_clust(2).Df{2} ;
% sc_D{ ii,6 }  = lungs.sup_clust(2).Df{3} ;

% fprintf( '\n\tLAV (%%):' )
% for ii = 1:num_scns
%     fprintf( '\n\t\t\t\t\t%.2f\t%.2f\t%.2f', LAV(ii,:) )
% end
% fprintf( '\n\tLAV* (%%):' )
% for ii = 1:num_scns
%     fprintf( '\n\t\t\t\t\t%c\t\t%.2f\t%.2f', '-',dist(ii,1),dist(ii,4) )
% end

