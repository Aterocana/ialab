#const maxint=8.

row(1..maxint).
col(1..maxint).
diag(1..maxint).

% guess horizontal position for each row

1 {q(R,C): col(C)} 1:- row(R).


% check

% assert that each column may only contain (at most) one queen
:- q(R1,C), q(R2,C), R1 != R2.

% assert that no two queens are in a diagonal from top left to bottom right
:- q(R1,C1), q(R2,C2), R2=R1+N, C2=C1+N, diag(N).

% assert that no two queens are in a diagonal from top right to bottom left 
:- q(R1,C1), q(R2,C2), R2=R1+N, C2=C1-N, diag(N).

#hide.
#show q/2.