
% Mondo dei blocchi
% Specifica delle azioni mediante precondizioni ed effetti alla STRIPS
% Gli stati sono rappresentati con insiemi ordinati


applicabile(pickup(X),S):-
	block(X),
	ord_memberchk(ontable(X),S),
	ord_memberchk(clear(X),S),
	ord_memberchk(handempty,S).
	
applicabile(putdown(X),S):-
	block(X),
	ord_memberchk(holding(X),S).
	
applicabile(stack(X,Y),S):-
	block(X), block(Y), X\=Y,
	ord_memberchk(holding(X),S),
	ord_memberchk(clear(Y),S).

applicabile(unstack(X,Y),S):-
	block(X), block(Y), X\=Y,
	ord_memberchk(on(X,Y),S),
	ord_memberchk(clear(X),S),
	ord_memberchk(handempty,S).
	
	
	

trasforma(pickup(X),S1,S2):-
	block(X),
	list_to_ord_set([ontable(X),clear(X),handempty],DLS),
	ord_subtract(S1,DLS,S),
	list_to_ord_set([holding(X)],ALS),
	ord_union(S,ALS,S2).
	
trasforma(putdown(X),S1,S2):-
	block(X),
	list_to_ord_set([holding(X)],DLS),
	ord_subtract(S1,DLS,S),
	list_to_ord_set([ontable(X),clear(X),handempty],ALS),
	ord_union(S,ALS,S2).

trasforma(stack(X,Y),S1,S2):-
	block(X), block(Y), X\=Y,
	list_to_ord_set([holding(X),clear(Y)],DLS),
	ord_subtract(S1,DLS,S),
	list_to_ord_set([on(X,Y),clear(X),handempty],ALS),
	ord_union(S,ALS,S2).

trasforma(unstack(X,Y),S1,S2):-
	block(X), block(Y), X\=Y,
	list_to_ord_set([on(X,Y),clear(X),handempty],DLS),
	ord_subtract(S1,DLS,S),
	list_to_ord_set([holding(X),clear(Y)],ALS),
	ord_union(S,ALS,S2).
