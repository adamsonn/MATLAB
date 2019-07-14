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
L = 10*eye(length(A(:,1)));
Q = 10*eye(length(A(:,1)));

%========================================
% Define the time span
%========================================
Tend = 5;
dt = 0.01;
T = 0:dt:Tend;

%========================================
% Solve the Riccati equation backwards
%========================================
K = zeros(length(x0),length(x0),length(T));
K(:,:,1) = Q;
for k = 1:length(T)-1
    thisK = K(:,:,k);
    K(:,:,k+1) = thisK - dt*(-A'*thisK-thisK*A+thisK*B*B'*thisK-L);
end

%========================================
% Reverse the solution to K to get it forward in time
%========================================
for cnt=1:length(T)
    frontK(:,:,cnt) = K(:,:,end-(cnt-1));
end
K = frontK;

%========================================
% Run the system
%========================================
x = zeros(length(x0),length(T));
x(:,1) = x0;
u = zeros(1,length(T));
u(1) = -B'*K(:,:,1)*x(:,1);
for cnt=2:length(T)
    thisx = x(:,cnt-1);
    u(cnt) = -B'*K(:,:,cnt)*thisx;
    x(:,cnt) = thisx + dt*(A*thisx + B*u(cnt));
end

figure(1)
clf
plot(T,x(1,:),'linewidth',2);
hold on
plot(T,x(2,:),'r','linewidth',2);
grid on
xlabel('time (s)');
ylabel('states');
legend('x_1','x_2');
set(gca,'fontsize',16);

figure(2)
clf
plot(T,u,'linewidth',2);
grid on
xlabel('time (s)');
ylabel('control');
set(gca,'fontsize',16);

figure(3)
clf
plot(T,reshape(K(1,1,:),length(T),1),'linewidth',2);
hold on
plot(T,reshape(K(1,2,:),length(T),1),'r','linewidth',2);
plot(T,reshape(K(2,2,:),length(T),1),'m','linewidth',2);
grid on
xlabel('time (s)');
ylabel('Gain');
legend('k_{11}','k_{12}','k_{22}');
set(gca,'fontsize',16);
