function depefficent = seven_var(v)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
Q1 = v(1);
Q2 = v(2);
Q3 = v(3);
Q4 = v(4);
Q5 = v(5);
Q6 = v(6);
Q7 = v(7);

depefficent=((Q1.*1.941913308020678e-2-9.977e-1).*((1.020253655873016e-11./Q1).^(2.0./3.0).*(-6.41e2./1.0e2)+(1.020253655873016e-11./Q1).^(4.0./3.0).*1.123+4.897217548190476e-11./Q1+1.0).*(asin((3.883355392576184e-21./Q1).^(1.0./3.0)).*6.366197723675814e-1+(sqrt(-(3.883355392576184e-21./Q1).^(2.0./3.0)+1.0).*4.94444165208854e-21)./Q1-sqrt(-(3.883355392576184e-21./Q1).^(2.0./3.0)+1.0).*(3.883355392576184e-21./Q1).^(1.0./3.0).*6.366197723675814e-1-1.0)-1.0).*((Q5.*6.88841376638122e-1-9.977e-1).*(2.847219504761904e-12./Q5-(5.931707301587301e-13./Q5).^(2.0./3.0).*(6.41e2./1.0e2)+(5.931707301587301e-13./Q5).^(4.0./3.0).*1.123+1.0).*(asin(((-1.105145596709764e-6)./Q5).^(1.0./3.0)).*(-6.366197723675814e-1)+sqrt(-((-1.105145596709764e-6)./Q5).^(2.0./3.0)+1.0).*((-1.105145596709764e-6)./Q5).^(1.0./3.0).*6.366197723675814e-1+(sqrt(-((-1.105145596709764e-6)./Q5).^(2.0./3.0)+1.0).*1.407115076420809e-6)./Q5+1.0)+1.0).*(((Q3.*1.158850151441078e-1)./pi-9.977e-1).*(asin(((pi.*8.414228400067615e-23)./Q3).^(1.0./3.0)).*6.366197723675814e-1-sqrt(-((pi.*8.414228400067615e-23)./Q3).^(2.0./3.0)+1.0).*((pi.*8.414228400067615e-23)./Q3).^(1.0./3.0).*6.366197723675814e-1+(pi.*sqrt(-((pi.*8.414228400067615e-23)./Q3).^(2.0./3.0)+1.0).*1.071332833739977e-22)./Q3-1.0).*((8.600975587301585e-13./Q3).^(2.0./3.0).*(-6.41e2./1.0e2)+(8.600975587301585e-13./Q3).^(4.0./3.0).*1.123+4.128468281904761e-12./Q3+1.0)-1.0).*((Q2.*2.551264357918972e-2-9.977e-1).*(5.039578523428571e-12./Q2-(1.049912192380952e-12./Q2).^(2.0./3.0).*(6.41e2./1.0e2)+(1.049912192380952e-12./Q2).^(4.0./3.0).*1.123+1.0).*(asin((5.19348125067304e-7./Q2).^(1.0./3.0)).*6.366197723675814e-1+(sqrt(-(5.19348125067304e-7./Q2).^(2.0./3.0)+1.0).*6.612545703197546e-7)./Q2-sqrt(-(5.19348125067304e-7./Q2).^(2.0./3.0)+1.0).*(5.19348125067304e-7./Q2).^(1.0./3.0).*6.366197723675814e-1-1.0)-1.0).*(((Q4.*7.422722398589064e-1)./pi-9.977e-1).*((4.982634133333333e-13./Q4).^(2.0./3.0).*(-6.41e2./1.0e2)+(4.982634133333333e-13./Q4).^(4.0./3.0).*1.123+2.391664384e-12./Q4+1.0).*(asin(((pi.*1.811538929848541e-7)./Q4).^(1.0./3.0)).*6.366197723675814e-1-sqrt(-((pi.*1.811538929848541e-7)./Q4).^(2.0./3.0)+1.0).*((pi.*1.811538929848541e-7)./Q4).^(1.0./3.0).*6.366197723675814e-1+(pi.*sqrt(-((pi.*1.811538929848541e-7)./Q4).^(2.0./3.0)+1.0).*2.30652300231038e-7)./Q4-1.0)-1.0).*(((Q7.*9.429606602652034)./pi-9.977e-1).*((8.30439022222222e-14./Q7).^(2.0./3.0).*(-6.41e2./1.0e2)+(8.30439022222222e-14./Q7).^(4.0./3.0).*1.123+3.986107306666666e-13./Q7+1.0).*(asin(((pi.*(-2.508048299364036e-8))./Q7).^(1.0./3.0)).*(-6.366197723675814e-1)+sqrt(-((pi.*(-2.508048299364036e-8))./Q7).^(2.0./3.0)+1.0).*((pi.*(-2.508048299364036e-8))./Q7).^(1.0./3.0).*6.366197723675814e-1+(pi.*sqrt(-((pi.*(-2.508048299364036e-8))./Q7).^(2.0./3.0)+1.0).*3.193346274856065e-8)./Q7+1.0)+1.0).*((Q6.*1.366197999293623-9.977e-1).*(asin(((-2.34752526523418e-7)./Q6).^(1.0./3.0)).*(-6.366197723675814e-1)+(sqrt(-((-2.34752526523418e-7)./Q6).^(2.0./3.0)+1.0).*2.988961999961059e-7)./Q6+sqrt(-((-2.34752526523418e-7)./Q6).^(2.0./3.0)+1.0).*((-2.34752526523418e-7)./Q6).^(1.0./3.0).*6.366197723675814e-1+1.0).*((1.720195117460317e-13./Q6).^(2.0./3.0).*(-6.41e2./1.0e2)+(1.720195117460317e-13./Q6).^(4.0./3.0).*1.123+8.256936563809521e-13./Q6+1.0)+1.0);
end

