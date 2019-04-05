load rawpointslarge

load largeass

 

xyz0 = rawpointslarge( : , 1:3 ) ;

xyz1 = rawpointslarge( : , 4:6 ) ;

diam = rawpointslarge( : ,   7 ) ;

 

indAwy = largeass(:,1) ;

indPar = largeass(:,6) ;

indPar(1) = -1 ;

 

%%

 

plot3([ xyz0(:,1) , xyz1(:,1) ]' ,[ xyz0(:,2) , xyz1(:,2) ]' , [ xyz0(:,3) , xyz1(:,3) ]' ,'ko-' )

 

%%

 

numAwy = size(largeass,1) ;

for kk = 1 : numAwy

    indChi = find( indPar == indAwy(kk) ) ;

    if numel( indChi ) == 2

        xyzNew = mean( [

            xyz1( kk        ,:)

            xyz0( indChi(1) ,:)

            xyz0( indChi(2) ,:)

            ] ) ;

        xyz1(kk,:) = xyzNew ;

        xyz0(indChi(1),:) = xyzNew ;

        xyz0(indChi(2),:) = xyzNew ;

    end

end

 

%%

 

rawpointsFix = [ xyz0 , xyz1 , diam ] ;

save rawpointsFix rawpointsFix