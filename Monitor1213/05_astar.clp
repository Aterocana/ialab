(defmodule ASTAR (import AGENT ?ALL) (export ?ALL))

;Regola per far partire A*
;in questa regola si può spostare in buona parte il contenuto di contol-astar
(defrule astar-go
		(declare (salience 100))
		(status (step ?s))
		(perc-vision (step ?s) (pos-r ?r) (pos-c ?c))
		(temporary_target (pos-x ?x1) (pos-y ?y1))
?f <-  	(dummy_target)
		(not(costo-check))
	=>
		(retract ?f)
        (assert (dummy_target (pos-x ?x1) (pos-y ?y1)))
        (assert 
            (node 
                (ident 0) 
                (gcost 0) 
                (fcost (+ (* (+ (abs (- ?x1 ?r)) (abs (- ?y1 ?c))) 10) 5))
                (father NA) 
                (pos-r ?r) 
                (pos-c ?c)
                (direction north) 
                (open yes)
            )
        )
    	(assert (current (id 0)))
    	(assert (lastnode (id 0)))
		(focus ASTAR-ALGORITHM)
)

;Regola che asserisce il fatto (astar_checked ?s) se A* è andato a buon fine
;quindi se è presente nella kb un fatto di tipo (costo-check (pos-r ?x) (pos-c ?y))
(defrule astar-ok
	(declare (salience 0))
	(status (step ?s))
	(dummy_target (pos-x ?x1) (pos-y ?y1))
	(costo-check (pos-r ?x1) (pos-c ?y1))
	=>
	(assert (astar_checked ?s))
)
