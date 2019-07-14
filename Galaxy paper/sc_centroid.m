

function out = sc_centroid( x_in )


%-- PARAMETERS
prct  = [ 0.10  0.25  0.50  0.75  0.90 ] ;      % percentiles to calculate
bool = 1 ;

%-- Calculate CENTROID
a  = cumsum( x_in(:,1) ) ;                      % density
b  = cumsum( x_in(:,2) ) ;                      % emphysema voxels
c  = cumsum( x_in(:,3) ) ;                      % lung voxels
[ ~,ia,~ ] = unique( a ) ;                      % get monotonically increasing
ic = find( x_in(:,3) ) ;                      % get slices with lung voxels
pa = interp1( a(ia)/max(a), ia, prct ) ;        % percentiles based on density
pb = interp1( b(ia)/max(b), ia, prct ) ;        % percentiles based on # of voxels

%-- Lung limits
% while bool
%     d = find( diff( ic ) >10, 1 ) ;    
%     if isempty( d )
%         bool = 0 ;
%     else
%         if d == length(ic) -1
%             ic = ic( 1:end-1 ) ;
%         else
%             ic(d) = [] ;
%         end
%     end
% end

%-- NORMALIZE centroid
pa_n = ( pa - max(ic) ) / ( min(ic) - max(ic) ) ;
pb_n = ( pb - max(ic) ) / ( min(ic) - max(ic) ) ;

%-- OUTPUT
out = [ pa ; pa_n ; pb ; pb_n ] ;



%  NOTE: centroid is calculated relative to back of lung (i-space),
%  absolute right (j-space), and bottom of lung (k-space)