%%EK301
% Joseph Angelo, Fall 2013

% Takes a file of  Tester #, Straw Length, Mass of Bucket Weight
% and gives a vector of Force on Straw

% length in centimeters.  mass in grams

data1 = csvread('strawdata_raw_F13.csv');

tester = data1(:,1);
len = data1(:,2); 
grams = data1(:,3);

Fstraw(1:size(data1,1)) = 0;  %initialize force vector
%%
for i = 1:size(data1,1)
    
    %%% Tester Specific 
    if     tester(i) == 1, massArm = 221; DisCog = 14.2; DisBuck = 16.6; DisStraw = 19.8;
    elseif tester(i) == 2, massArm = 220; DisCog = 14.4; DisBuck = 16.6; DisStraw = 19.8;
    elseif tester(i) == 3, massArm = 220; DisCog = 14.5; DisBuck = 16.8; DisStraw = 20.7;
    elseif tester(i) == 4, massArm = 221; DisCog = 14.6; DisBuck = 17.2; DisStraw = 22;
    elseif tester(i) == 5, massArm = 219; DisCog = 14.3; DisBuck = 16.5; DisStraw = 19.75;
    elseif tester(i) == 6, massArm = 220; DisCog = 16.5; DisBuck = 16.4; DisStraw = 20;
    elseif tester(i) == 7, massArm = 220; DisCog = 14.2; DisBuck = 16.7; DisStraw = 19.25;    
    elseif tester(i) == 8, massArm = 222; DisCog = 14.2; DisBuck = 17.4; DisStraw = 19.7;
    elseif tester(i) == 9, massArm = 220; DisCog = 14;   DisBuck = 16.4; DisStraw = 19.5;    
    elseif tester(i) == 10, massArm = 219; DisCog = 14.63; DisBuck = 16.55; DisStraw = 19.88;  
    elseif tester(i) == 11, massArm = 222; DisCog = 14.1; DisBuck = 16.6; DisStraw = 19.8;     
    end;
    massArm = massArm/1000; DisCog = DisCog/100; DisBuck = DisBuck/100; DisStraw = DisStraw/100;
    
    %%converts grams to kg, cm to m, and find Force on Straw (newtons)
    Fstraw(i) = (massArm*9.8*DisCog + grams(i)/1000*9.8*DisBuck) /DisStraw;
    
end;
data(:,1) = len; data(:,2) = Fstraw';