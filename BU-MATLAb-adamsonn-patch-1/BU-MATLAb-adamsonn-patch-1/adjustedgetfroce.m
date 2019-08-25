

len=data(:,1);   
Fstraw=data(:,2);
massArm=220;
DisCog=13.59;
DisBuck=16.9;
DisStraw=20;

massArm = massArm/1000;
DisCog = DisCog/100; 
DisBuck = DisBuck/100; 
DisStraw = DisStraw/100;


Fstraw = (massArm*9.8*DisCog + Fstraw/1*9.8*DisBuck) /(9.8*DisStraw);