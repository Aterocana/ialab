
location(table).
location(X) :- block(X).

#const lastlev=8.

level(0..lastlev).
state(0..lastlev+1).


% AZIONI

action(move(X,Y)):- block(X), location(Y), X!=Y.

1{occurs(A,S): action(A)}1:- level(S).

% FLUENTI

fluent(on(X,Y)):- block(X), location(Y), X!=Y.

% EFFETTI

holds(on(X,Y),S+1) :- occurs(move(X,Y),S), state(S).

% PRECONDIZIONI

:- occurs(move(X,Y),S),
   1 { holds(on(A,X),S),
       holds(on(B,Y),S) : Y != table }.
       
% PERSISTENZA

holds(on(X,Y),S+1):-
	holds(on(X,Y),S), state(S),
	not -holds(on(X,Y),S+1).
       
% REGOLE CAUSALI

-holds(on(X,Y),S):- holds(on(X,L),S), 
	state(S), location(Y), location(L), block(X), L!=Y.
	
-holds(on(X,Y),S):- holds(on(B,Y),S), 
	state(S), block(Y), block(X), block(B), B!=X.

% GOAL

:- not goal.



% ESEMPIO 4

block(a). block(b). block(c). block(d). block(e).
block(f). block(g). block(h). block(i).

holds(on(a,b),0).
holds(on(b,c),0).
holds(on(c,table),0).
holds(on(d,e),0).
holds(on(e,table),0).
holds(on(f,table),0).
holds(on(g,h),0).
holds(on(h,i),0).
holds(on(i,table),0).


goal:- holds(on(a,b),lastlev+1),
	holds(on(b,c),lastlev+1),
	holds(on(c,g),lastlev+1),
	holds(on(g,table),lastlev+1),
	holds(on(d,e),lastlev+1),
	holds(on(e,f),lastlev+1),
	holds(on(f,table),lastlev+1),
	holds(on(h,i),lastlev+1),
	holds(on(i,table),lastlev+1).

	


#hide.
#show occurs/2.

