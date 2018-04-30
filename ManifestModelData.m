ParticleMass=1000;
DiameterOfParticle=3.5*10^(-6);
DynamicViscoisty=1.983*10^(-5);
%Kinematic Vicsoity kg/ms 
KinematicViscosity=(1.8*10^-5); 
  

%Mean Free Path (air in meters) 
meanfreepath=.067*10^-6; 
  
% Cunningham Correction Coefficeint 
Cc=1+2.52*meanfreepath/DiameterOfParticle; 

%Defines Diameters of the model for 4 Gen
diameters=zeros(4,1);
StartingDiametermeters=10*10^-3;
diameters(1,1)=StartingDiametermeters;
diameters(2,1)=StartingDiametermeters*(2^(-1/3));
diameters(3,1)=StartingDiametermeters*(2^(-1/3)^2);
diameters(4,1)=StartingDiametermeters*(2^(-1/3)^3);
radius=diameters/2;
CrossSectionalArea=pi*radius.^2;
RadiusOfCurvature=5.4*radius;
CarinalRadiusofCurvatiure=.1*diameters;
%Length Equations
Lengths=3.5*diameters;


%Describes flow rate
FlowRates=zeros(4,1);

%convert to M=m^3/s
InitialFlowRate=2*1.1467*10^(-4);
FlowRates(1,1)=InitialFlowRate;
FlowRates(2,1)=InitialFlowRate/2;
FlowRates(3,1)=InitialFlowRate/4;
FlowRates(4,1)=InitialFlowRate/8;

%Velocities
Velocities=zeros(4,1);
Velocities(1,1)=FlowRates(1,1)/(CrossSectionalArea(1,1));
Velocities(2,1)=FlowRates(2,1)/(CrossSectionalArea(2,1));
Velocities(3,1)=FlowRates(3,1)/(CrossSectionalArea(3,1));
Velocities(4,1)=FlowRates(4,1)/(CrossSectionalArea(4,1));

%Reynolds and Stokes
Re=zeros(4,1);
Re(1,1)=Velocities(1,1)*diameters(1,1)/KinematicViscosity;
Re(2,1)=Velocities(2,1)*diameters(2,1)/KinematicViscosity;
Re(3,1)=Velocities(3,1)*diameters(3,1)/KinematicViscosity;
Re(4,1)=Velocities(4,1)*diameters(4,1)/KinematicViscosity;




%Stokes Number 
Stk=zeros(4,1);
Stk(1,1)=ParticleMass*DiameterOfParticle^2*Velocities(1,1)*Cc/(18*DynamicViscoisty*diameters(1,1));
Stk(2,1)=ParticleMass*DiameterOfParticle^2*Velocities(2,1)*Cc/(18*DynamicViscoisty*diameters(2,1));
Stk(3,1)=ParticleMass*DiameterOfParticle^2*Velocities(3,1)*Cc/(18*DynamicViscoisty*diameters(3,1));
Stk(4,1)=ParticleMass*DiameterOfParticle^2*Velocities(4,1)*Cc/(18*DynamicViscoisty*diameters(4,1));


