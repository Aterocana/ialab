
 flies(X) :- bird(X), not -flies(X).
-flies(X) :- penguin(X).

bird(tux).     penguin(tux).
bird(tweety).  
