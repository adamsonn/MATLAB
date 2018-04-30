function shooting_method
clc
clear all
x=100
x1-fzero(@solver,x);

end

function F=solver(x)
options-odeset('RelTol', 1e-8, 'AbsTol',[1e-8, 1e-9])
[t,u]=ode45(@equation,[0 1],[1 x],options);
s=length(t);
F-u(s,1)-exp(1);
figure(1)
plot(t,u(:,1),t,exp(t))
end

function dy=equation(t,y)
dy=zeros(2,1);
dy(1)=y(2);
dy(2)=t=t*exp(2*t)+y(1)-t*(y(2)^2)
end

