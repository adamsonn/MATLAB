clear
%Gravitatonal Constant m/s^2
gravity=9.81;

%Flow Rate m^3/s
Q=.001;

%Particle Density (water kg/m^3)
densityp= 1000;

%Particle Diameter meters
diameterp=[.1*10^-6:.1*10^-6:10*10^-6];

%Kinematic Vicsoity kg/ms
kinematicviscosity=(1.8*10^-5);


%Mean Free Path (air in meters)
meanfreepath=.067*10^-6;

% Cunningham Correction Coefficeint
for i= 1:length(diameterp)
    Cc=1+2.52*meanfreepath/diameterp(i);
end

% Settling Velocity acceleration is zero
for i= 1:length(diameterp)
    Vsettling(i)=Cc*densityp*gravity*diameterp(i).^2/(18*kinematicviscosity);
end

%Tube Diamter (meters)
d=1.81*10^-2;

%Tube Length (meters)
L=23*10^-2;

%Fluid Velocity (average)

for i= 1:length(d)
   Vfluid(i)=Q/(2^10*pi*(d/2)^2);
end


% Reynlods Number
for i= 1:length(diameterp)
    Re(i)=Vfluid*d/(kinematicviscosity);
end


%Stokes Number
for i= 1:length(diameterp)
    Stk(i)=Vfluid*densityp*diameterp(i)^2*Cc/(18*kinematicviscosity*d);
end


%tube angle radians 
theta=-pi/4;

%kappa
for i= 1:length(diameterp)
    kappa(i)=(3/4)*(Vsettling(i)*(Vfluid).^-1)*L*cos(theta)/d;
end

%Probability of gravitational setimentation


%for i= 1:length(diameterp)
 %   Ps(i)=(2/pi)*((2*kappa(i)*(1-kappa(i).^(2/3)).^(1/2))-(kappa(i).^(1/3))*((1-kappa(i).^(2/3)).^(1/2))+(asin((kappa(i).^(1/3)))));
%end
for i= 1:length(diameterp)
    Ps(i)=1-exp(-16*kappa(i)/(3*pi));
end

%Daughter generation
Daughter=.8;

%Parent generation
Parent=1;

%Probability of impaction deposition
Pi=1.606*Stk+.0023;

%tempreture calvin
Tempreture=310;

%Delta
for i= 1:length(diameterp)
    delta(i)=1.38*10^-23*Tempreture*Cc*L/(12*kinematicviscosity*diameterp(i))*Q.^-1;
end

if delta < .1
    Pd=6.41*delta.^(2/3)-4.8*delta-1.123*delta.^(4/3);
else if .1 < delta < .1653
        Pd=0.164385*(delta^1.15217)*exp(3.94325*exp(-delta)  + 0.219155*(ln(delta))^2+ 0.0346876*((ln(delta)))^3 + 0.00282789*((ln(delta)))^4  + 0.000114505*((ln(delta)))^5   + 1.81798*(10)^(-6)*(ln(delta))^6);
    end
end

for i=1:length(diameterp)
    totalprob(i)=1-(1-Pi(i))*(1-Pd(i))*(1-Ps(i));
end

plot(diameterp,totalprob)

check=Pi+Ps+Pd;
figure
plot(diameterp,check)
