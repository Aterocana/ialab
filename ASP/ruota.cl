% Problema della ruota di scorta - Russell e Norvig

% I livelli sono rappresentati con gli interi da 0 a lastlev
% Lo stato finale e' lastlev+1

#const lastlev=1.

livello(0..lastlev).
stato(0..lastlev+1).

% AZIONI (possono essere eseguite in parallelo)

1{rimuovi(scorta,bagagliaio,S), rimuovi(bucata,asse,S), monta(scorta,asse,S)} :- 
	livello(S).

% EFFETTI

-posizione(scorta,bagagliaio,S+1):-
	rimuovi(scorta,bagagliaio,S), stato(S).
posizione(scorta,pavimento,S+1):-
	rimuovi(scorta,bagagliaio,S), stato(S).
	
-posizione(bucata,asse,S+1):-
	rimuovi(bucata,asse,S), stato(S).
posizione(bucata,pavimento,S+1):-
	rimuovi(bucata,asse,S), stato(S).

-posizione(scorta,pavimento,S+1):-
	monta(scorta,asse,S), stato(S).
posizione(scorta,asse,S+1):-
	monta(scorta,asse,S), stato(S).
	
% PRECONDIZIONI

:- rimuovi(scorta,bagagliaio,S), not posizione(scorta,bagagliaio,S).

:- rimuovi(bucata,asse,S), not posizione(bucata,asse,S).

:- monta(scorta,asse,S), not posizione(scorta,pavimento,S).
:- monta(scorta,asse,S), posizione(bucata,asse,S).

% PERSISTENZA

posizione(X,Y,S+1):-
	posizione(X,Y,S), stato(S),
	not -posizione(X,Y,S+1).
-posizione(X,Y,S+1):-
	-posizione(X,Y,S), stato(S),
	not posizione(X,Y,S+1).

% STATO INIZIALE

posizione(bucata,asse,0).
posizione(scorta,bagagliaio,0).
-posizione(bucata,pavimento,0).
-posizione(scorta,pavimento,0).
-posizione(scorta,asse,0).


% GOAL

goal:- posizione(scorta,asse,lastlev+1).
:- not goal.


#hide.
#show rimuovi/3.
#show monta/3.