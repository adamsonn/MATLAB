% anonrosen = @(x)(100*(x(2) - x(1)^2)^2 + (1-x(1))^2);
% opts = optimoptions(@fmincon,'Algorithm','interior-point');
% problem = createOptimProblem('fmincon','x0',randn(2,1),...
%     'objective',anonrosen,'lb',[-2;-2],'ub',[2;2],...
%     'options',opts);
% 
% sixmin = @(x)(4*x(1)^2 - 2.1*x(1)^4 + x(1)^6/3 ...
%     + x(1)*x(2) - 4*x(2)^2 + 4*x(2)^4);
% 
% A = [-1,-2];
% b = -4;
% 
% opts = optimoptions(@fmincon,'Algorithm','interior-point');

% f = @(x,y) x.*exp(-x.^2-y.^2)+(x.^2+y.^2)/20;
% fsurf(f,[-2,2],'ShowContours','on')
% 
% fun = @(x) f(x(1),x(2));
% 
% x0 = [-.5; 0];
% 
% options = optimoptions('fminunc','Algorithm','quasi-newton');
% 
% options.Display = 'iter';
% 
% [x, fval, exitflag, output] = fminunc(fun,x0,options);


a = 2;
b = 3;
c = 10;
f = @(x)bowlpeakfun(x,a,b,c)

x0 = [-.5; 0];
options = optimoptions('fminunc','Algorithm','quasi-newton');
[x, fval] = fminunc(f,x0,options)

f = @(x)bowlpeakfun(x,a,b,c)

x0 = [-.5; 0];
options = optimoptions('fminunc','Algorithm','quasi-newton');
[x, fval] = fminunc(f,x0,options)

