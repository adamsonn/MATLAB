A=[1,2;3,4];
B=[1;2];
Q=[1,2;2,1];
R=-1;
C=Q^(.5);

Ob = obsv(A,C);

% Number of unobservable states
unob = length(A)-rank(Ob);

if unob==0 
disp('observable')
else disp('not observable')
end

Co = ctrb(A,B);
unco=length(A)-rank(Co);
if unob==0 
disp('controllable')
else disp('not controllable')
end


optimalvector=-[R+B'*Q*B]^(-1)*B'*Q*A
[X,L,G]=dare(A,B,Q,R);

steadystate=G