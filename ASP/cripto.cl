% esempio TWO + TWO = FOUR da Russell e Norvig


cifra(t).
cifra(w).
cifra(o).
cifra(f).
cifra(u).
cifra(r).

% riporti
rip(x1).
rip(x2).
rip(x3).

% esattamente un valore per ogni cifra e riporto
1{val(C,0..9)}1:- cifra(C).
1{val(X,0..1)}1:- rip(X).

% valori diversi per ogni cifra
:- val(C1,V), val(C2,V), cifra(C1), cifra(C2), C1!=C2.

% la prima cifra a sinistra di ogni numero non puo' essere 0
:- val(f,0).
:- val(t,0).


% calcolo della somma per le quattro colonne

:- val(o,Vo), val(r,Vr), val(x1,Vx1),
	Vo+Vo != Vr+10*Vx1.
	
:- val(x1,Vx1), val(w,Vw), val(u,Vu), val(x2,Vx2),
	Vx1+Vw+Vw != Vu+10*Vx2.
	
:- val(x2,Vx2), val(t,Vt), val(o,Vo), val(x3,Vx3),
	Vx2+Vt+Vt != Vo+10*Vx3.

:- val(x3,Vx3), val(f,Vf), Vx3 != Vf.


#hide.
#show val/2.


% con un vincolo unico ci mette molto piu' tempo
% :- val(t,Vt), val(w,Vw), val(f,Vf), val(o,Vo), val(u,Vu), val(r,Vr), 
%	((Vt*100+Vw*10+Vo)+(Vt*100+Vw*10+Vo)) != (Vf*1000+Vo*100+Vu*10+Vr).