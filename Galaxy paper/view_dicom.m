
close all


[ fn, pn ] = uigetfile( '*.*' ) ;
if pn==0 ; return ; end
info = dicominfo( fullfile( pn, fn ) ) ;
dcm  = dicomread( info ) ;

slope = info.RescaleSlope ;
intcp = info.RescaleIntercept ;
dcmHU = int16( dcm )*slope + intcp ;

figure() ; imshow( dcmHU ) ; imcontrast