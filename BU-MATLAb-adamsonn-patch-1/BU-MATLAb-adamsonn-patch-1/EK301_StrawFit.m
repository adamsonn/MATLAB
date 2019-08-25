%%  EK 301 Truss Project Straw buckling strength/length relationship
% C Farny, Spring 2013

% 3 fits are determined: linear, Euler, power law
% Report the fit coefficients, fit form, and length-dependent uncertainty
% on the basis of the lowest total fit uncertainty.

% specify data file name, where column 1 is the length in cm and column 2 is
% force in N
% data = csvread('strawdata_test.csv'); 
force = Fstraw;
% 
% len = data(:,1); 
% force = data(:,2);

% sort data
[len,sortidx] = sort(len);
force = force(sortidx);

% hist(len,10);
% xlabel('Bins of Lengths (cm)'); ylabel('Number of points in each bin');

[N, X] = hist(len,10);
dumpidx = [];
currentidx = 1;
for Nval=N
    mf = mean(force(currentidx:currentidx+Nval-1));
    stdevf = std(force(currentidx:currentidx+Nval-1));
    lidx = find(abs(force(currentidx:currentidx+Nval-1)-mf) > 2*stdevf);
    dumpidx = [dumpidx; (currentidx-1)+lidx];
    currentidx = currentidx+Nval;
end
dumpedlen = len(dumpidx);
dumpedforce = force(dumpidx);
len(dumpidx) = [];
force(dumpidx) = [];

% Read straw data
if 0
    s = input('Enter path to folder that has *.xls files(default is current folder):','s');
    if isempty(s)
        pathtoxls = '*';
    else
        pathtoxls = [s '\*'];
    end
    d = dir([pathtoxls '.xls']);
    len = [];
    force = [];
    for i = 1:length(d)
        data = xlsread(d(i).name, 'Sheet1' ,'c12:d100');
        if ~isempty(data)
            len = [len; data(:,1)];
            force = [force; data(:,2)];
            disp(d(i).name);
            disp('Length(cm)  Load(N)');
            disp(data);
        else
            warning(['warning: File is empty:' d(i).name]);
        end
    end
end

% ------ Linear fit ----------
X = [len];
coeff_fit = X\force;
% ----- PLOT DATA ------- 
figure
ap = plot(len,force,'k+'); 
grid on
hold on
len_fit = (min(len):(max(len)-min(len))*2/length(len):max(len))';
% ------ Euler fit, F = A/L^2, or ln(F) = ln(A)-2*ln(L) ---------
X = [len.^-2];
lnx = -2*log(len);
lny = log(force);

A_range = linspace(1,2e3,15e3);
a0_range = log(A_range);
for a0cnt = 1:length(a0_range)
    ydiff = lny-lnx-a0_range(a0cnt);
    mincheck(a0cnt) = sqrt(sum(ydiff).^2);
end
[a p] = min(abs(mincheck));
a0_nl = a0_range(p);
force_nlfit = a0_nl+lnx;
% nonlinearize
coeff_euler = exp(a0_nl)
% apply fit in NL domain
F_euler = coeff_euler*X;
% calculate uncertainty
fd = force_nlfit-lny;
Syx_nl = sqrt(sum(fd.^2)/(length(len)-2));
UpF_nl = 1.96*Syx_nl/sqrt(length(len));
% Ul_euler_lin = exp(-UpF_nl/2);
Ul_euler_lin = exp(UpF_nl);
% total uncertainty:
U_euler = coeff_euler*Ul_euler_lin./(2*len.^3);
% U_euler_coeff to sum it up:
U_euler_coeff = coeff_euler*Ul_euler_lin/2;
disp(['Length-dependent Euler uncertainty: U_force = ',num2str(U_euler_coeff),'/L^3'])
disp('where length L is in centimeters and U_force is in Newtons.')
disp(['Total fit uncertainty for Euler fit: ',num2str(Ul_euler_lin),' N'])
% --- plot ---
bp = plot(len,F_euler,'b*-');
errorbar(len,F_euler,U_euler)
xlabel(' length L (cm)');
ylabel(' Force F (N)');
title('Fits for length vs loading for straw test');
str_euler = sprintf('Euler column fit: F = %.3f / L^2', coeff_euler);

% --- Power law fit F = a*L^b ----------
% linearize, perform lin regression y = a0+a1*x, then nonlinearize
logF = log(force);
logL = log(len);
sumx = sum(logL);
sumy = sum(logF);
sumxy = sum(logL.*logF);
sumx2 = sum(logL.^2);
sumy2 = sum(logF.^2);
N = length(len);
meany = mean(logF);
stdy = std(logF);
% fit coefficients:
a0 = (sumx*sumxy - sumx2*sumy)/(sumx^2-N*sumx2);
a1 = (sumx*sumy - N*sumxy)/(sumx^2-N*sumx2);
logF_pl_fit = a0+a1*logL;
% nonlinearize
powerlaw = a1;
coeff_power = exp(a0);
F_power = coeff_power*len.^powerlaw;
% Uncertainty:
fd_pl = logF_pl_fit-logF;
Syx_pl = sqrt(sum(fd_pl.^2)/(length(len)-2));
UpF_pl = 1.96*Syx_pl/sqrt(length(len));
% Ul_pl_lin = exp(-UpF_pl/a1);
Ul_pl_lin = exp(UpF_pl);
    % total uncertainty
U_power_exp = abs(powerlaw-1);
U_power = coeff_power*Ul_pl_lin./(abs(powerlaw)*len.^U_power_exp);
    % U_power_coeff to sum it up:
U_power_coeff = coeff_power*Ul_pl_lin/(abs(powerlaw));
disp(['Length-dependent power law uncertainty: U_force = ',...
    num2str(U_power_coeff),'/L^',num2str(U_power_exp)])
disp('where length L is in centimeters and U_force is in Newtons.')
disp(['Total fit uncertainty for power law fit: ',num2str(Ul_pl_lin),' N'])

cp = plot(len, F_power,'ks--');%'r');
str_powerfit = sprintf('F = %.3f * L^{%.3f}', coeff_power,powerlaw);
dp = plot(dumpedlen, dumpedforce, 'rx');
str_outliers = 'Outliers';
legend([ap bp cp dp],'Points', str_euler, str_powerfit,str_outliers);
errorbar(len,F_power,U_power,'ks--')

save('EK301_F13_Straw_Analysis.mat','F_power','U_power','F_euler','U_euler',...
    'powerlaw','coeff_power','coeff_euler','dumpedlen','dumpedforce','Ul_euler_lin',...
    'Ul_pl_lin')

