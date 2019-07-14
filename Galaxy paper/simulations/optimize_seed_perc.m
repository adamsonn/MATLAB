
tic
seeds   = .02:.01:.09 ;
all_err = zeros( length( seeds ), 4 ) ;

for ss = 1:length( seeds )
    seed_perc = seeds( ss ) ;
    simulate_emphysema_v3
    all_err( ss,: ) = wgt_err ;
end
toc