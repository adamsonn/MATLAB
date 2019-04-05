load rawpoints

load smallas

 

xyz0 = rawpoints( : , 1:3 ) ;

xyz1 = rawpoints( : , 4:6 ) ;

diam = rawpoints( : ,   7 ) ;

 

indAwy = smallas(:,1) ;

indPar = smallas(:,6) ;

indPar(1) = -1 ;

 

%%

 

plot3([ xyz0(:,1) , xyz1(:,1) ]' ,[ xyz0(:,2) , xyz1(:,2) ]' , [ xyz0(:,3) , xyz1(:,3) ]' ,'ko-' )

 

%%

 

numAwy = size(smallas,1) ;

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