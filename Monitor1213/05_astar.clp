(defmodule ASTAR (import AGENT ?ALL) (export ?ALL))

;; DA ELIMINARE, LASCIATA SOLO PERCHE' PUO' TORNARE UTILE PER LO SVILUPPO
; regola per attivare A* sul nuovo target:
; inizializzo i fatti di tipo node, current e lastnode
(defrule astar-go
        (declare (salience 0))
?f1 <-	(astar-go)
        (status (step ?s))
        (perc-vision (step ?s) (pos-r ?r) (pos-c ?c))
?f2 <-  (dummy_target (pos-x ?x1) (pos-y ?y1))
		(temporary_target (pos-x ?x2) (pos-y ?y2))
    =>
        (retract ?f1)
        (retract ?f2)
        (assert (dummy_target (pos-x ?x2) (pos-y ?y2)))
        ;RICORDARSI DI MODIFICARE direction north IN UNA DIREZIONE PARAMETRICA A SECONDA DI DOVE "INIZIA" l'UAV
        (assert (node (ident 0) (gcost 0) (fcost (+ (* (+ (abs (- ?x2 ?r)) (abs (- ?y2 ?c))) 10) 5))
            (father NA) (pos-r ?r) (pos-c ?c) (direction north) (open yes))
        )
        (assert (current (id 0)))
        (assert (lastnode 0))
        (focus ASTAR)
)

(defrule time-ok
    (declare (salience 0))
    (status (step ?s))
    =>
    (assert (astar_checked ?s))
)