(defmodule EXIT (import AGENT ?ALL) (export ?ALL))

;Però non sappiamo in che direzione sarà l'UAV.
;Non possiamo inizializzare node con direction north
(defrule exit-go
		(declare (salience 100))
		(status (step ?s))
		;(perc-vision (step ?s) (pos-r ?r) (pos-c ?c))
		(prior_cell (pos-r ?x1) (pos-c ?y1) (type gate))
		(temporary_target (pos-x ?r) (pos-y ?c))
?f1 <-  	(dummy_target)
		(not(costo-check))
?f2	<-	(last-direction (direction ?dir))
	=>
		(retract ?f1)
		(retract ?f2)
        (assert (dummy_target (pos-x ?x1) (pos-y ?y1)))
        (assert 
            (node 
                (ident 0) 
                (gcost 0) 
                (fcost (+ (* (+ (abs (- ?x1 ?r)) (abs (- ?y1 ?c))) 10) 5))
                (father NA) 
                (pos-r ?r) 
                (pos-c ?c)
                (direction ?dir) 
                (open yes)
            )
        )
    	(assert (current (id 0)))
    	(assert (lastnode (id 0)))
		(focus ASTAR-ALGORITHM)
)

(defrule exit-clean1
		(declare (salience 50))
?f <-	(path)
	=>
		(retract ?f)
)

(defrule exit-ok
		(declare (salience 0))
		(status (step ?s))
?f1 <-	(costo-check)
    =>
		(retract ?f1)
		(assert (exit_checked ?s))
		(pop-focus)
)