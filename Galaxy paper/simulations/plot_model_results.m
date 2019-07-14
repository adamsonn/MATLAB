
close all
warning( 'off', 'MATLAB:xlswrite:AddSheet' )


%%% pt to load
pt_id = { 'MD0006', 'MD0008', 'MD0018', 'MD0020', 'MD0023', 'MD0029',...
    'MD0045', 'MD0119', 'MD0150', 'MD0163' } ;

%%% pre-allocate
len    = 2*length( pt_id ) ;
pts    = cell( len,1 ) ;            % patient id's
LAVadj = zeros( len,6 ) ;           % adjusted LAV
D      = zeros( len,6 ) ;           % slope, D
V_sc   = zeros( len,6 ) ;           % super cluster volume
f_sc   = zeros( len,6 ) ;           % super cluster fraction of LAVtot
LAN    = zeros( len,6 ) ;           % total number of clusters
cnt    = 1 ;                        % current row


%%% extract
for nn = 1:length( pt_id )
    s = load( [ 'simulation_2\' pt_id{nn} '_model.mat' ] ) ;    stats = s.stats ;
    
    for ii = 1:3        % scan
        pts{ cnt } = pt_id{ nn } ;
        for jj = 1:2	% lung
            if ~isempty( stats(ii).lung(jj).plung ) ;
                
                LAVadj( cnt,jj )   = stats(ii).lung(jj).plung(2) ;
                LAVadj( cnt,jj+2 ) = stats(ii).lung(jj).pforce(4) ;
                LAVadj( cnt,jj+4 ) = stats(ii).lung(jj).prand(4) ;
                
                D( cnt,jj )        = stats(ii).lung(jj).plung(3) ;
                D( cnt,jj+2 )      = stats(ii).lung(jj).pforce(5) ;
                D( cnt,jj+4 )      = stats(ii).lung(jj).prand(5) ;
                
                V_sc( cnt,jj )     = stats(ii).lung(jj).plung(5) ;
                V_sc( cnt,jj+2 )   = stats(ii).lung(jj).pforce(7) ;
                V_sc( cnt,jj+4 )   = stats(ii).lung(jj).prand(7) ;
                
                f_sc( cnt,jj )     = stats(ii).lung(jj).plung(6) ;
                f_sc( cnt,jj+2 )   = stats(ii).lung(jj).pforce(8) ;
                f_sc( cnt,jj+4 )   = stats(ii).lung(jj).prand(8) ;
                
                LAN( cnt,jj )      = stats(ii).lung(jj).plung(7) ;
                LAN( cnt,jj+2 )    = stats(ii).lung(jj).pforce(10) ;
                LAN( cnt,jj+4 )    = stats(ii).lung(jj).prand(10) ;
                
            end
        end
        cnt = cnt +1 ;
    end
end


%%% plot
figure() ; set( gcf, 'Position', [ 9   689   624   668 ] )
r=3 ; c=2 ; col = 'rb' ;

%-- PT ID --%
pts = [ pts ; pts ] ;

%-- LAVadj --%
x0 = [ LAVadj(:,1); LAVadj(:,2) ] ;     x  = x0( x0 >0 ) ;
y1 = [ LAVadj(:,3); LAVadj(:,4) ] ;     y1 = y1( x0 >0 ) ;
y2 = [ LAVadj(:,5); LAVadj(:,6) ] ;     y2 = y2( x0 >0 ) ;
R2_f1 = 1 - ( sum( ( y1-x ).^2 )/sum( ( y1-mean(y1) ).^2 ) ) ;
R2_r1 = 1 - ( sum( ( y2-x ).^2 )/sum( ( y2-mean(y2) ).^2 ) ) ;
perc_diff1 = [ mean( abs( (y1-x)./x ) ) std( abs( (y1-x)./x ) ) ;...
    mean( abs( (y2-x)./x ) ) std( abs( (y2-x)./x ) ) ] ;
disp( [ [ R2_f1 ; R2_r1 ] perc_diff1 ] )

lims1 = [ 0 35 ] ;
subplot( r,c,1 ) ; hold on ; title( 'LAV_a_d_j (%)' )
plot( x, y2, 'ko', 'MarkerFaceColor', col(2) )
plot( x, y1, 'ko', 'MarkerFaceColor', col(1) )
plot( lims1, lims1 )
xlabel( 'CT' ) ;    xlim( lims1 )
ylabel( 'MODEL' ) ; ylim( lims1 )
legend( 'Location', 'SouthEast', 'Random', 'Force' )

xlswrite( 'model_data.xls', [ pts( x0 >0 ) num2cell( [ x y1 y2 ] ) ], 'LAVadj' )


%-- D --%
x0 = [ D(:,1); D(:,2) ] ;     x  = x0( x0 >0 ) ;
y1 = [ D(:,3); D(:,4) ] ;     y1 = y1( x0 >0 ) ;
y2 = [ D(:,5); D(:,6) ] ;     y2 = y2( x0 >0 ) ;
R2_f2 = 1 - ( sum( ( y1-x ).^2 )/sum( ( y1-mean(y1) ).^2 ) ) ;
R2_r2 = 1 - ( sum( ( y2-x ).^2 )/sum( ( y2-mean(y2) ).^2 ) ) ;
perc_diff2 = [ mean( abs( (y1-x)./x ) ) std( abs( (y1-x)./x ) ) ;...
    mean( abs( (y2-x)./x ) ) std( abs( (y2-x)./x ) ) ] ;
disp( [ [ R2_f2 ; R2_r2 ] perc_diff2 ] )

lims2 = [ 0 3 ] ;
subplot( r,c,2 ) ; hold on ; title( 'D' )                           % D
plot( x, y2, 'ko', 'MarkerFaceColor', col(2) )
plot( x, y1, 'ko', 'MarkerFaceColor', col(1) )
plot( lims2, lims2 )
xlabel( 'CT' ) ;    xlim( lims2 )
ylabel( 'MODEL' ) ; ylim( lims2 )

xlswrite( 'model_data.xls', [ pts( x0 >0 ) num2cell( [ x y1 y2 ] ) ], 'D' )


%-- V_sc --%
x0 = [ V_sc(:,1); V_sc(:,2) ] ;     x  = x0( x0 >0 ) ;
y1 = [ V_sc(:,3); V_sc(:,4) ] ;     y1 = y1( x0 >0 ) ;
y2 = [ V_sc(:,5); V_sc(:,6) ] ;     y2 = y2( x0 >0 ) ;
R2_f3 = 1 - ( sum( ( y1-x ).^2 )/sum( ( y1-mean(y1) ).^2 ) ) ;
R2_r3 = 1 - ( sum( ( y2-x ).^2 )/sum( ( y2-mean(y2) ).^2 ) ) ;
perc_diff3 = [ mean( abs( (y1-x)./x ) ) std( abs( (y1-x)./x ) ) ;...
    mean( abs( (y2-x)./x ) ) std( abs( (y2-x)./x ) ) ] ;
disp( [ [ R2_f3 ; R2_r3 ] perc_diff3 ] )

lims3 = [ 0 1.5 ] ;
subplot( r,c,3 ) ; hold on ; title( 'Volume_s_c' )                  % V_sc
plot( x, y2, 'ko', 'MarkerFaceColor', col(2) )
plot( x, y1, 'ko', 'MarkerFaceColor', col(1) )
plot( lims3, lims3 )
xlabel( 'CT' ) ;    xlim( lims3 )
ylabel( 'MODEL' ) ; ylim( lims3 )

xlswrite( 'model_data.xls', [ pts( x0 >0 ) num2cell( [ x y1 y2 ] ) ], 'V_sc' )


%-- f_sc --%
x0 = [ f_sc(:,1); f_sc(:,2) ] ;     x  = x0( x0 >0 ) ;
y1 = [ f_sc(:,3); f_sc(:,4) ] ;     y1 = y1( x0 >0 ) ;
y2 = [ f_sc(:,5); f_sc(:,6) ] ;     y2 = y2( x0 >0 ) ;
R2_f4 = 1 - ( sum( ( y1-x ).^2 )/sum( ( y1-mean(y1) ).^2 ) ) ;
R2_r4 = 1 - ( sum( ( y2-x ).^2 )/sum( ( y2-mean(y2) ).^2 ) ) ;
perc_diff4 = [ mean( abs( (y1-x)./x ) ) std( abs( (y1-x)./x ) ) ;...
    mean( abs( (y2-x)./x ) ) std( abs( (y2-x)./x ) ) ] ;
disp( [ [ R2_f4 ; R2_r4 ] perc_diff4 ] )

lims4 = [ 0 1 ] ;
subplot( r,c,4 ) ; hold on ; title( 'Fraction of LAV_t_o_t' )       % f_sc
plot( x, y2, 'ko', 'MarkerFaceColor', col(2) )
plot( x, y1, 'ko', 'MarkerFaceColor', col(1) )
plot( lims4, lims4 )
xlabel( 'CT' ) ;    xlim( lims4 )
ylabel( 'MODEL' ) ; ylim( lims4 )

xlswrite( 'model_data.xls', [ pts( x0 >0 ) num2cell( [ x y1 y2 ] ) ], 'f_sc' )


%-- LAN --%
x0 = [ LAN(:,1); LAN(:,2) ] ;       x  = x0( x0 >0 ) ;
y1 = [ LAN(:,3); LAN(:,4) ] ;       y1 = y1( x0 >0 ) ;
y2 = [ LAN(:,5); LAN(:,6) ] ;       y2 = y2( x0 >0 ) ;
R2_f5 = 1 - ( sum( ( y1-x ).^2 )/sum( ( y1-mean(y1) ).^2 ) ) ;
R2_r5 = 1 - ( sum( ( y2-x ).^2 )/sum( ( y2-mean(y2) ).^2 ) ) ;
perc_diff5 = [ mean( abs( (y1-x)./x ) ) std( abs( (y1-x)./x ) ) ;...
    mean( abs( (y2-x)./x ) ) std( abs( (y2-x)./x ) ) ] ;
disp( [ [ R2_f5 ; R2_r5 ] perc_diff5 ] )

lims5 = [ 1e5 12e5 ] ;
subplot( r,c,5 ) ; hold on ; title( 'LAN' )                         % LAN
plot( x, y2, 'ko', 'MarkerFaceColor', col(2) )
plot( x, y1, 'ko', 'MarkerFaceColor', col(1) )
plot( lims5, lims5 )
xlabel( 'CT' ) ;    xlim( lims5 )
ylabel( 'MODEL' ) ; ylim( lims5 )

xlswrite( 'model_data.xls', [ pts( x0 >0 ) num2cell( [ x y1 y2 ] ) ], 'LAN' )


%%% save
pd = 100*[ ...
    perc_diff1(1,:) perc_diff1(2,:) ; ... 
    perc_diff2(1,:) perc_diff2(2,:) ; ...
    perc_diff5(1,:) perc_diff5(2,:) ; ...
    perc_diff3(1,:) perc_diff3(2,:) ; ...
    perc_diff4(1,:) perc_diff4(2,:)   ...
    ] ;
xlswrite( 'model_data.xls', num2cell( pd ), 'stats' )

save all_model_stats.mat LAVadj D V_sc f_sc LAN pd

warning( 'on', 'MATLAB:xlswrite:AddSheet' )


