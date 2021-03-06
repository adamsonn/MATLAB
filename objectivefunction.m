function [ totalprob ] = objectivefunction(L,d,phi,count)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%Gravitatonal Constant m/s^2
Q=sym(['Q',num2str(count)]);

gravity=9.81;

%Flow Rate m^3/s

%Particle Density (water kg/m^3)
densityp= 1000;

%Particle Diameter meters
diameterp=3.5*10^-6;

%Kinematic Vicsoity kg/ms
kinematicviscosity=(1.8*10^-5);


%Mean Free Path (air in meters)
meanfreepath=.067*10^-6;

% Cunningham Correction Coefficeint
Cc=1+2.52*meanfreepath/diameterp;

% Settling Velocity acceleration is zero
Vsettling=Cc*densityp*gravity*diameterp.^2/(18*kinematicviscosity);

%Settling time
Tsettling=densityp*gravity*diameterp.^2/(18*kinematicviscosity);

%Number of Generations
N=0;

%Tube Diamter (meters)



%Tube Length (meters)

%Fluid Velocity (average)
Vfluid=Q/(pi*(d/2)^2);

% Reynlods Number
Re=Vfluid*d/(kinematicviscosity);

%Stokes Number
Stk=Vfluid*densityp*diameterp^2*Cc/(18*kinematicviscosity*d);

%tube angle radians 
theta=pi/4;

%kappa
kappa=(3/4)*(Vsettling*(Vfluid).^-1)*L*cos(phi*(pi/180))/d;

%Probability of gravitational setimentation


    
    Ps=(2/pi)*((2*kappa*(1-kappa.^(2/3)).^(1/2))-(kappa.^(1/3))*((1-kappa.^(2/3)).^(1/2))+(asin((kappa.^(1/3)))));
    
    %if Ps>1
     %   Ps=1;
    %end
    %if Ps<0
     %   Ps=0;
    %end




%Daughter generation
Daughter=.8;

%Parent generation
Parent=1;

%Probability of impaction deposition


Pi=1.606*Stk+.0023;

 %if Pi>1
  %      Pi=1;
 %end

    

%tempreture calvin
Tempreture=310;

%Delta
delta=1.38*10^-23*Tempreture*Cc*L/(12*kinematicviscosity*diameterp)*Q.^-1;

    Pd=6.41*delta.^(2/3)-4.8*delta-1.123*delta.^(4/3);
   


%if Pd>1
 %       Pd=1;
 %   end
  %  if Pd<0
   %     Pd=0;
   % end


    totalprob=1-(1-Pi)*(1-Pd)*(1-Ps);



end

