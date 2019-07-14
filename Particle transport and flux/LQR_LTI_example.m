clear all;
%========================================
% Define the system parameters
%========================================
A = [0 1;0 0];
B = [0;1];
x0 = [1;0];

%========================================
% Define the cost
%========================================
p = 10;
C = sqrt(p)*eye(length(A(1,:)));

%========================================
% Define the time span
%========================================
Tend = 5;
dt = 0.01;
T = 0:dt:Tend;

%========================================
% Solve the ARE
%========================================
[K,L,G] = care(A,B,C'*C);

%========================================
% Run the system
%========================================
x = zeros(length(x0),length(T));
x(:,1) = x0;
u = zeros(1,length(T));
u(1) = -B'*K*x(:,1);
for cnt=2:length(T)
    thisx = x(:,cnt-1);
    u(cnt) = -B'*K*thisx;
    x(:,cnt) = thisx + dt*(A*thisx + B*u(cnt));
end

%========================================
% Run the system
%========================================
figure(4)
clf
plot(T,x(1,:),'linewidth',2);
hold on
plot(T,x(2,:),'r','linewidth',2);
grid on
xlabel('time (s)');
ylabel('states');
legend('x_1','x_2');
set(gca,'fontsize',16);

figure(5)
clf
plot(T,u,'linewidth',2);
grid on
xlabel('time (s)');
ylabel('control');
set(gca,'fontsize',16);

blah = 0;
if( blah == 1)
    %========================================
    % For kicks, check out the Bode plot
    %========================================
    G = ss(A-B*B'*K,B,C,0);
    figure(6)
    bode(G);

    figure(7)
    step(G)
end