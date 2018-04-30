A=[1,2;3,4];
B=[1;0];
Q=[0,0;0,3];
R=3;
C=Q^(.5);


optimalvecotr=-[R+B'*Q*B]^(-1)*B'*Q*A
[X,L,G]=dare(A,B,C,G);

steadystate=G