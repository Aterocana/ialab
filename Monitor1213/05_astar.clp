(defmodule ASTAR (import AGENT ?ALL) (export ?ALL))

(defrule astar-clean1
		(declare (salience 150))
?f <-	(lastnode)
	=>
		(retract ?f)
)

(defrule astar-clean2
		(declare (salience 150))
		(temporary_target (pos-x ?x1) (pos-y ?y1))
		(not(costo-check (pos-r ?x1) (pos-c ?y1)))
?f <-	(path)
	=>
		(retract ?f)
)

;; La regola "move" del modulo AGENT 
(defrule astar-clean3
		(declare (salience 149))
?f <-	(path (id ?id) (oper ?oper))
	=>
		(assert (path-star (id ?id) (oper ?oper)))
		(retract ?f)
)

(defrule astar-clean4
		(declare (salience 149))
		(not(costo-check))
?f <-	(last-direction)
	=>
		(retract ?f)
)

(defrule astar-clean5
		(declare (salience 149))
		(not(costo-check))
?f <-	(path-star)
	=>
		(retract ?f)
)

;; Regola per far partire A*
;; in questa regola si può spostare in buona parte il contenuto di contol-astar
(defrule astar-go
		(declare (salience 100))
		(status (step ?s))
		(perc-vision (step ?s) (pos-r ?r) (pos-c ?c) (direction ?dir))
		(temporary_target (pos-x ?x1) (pos-y ?y1))
?f <-  	(dummy_target)
		(not(costo-check (pos-r ?x1) (pos-c ?y1)))
	=>
		
		(printout t "Da: ("?r", "?c") " crlf)
		(printout t "A: ("?x1", "?y1") " crlf)
	
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
                (direction ?dir) 
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
