%Gravitatonal Constant m/s^2
gravity=9.81

%Flow Rate m/s
Q=20

%Particle Density
densityp=

%Partilce Mass


%Particle Diameter
diameterp=

%Dynamic Fluid Viscosity
fluidviscosity=

%Kinematic Vicsoity
kinematicviscosity=

%Tube Diamter
d=

%Tube Length
L=

%Fluid Velocity
vfluid=Q/(pi*(d/2)^2);

%Partilce Velocity

%Relative Velocity
vrelative=vfluid-vparticle


%Partilce Reynlods Number
Re=vrelative*diameterp/(kinematicviscosity)

% Crowe 


%

Vsettling=Cc*densityp*gravity*diameterp.^2/(18*kinematicviscoisty)


