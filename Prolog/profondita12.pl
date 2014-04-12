% ricerca in profonditˆ

ric_prof(S,[]) :- finale(S), !.
ric_prof(S,[Az|Resto]) :-
     applicabile(Az,S),
     trasforma(Az,S,Nuovo_S),
     ric_prof(Nuovo_S,Resto).





% ricerca in profonditˆ con controllo cicli
% il secondo parametro contiene la lista degi stati
% visitati dallo stato iniziale fino ad S
	
ric_prof_cc(S,_,[]) :- finale(S),!.
ric_prof_cc(S,Visitati,[Az|Resto]) :-
     applicabile(Az,S),
     trasforma(Az,S,Nuovo_S),
     \+ member(Nuovo_S,Visitati),
     ric_prof_cc(Nuovo_S,[S|Visitati],Resto).
