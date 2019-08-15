gravity=9.81;

%Flow Rate m^3/s
%Q=[.001:.01:30]
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

syms Q L d Dd phi


%Tube Length (meters)

%Fluid Velocity (average)
Vfluid=Q/(pi*(d/2)^2);

% Reynlods Number
Re=Vfluid*d/(kinematicviscosity);

%Stokes Number
Stk=Vfluid*densityp*diameterp^2*Cc/(18*kinematicviscosity*d);

%tube angle radians 
theta=phi;

%kappa
kappa=(3/4)*(Vsettling*(Vfluid).^-1)*L*cos(theta)/d;

%Probability of gravitational setimentation

for i= 1:length(Q)
    
    Ps(i)=(2/pi)*((2*kappa(i)*(1-kappa(i).^(2/3)).^(1/2))-(kappa(i).^(1/3))*((1-kappa(i).^(2/3)).^(1/2))+(asin((kappa(i).^(1/3)))));
    
%     if Ps(i)>1
%         Ps(i)=1;
%     end
%     if Ps(i)<0
%         Ps(i)=0;
%     end
end



%Daughter generation
Daughter=.8;

%Parent generation
Parent=1;

%Probability of impaction deposition


Pi=1.606*Stk+.0023;

% for i=length(Stk)
%  if Pi(i)>1
%         Pi(i)=1;
%  end
% end
    

%tempreture calvin
Tempreture=310;

%Delta
syms delta
delta=1.38*10^-23*Tempreture*Cc*L/(12*kinematicviscosity*diameterp)*Q.^-1;

syms delta
%
Pd=piecewise(delta<.1, 6.41*delta.^(2/3)-4.8*delta-1.123*delta.^(4/3), .1653>delta>0.1, 0.164385*(delta^1.15217)*exp(3.94325*exp(-delta)  + 0.219155*(log(delta))^2+ 0.0346876*((log(delta)))^3 + 0.00282789*((log(delta)))^4  + 0.000114505*((log(delta)))^5   + 1.81798*(10)^(-6)*(log(delta))^6),delta >.1653,1);
% for i=1:length(delta)
%     if delta < .1
%     Pd(i)=6.41*delta(i).^(2/3)-4.8*delta(i)-1.123*delta(i).^(4/3);
%     else if .1 < delta < .1653
         Pd=0.164385*(delta(i)^1.15217)*exp(3.94325*exp(-delta(i))  + 0.219155*(log(delta(i)))^2+ 0.0346876*((log(delta(i))))^3 + 0.00282789*((log(delta(i))))^4  + 0.000114505*((log(delta(i))))^5   + 1.81798*(10)^(-6)*(log(delta(i)))^6);
%     else
%             Pd(i)=1;
%         end
%     end
% end

% for i=length(Q)
% if Pd(i)>1
%         Pd(i)=1;
%     end
%     if Pd(i)<0
%         Pd(i)=0;
%     end
% end

for i=1:length(Q)
    totalprob(i)=1-(1-Pi(i))*(1-Pd(i))*(1-Ps(i));
end

totalprob=1-(1-Pi)*(1-Pd)*(1-Ps);
b=gradient(totalprob);
totalprobf = matlabFunction(totalprob);
bf=matlabFunction(b);