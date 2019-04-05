%Gravitatonal Constant m/s^2 
gravity=9.81; 
  
%Flow Rate m^3/s 
Q=[0.5*10^-11:1*10^-7:20*10^-4]; 
  
%Particle Density (water kg/m^3) 
densityp= 1000; 

phi=45;

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
N=1; 
  
%Tube Diamter (meters) 
d=5*LDP(i,2)*10^-3; 
  
  
  
%Tube Length (meters) 
L=LDP(i,1)*10^-3; 
  
%Fluid Velocity (average) 
Vfluid=Q/(pi*(d/2)^2); 
  
% Reynlods Number 
Re=Vfluid*d/(kinematicviscosity); 
  
%Stokes Number 
Stk=Vfluid*densityp*diameterp^2*Cc/(18*kinematicviscosity*d); 
  
%tube angle radians  
theta=33; 
  
%kappa 
kappa=(3/4)*(Vsettling*(Vfluid).^-1)*L*cos(phi*(pi/180))/d;
  
%Probability of gravitational setimentation 
  
for i= 1:length(Q) 
     
    Ps(i)=(2/pi)*((2*kappa(i)*(1-kappa(i).^(2/3)).^(1/2))-(kappa(i).^(1/3))*((1-kappa(i).^(2/3)).^(1/2))+(asin((kappa(i).^(1/3))))); 
     
    if Ps(i)>1 
        Ps(i)=1; 
    end 
    if Ps(i)<0 
        Ps(i)=0; 
    end 
end 
  
  
  
%Daughter generation 
Daughter=.8; 
  
%Parent generation 
Parent=1; 
  
%Probability of impaction deposition 
  
  
Pi=1.3*(Stk-.001);
  

i=1;
for i=length(Stk) 
 if Pi(i)>1 
        Pi(i)=1; 

 end 
end 
    
u=1;
Pi=1.3*(Stk-.001);
 i=1; 
while i<length(Stk)+1 
 if Pi(i)<0
     Pi(i)=0;
     i=i+1;
 else
 Pi(i)=Pi(i);
 i=i+1;
 end
end
 
i=1;
while i<length(Stk)+1
 if Pi(i)>1
        Pi(i)=1;
        i=i+1;
 else
 Pi(i)=Pi(i);
 i=i+1;
 end
 end

%Pi(1:200000)=0;
%tempreture calvin 
Tempreture=310; 
  
%Delta 
delta=1.38*10^-23*Tempreture*Cc*L/(((d/2)^2)*12*kinematicviscosity*diameterp)*Q.^-1; 
for i=1:length(delta) 
    if delta(i) < .1 
    Pd(i)=6.41*delta(i).^(2/3)-4.8*delta(i)-1.123*delta(i).^(4/3); 
    else if .1 < delta < .1653 
        Pd=0.164385*(delta(i)^1.15217)*exp(3.94325*exp(-delta(i))  + 0.219155*(ln(delta(i)))^2+ 0.0346876*((ln(delta(i))))^3 + 0.00282789*((ln(delta(i))))^4  + 0.000114505*((ln(delta(i))))^5   + 1.81798*(10)^(-6)*(ln(delta(i)))^6); 
    else 
            Pd(i)=1; 
        end 
    end 
end 
  
for i=length(Q) 
if Pd(i)>1 
        Pd(i)=1; 
    end 
    if Pd(i)<0 
        Pd(i)=0; 
    end 
end 
  
for i=1:length(Q) 
    totalprob(i)=1-(1-Pi(i))*(1-Pd(i))*(1-Ps(i)); 
end 

Q=Q*1000;
plot(Q,totalprob,'LineWidth',3) 
  
hold on  
plot(Q,Pi,'LineWidth',3) 
plot(Q,Ps,'LineWidth',3) 
plot(Q,Pd,'LineWidth',3) 
  
legend('Totalprob','Impaction','Gravity','Diffusion') 
  
title('Length of tube=23cm Dtube=1.8cm Dparticle=3.5 micron') 
xlabel('Flow rate L/s') 
ylabel('Probability of Capture') 
  
hold off 

figure 
plot(Q,totalprob,'LineWidth',3) 
  
hold on  
plot(Q,log(Pi),'LineWidth',3) 
plot(Q,log(Ps),'LineWidth',3) 
plot(Q,log(Pd),'LineWidth',3) 
  
legend('Capture Chance','Impaction','Gravity','Diffusion') 
  
title('Length of tube=23cm Dtube=1.8cm Dparticle=3.5 micron Phi=0') 
xlabel('Flow rate L/s') 
ylabel('log(Probability of Capture)') 
  
hold off 
