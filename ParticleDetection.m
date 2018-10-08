%-------------------------------------------------------------------------%
%Boston University
%Cell and Tissue Mechanics Laboratory
%Code initiated by Jarred Mondonedo (2017)
%Code Updated by Samer Bou Jawde & Adam Sonnenberg (2018)
    %Code -  Detection of particle size
%-------------------------------------------------------------------------%

close all       % close figures
%clearvars       % clear workspace variables
clc             % clear command window



%----------> USER <----------% 

    %--Image Conversion Factor
    CF = 0.5; % micron/pix
        %Keep empty ([]) if unavailable
        %If empty([]) it will be set to 1 and pixel dimensions are used


    %%% PARTICLE IMAGE PARAMETERS <-- set these
    Rmin = 1.5;           % minimum particle radius in uM (or pixels if CF=[])  
    Rmax = 20;           % maximum particle radius in uM (or pixels if CF=[])  
    Sth  = 0.85 ;       % solidity threshold             %~0.95
    Ith  = 1 ;          % grayscale threshold            %~1



%----------> CODE <----------%

%-- Check Conversion Factor
if isempty(CF) 
    xC = 1; %calibration 
else
    xC = CF;
end

%-- LOAD image file
fn = '' ;                       % filename, leave empty to prompt user
if isempty( fn ) 
    [ fn,pn,~ ] = uigetfile( '*.tif' ) ;    if pn==0 ; return ; end
    fn = fullfile( pn,fn ) ;
end

I  = imread( fn );                             % read in file
J  = imadjust( rgb2gray(I) );                  % adjust contrast
bw = imbinarize( J, Ith*graythresh( J ) ) ;    % convert to binary
bw = bwmorph( ~bw, 'open' ) ;                  % find "PARTICLES"
bw = imfill( bw, 'holes' ) ;


%-- PROCESS image
rp  = regionprops( bw, 'MajorAxisLength', 'MinorAxisLength', 'Solidity', 'PixelIdxList' ) ;
R   = mean( [ [rp.MajorAxisLength] ; [rp.MinorAxisLength] ],1)/2;     % estimated radius of particle (pixels)
S   = [ rp.Solidity ] ;                                               % solidity of particle
RxC = R*xC;                                                           % Radius in pixels or uM
ind = and( and( RxC>Rmin, RxC<Rmax ), S>Sth ) ;                       % filter those that meet criteria
idx = cell2mat( { rp(ind).PixelIdxList }' ) ;

bw2 = zeros( size( bw )  ) ; bw2( idx ) = 1 ;   % rebuild image with selected particle
bw2 = imclearborder( bwconvhull( bw2, 'objects' ) ) ;
bw3 = bwmorph( bw2, 'remove' ) ;
rp2 = regionprops( bw2, 'MajorAxisLength', 'MinorAxisLength', 'Eccentricity', 'Orientation' ) ;


%-- CALCULATE characteristics of particle
ecc  = [ rp2.Eccentricity ] ;                                        % eccentricity
Rel  = [ rp2.MinorAxisLength ] ./ [ rp2.MajorAxisLength ] ;          % minor:major axis ratio
ori  = [ rp2.Orientation ] ;                                         % orientation
rad  = mean( [ [rp2.MajorAxisLength] ; [rp2.MinorAxisLength] ],1)/2; % radius (pixels)

%-- PLOT / PRINT results
figure() ; imshow( J ) ; hold on        % plot particle outline
col = cat( 3, zeros( size(bw) ), ones( size(bw) ), zeros( size(bw) ) ) ;
h2 = imshow( col ) ; set( h2, 'AlphaData', .2*bw2 )
h3 = imshow( col ) ; set( h3, 'AlphaData', .8*bw3 )

figure                                  % eccentricity / ellipse axis ratio distributions
subplot( 1,4,1 ) ; hist( ecc , 6 ) ; xlim( [ 0 1 ] ) ; title( 'Eccentricity' )
subplot( 1,4,2 ) ; hist( Rel , 6 ) ; xlim( [ 0 1 ] ) ; title( 'Minor:Major Axes' )
subplot( 1,4,3 ) ; hist( ori , 6 ) ; xlim( [ -90 90 ] ) ; title( 'Orientation' )
subplot( 1,4,4 ) ; hist( rad , 6 ) ; xlim( [ Rmin/xC Rmax/xC ] ) ; title( 'Radius (pixels)' )

fprintf( '\n\n\tN = %d', length( Rel ) )    % print results
fprintf( '\n\tEccentricity: %.2f\t%.2f', mean( ecc ), std( ecc ) )
fprintf( '\n\tAxes ratio:   %.2f\t%.2f', mean( Rel ), std( Rel ) )
fprintf( '\n\tOrientation:  %.2f\t%.2f', mean( ori ), std( ori ) )
fprintf( '\n\tRadius(pixels):         %.2f\t%.2f\n\n', mean( rad ), std( rad ) )



%--Effective Radius of Sphere
    %Assumptions:
    %1) Assuming sphereical droplets
    %2) These droplets form parabolic water-glass interface

alpha = 13*pi/180; %water-glass contact angle (rad)
Vol = pi*alpha*rad.^3/4; %sphere volume (pixels squared)
Req = ( Vol*3/4/pi ).^(1/3); %Equivalent Sphere radius (pixels)
Req_min = (alpha*(Rmin/xC).^3*3/16).^(1/3);
Req_max = (alpha*(Rmax/xC).^3*3/16).^(1/3);
figure , hist( Req  , 6 ) ; xlim( [ Req_min Req_max ] ) ; title( 'Estimated Aerosol Radius (pixels)' )


%--Radius (uM) Effective Radius (uM)
if ~isempty(CF)  
    
    figure
    
    %detected radius on glass (uM)
    radum = rad*CF;    
    subplot(1,2,1) ,  hist( radum , 6 ) ; xlim( [ Rmin Rmax ] ) ; title( 'Radius (uM)' )    
    
    %estimated radius of aerosol
    Requm = Req*CF;    
    Requm_min = (alpha*Rmin.^3*3/16).^(1/3);
    Requm_max = (alpha*Rmax.^3*3/16).^(1/3);
    subplot(1,2,2) ,  hist( Requm , 6 ) ; xlim( [ Requm_min Requm_max ] ) ; title( 'Estimated Aerosol Radius (uM)' ) 
  
    %Print Results    
    fprintf( '\n\n\tN = %d', length( radum ) )    % print results
    fprintf( '\n\tRegion Radius(uM): %.2f\t%.2f', mean( radum ), std( radum ) )
    fprintf( '\n\tAerosol Radius(uM):   %.2f\t%.2f\n\n', mean( Requm ), std( Requm ) )

    
end
   
%-- SAVE DATA
Data = [ ecc' Rel' ori' rad' Req' ];
if ~isempty(CF) 
    Data = [ Data radum' Requm'];
end

AllData  = [AllData ; Data];
