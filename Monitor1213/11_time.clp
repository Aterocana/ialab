(defmodule TIME (import AGENT ?ALL) (export ?ALL))

;; Eseguo questa regola per ogni gate. Intendo valutare il costo di 
;; raggiungimento dello stesso a partire dalla posizione attuale
(defrule astar-exit
    (declare (salience 10))
    (prior_cell (pos-r ?x) (pos-c ?y) (type gate))
    (status (step ?s))
    (perc-vision (step ?s) (direction ?dir) (pos-r ?r) (pos-c ?c))
    (not (costo-check (pos-r ?x) (pos-c ?y)))     
    =>
    (assert (dummy_target (pos-x ?x) (pos-y ?y)))
    (assert 
        (node 
            (ident 0) 
            (gcost 0) 
            (fcost (+ (* (+ (abs (- ?x ?r)) (abs (- ?y ?c))) 10) 5))
            (father NA) 
            (pos-r ?r) 
            (pos-c ?c) 
            (direction ?dir) 
            (open yes)
        )
    )
    (assert (current (id 0)))
    (assert (lastnode 0))
    (focus ASTAR)
)

;; controllo se effettivamente è stata trovata un'uscita. Se sì, mi salvo il 
;; costo migliore tra quelli trovati (potrebbero essere raggiungibili più 
;; uscite) per poi confrontarlo con il tempo.

;; DA FINIRE
(defrule check-exit-cost
    (declare salience 10)
    (prior cell (pos-r ?x) (pos-c ?y) (type gate))
    (costo-check (cost ?g))
    (costo-check (pos-r ?x) (pos-c ?y) (cost ?cost&:(< ?cost ?g)))
?f <-(path (target-r ?x) (target-c ?y))
    =>
    (retract ?f)
)