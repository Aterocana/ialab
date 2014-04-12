
ric_amp([nodo(S,LISTA_AZ)|_],LISTA_AZ):- finale(S).
ric_amp([nodo(S,LISTA_AZ)|RESTO],SOL):-
	espandi(nodo(S,LISTA_AZ),LISTA_SUCC),
	append(RESTO,LISTA_SUCC,CODA),
	ric_amp(CODA,SOL).


espandi(nodo(S,LISTA_AZ),LISTA_SUCC):-
	findall(AZ,applicabile(AZ,S),AZIONI),

	successori(nodo(S,LISTA_AZ),AZIONI,LISTA_SUCC).
	
successori(_,[],[]).
successori(nodo(S,LISTA_AZ),[AZ|RESTO],
					[nodo(NUOVO_S,NUOVA_LISTA_AZ)|ALTRI]):-
	trasforma(AZ,S,NUOVO_S),
	append(LISTA_AZ,[AZ],NUOVA_LISTA_AZ),
	successori(nodo(S,LISTA_AZ),RESTO,ALTRI).
	

ampiezza:- iniziale(S),
	ric_amp([nodo(S,[])],SOL), write(SOL).


