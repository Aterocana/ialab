
% un solo arco entrante per ogni nodo, tranne la radice

1{in_tree(X,Y,C) : edge(X,Y,C)}1:- node(Y), not root(Y).


% minimizare la somma dei costi

#minimize [in_tree(X,Y,C) = C].




root(a).
node(a). node(b). node(c). node(d). node(e).
edge(a,b,4). edge(a,c,3). edge(c,b,2). edge(c,d,3). 
edge(b,e,4). edge(d,e,5).


#hide.
#show in_tree/3.