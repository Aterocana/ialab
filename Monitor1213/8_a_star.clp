(defmodule ASTAR-ALGORITHM (import AGENT ?ALL) (export ?ALL))

; ho trovato il nodo target
;ALE: asserisco costo-check
(defrule achieved-goal
    (declare (salience 100))
    (current (id ?curr))
    (dummy_target (pos-x ?x) (pos-y ?y))
    (node (ident ?curr) (pos-r ?x) (pos-c ?y) (gcost ?g) (direction ?dir))
    (not (costo-check (pos-r ?x) (pos-c ?y)))
    => 
    (printout t " Esiste soluzione per goal (" ?x "," ?y ") con costo "  ?g crlf)
    (assert (last (id ?curr)))
    (assert (costo-check (pos-r ?x) (pos-c ?y) (cost ?g)))
	(assert (last-direction (direction ?dir)))
)

(defrule update-achieved-goal
    (declare (salience 100))
    (current (id ?curr))
    (dummy_target (pos-x ?x) (pos-y ?y))
    (node (ident ?curr) (pos-r ?x) (pos-c ?y) (gcost ?g) (direction ?dir))
    ?costo <- (costo-check (pos-r ?x) (pos-c ?y) (cost ?cost&:(> ?cost ?g)))
	?f <- (last-direction)
    => 
    (printout t " Aggiornata la soluzione per goal (" ?x "," ?y ") con costo "  ?g crlf)
    (assert (last (id ?curr)))
    (retract ?costo)
	(retract ?f)
	(assert (last-direction (direction ?dir)))
    (assert (costo-check (pos-r ?x) (pos-c ?y) (cost ?g)))
)

;===========  regole di movimento  =============
; Ogni volta genero, laddove è possibile, fino a tre (uno per ogni operazione 
; possibile) fatti di tipo op-apply-direction (ovvero le celle su cui 
; potenzialmente posso spostarmi) a seconda della direzione in cui sono.
; A questo punto vengono attivate, grazie ai fatti apply, le regole di tipo
; op-exec-direction che mi generano un fatto di tipo newnode che verrà, 
; eventualmente, trasformato in un fatto di tipo node dal modulo NEW.

(defrule go-forward-apply-north
        (declare (salience 50))
        (current (id ?curr))
        (node (ident ?curr) (pos-r ?r) (pos-c ?c) (direction north) (open yes))
        ;(cell (pos-r =(+ ?r 1)) (pos-c ?c) (contains empty|gate))
	(prior_cell (pos-r =(+ ?r 1)) (pos-c ?c) (type gate | lake | rural | urban))
    => 
        (assert (apply (id ?curr) (op go-forward) (direction north) (pos-x ?r) (pos-y ?c)))
)

(defrule go-forward-exec-north
        (declare (salience 50))
        (current (id ?curr))
        (lastnode (id ?n))
?f1 <- 	(apply (id ?curr) (op go-forward) (direction north) (pos-x ?r) (pos-y ?c))
        (node (ident ?curr) (gcost ?g))
        ;(goal ?x ?y)
        (dummy_target (pos-x ?x) (pos-y ?y))		
    =>
        (assert (exec-star (anc ?curr) (id =(+ ?n 1)) (op go-forward) (direction north) (pos-x ?r) (pos-y ?c)))
        (assert	
            (newnode 
                (ident (+ ?n 1)) 
                (pos-r (+ ?r 1)) 
                (pos-c ?c) 
                (direction north)
                (gcost (+ ?g 10)) 
                (fcost (+ (+(*(+(abs (- ?x (+ ?r 1))) (abs (- ?y ?c))) 10) 5) ?g 10))
                (father ?curr)
            )
        )
        (retract ?f1)
        (focus NEW)
)

(defrule right-apply-north
        (declare (salience 50))
        (current (id ?curr))
        (node (ident ?curr) (pos-r ?r) (pos-c ?c) (direction north) (open yes))
        ;(cell (pos-r =(+ ?r 1)) (pos-c ?c) (contains empty|gate))
		(prior_cell (pos-r ?r) (pos-c =(+ ?c 1)) (type gate | lake | rural | urban))

		=> 
		(assert (apply (id ?curr) (op go-right) (direction north) (pos-x ?r) (pos-y ?c)))
)

(defrule right-exec-north
        (declare (salience 50))
        (current (id ?curr))
        (lastnode (id ?n))
?f1 <- 	(apply (id ?curr) (op go-right) (direction north) (pos-x ?r) (pos-y ?c))
        (node (ident ?curr) (gcost ?g))
        ;(goal ?x ?y)
		(dummy_target (pos-x ?x) (pos-y ?y))
		
		=>
		(assert (exec-star (anc ?curr) (id =(+ ?n 2)) (op go-right) (direction north) (pos-x ?r) (pos-y ?c)))
		(assert	(newnode (ident (+ ?n 2)) (pos-r ?r) (pos-c (+ ?c 1)) (direction east)
                (gcost (+ ?g 15)) (fcost (+ (+(*(+(abs (- ?x ?r)) (abs (- ?y (+ ?c 1)))) 10) 5) ?g 15))
				(father ?curr)))
		(retract ?f1)
		(focus NEW)
)

(defrule left-apply-north
        (declare (salience 50))
        (current (id ?curr))
        (node (ident ?curr) (pos-r ?r) (pos-c ?c) (direction north) (open yes))
        ;(cell (pos-r =(+ ?r 1)) (pos-c ?c) (contains empty|gate))
		(prior_cell (pos-r ?r) (pos-c =(- ?c 1)) (type gate | lake | rural | urban))

		=> 
		(assert (apply (id ?curr) (op go-left) (direction north) (pos-x ?r) (pos-y ?c)))
)

(defrule left-exec-north
        (declare (salience 50))
        (current (id ?curr))
        (lastnode (id ?n))
?f1 <- 	(apply (id ?curr) (op go-left) (direction north) (pos-x ?r) (pos-y ?c))
        (node (ident ?curr) (gcost ?g))
        ;(goal ?x ?y)
		(dummy_target (pos-x ?x) (pos-y ?y))
		
		=>
		(assert (exec-star (anc ?curr) (id =(+ ?n 3)) (op go-left) (direction north) (pos-x ?r) (pos-y ?c)))
		(assert	(newnode (ident (+ ?n 3)) (pos-r ?r) (pos-c (- ?c 1)) (direction west)
                (gcost (+ ?g 15)) (fcost (+ (+(*(+(abs (- ?x ?r)) (abs (- ?y (- ?c 1)))) 10) 5) ?g 15))
				(father ?curr)))
		(retract ?f1)
		(focus NEW)
)

(defrule go-forward-apply-west
        (declare (salience 50))
        (current (id ?curr))
        (node (ident ?curr) (pos-r ?r) (pos-c ?c) (direction west) (open yes))
        ;(cell (pos-r =(+ ?r 1)) (pos-c ?c) (contains empty|gate))
		(prior_cell (pos-r ?r) (pos-c =(- ?c 1)) (type gate | lake | rural | urban))

		=> 
		(assert (apply (id ?curr) (op go-forward) (direction west) (pos-x ?r) (pos-y ?c)))
)

(defrule go-forward-exec-west
        (declare (salience 50))
        (current (id ?curr))
        (lastnode (id ?n))
?f1 <- 	(apply (id ?curr) (op go-forward) (direction west) (pos-x ?r) (pos-y ?c))
        (node (ident ?curr) (gcost ?g))
        ;(goal ?x ?y)
		(dummy_target (pos-x ?x) (pos-y ?y))
		
		=>
		(assert (exec-star (anc ?curr) (id =(+ ?n 4)) (op go-forward) (direction west) (pos-x ?r) (pos-y ?c)))
		(assert	(newnode (ident (+ ?n 4)) (pos-r ?r) (pos-c (- ?c 1)) (direction west)
                (gcost (+ ?g 10)) (fcost (+ (+(*(+(abs (- ?x ?r)) (abs (- ?y (- ?c 1)))) 10) 5) ?g 10))
				(father ?curr)))
		(retract ?f1)
		(focus NEW)
)

(defrule right-apply-west
        (declare (salience 50))
        (current (id ?curr))
        (node (ident ?curr) (pos-r ?r) (pos-c ?c) (direction west) (open yes))
        ;(cell (pos-r =(+ ?r 1)) (pos-c ?c) (contains empty|gate))
		(prior_cell (pos-r =(+ ?r 1)) (pos-c ?c) (type gate | lake | rural | urban))

		=> 
		(assert (apply (id ?curr) (op go-right) (direction west) (pos-x ?r) (pos-y ?c)))
)

(defrule right-exec-west
        (declare (salience 50))
        (current (id ?curr))
        (lastnode (id ?n))
?f1 <- 	(apply (id ?curr) (op go-right) (direction west) (pos-x ?r) (pos-y ?c))
        (node (ident ?curr) (gcost ?g))
        ;(goal ?x ?y)
		(dummy_target (pos-x ?x) (pos-y ?y))
		
		=>
		(assert (exec-star (anc ?curr) (id =(+ ?n 5)) (op go-right) (direction west) (pos-x ?r) (pos-y ?c)))
		(assert	(newnode (ident (+ ?n 5)) (pos-r (+ ?r 1)) (pos-c ?c) (direction north)
                (gcost (+ ?g 15)) (fcost (+ (+(*(+(abs (- ?x (+ ?r 1))) (abs (- ?y ?c))) 10) 5) ?g 15))
				(father ?curr)))
		(retract ?f1)
		(focus NEW)
)

(defrule left-apply-west
        (declare (salience 50))
        (current (id ?curr))
        (node (ident ?curr) (pos-r ?r) (pos-c ?c) (direction west) (open yes))
        ;(cell (pos-r =(+ ?r 1)) (pos-c ?c) (contains empty|gate))
		(prior_cell (pos-r =(- ?r 1)) (pos-c ?c) (type gate | lake | rural | urban))

		=> 
		(assert (apply (id ?curr) (op go-left) (direction west) (pos-x ?r) (pos-y ?c)))
)

(defrule left-exec-west
        (declare (salience 50))
        (current (id ?curr))
        (lastnode (id ?n))
?f1 <- 	(apply (id ?curr) (op go-left) (direction west) (pos-x ?r) (pos-y ?c))
        (node (ident ?curr) (gcost ?g))
        ;(goal ?x ?y)
		(dummy_target (pos-x ?x) (pos-y ?y))
		
		=>
		(assert (exec-star (anc ?curr) (id =(+ ?n 6)) (op go-left) (direction west) (pos-x ?r) (pos-y ?c)))
		(assert	(newnode (ident (+ ?n 6)) (pos-r (- ?r 1)) (pos-c ?c) (direction south)
                (gcost (+ ?g 15)) (fcost (+ (+(*(+(abs (- ?x (- ?r 1))) (abs (- ?y ?c))) 10) 5) ?g 15))
				(father ?curr)))
		(retract ?f1)
		(focus NEW)
)

(defrule go-forward-apply-east
        (declare (salience 50))
        (current (id ?curr))
        (node (ident ?curr) (pos-r ?r) (pos-c ?c) (direction east) (open yes))
        ;(cell (pos-r =(+ ?r 1)) (pos-c ?c) (contains empty|gate))
		(prior_cell (pos-r ?r) (pos-c =(+ ?c 1)) (type gate | lake | rural | urban))

		=> 
		(assert (apply (id ?curr) (op go-forward) (direction east) (pos-x ?r) (pos-y ?c)))
)

(defrule go-forward-exec-east
        (declare (salience 50))
        (current (id ?curr))
        (lastnode (id ?n))
?f1 <- 	(apply (id ?curr) (op go-forward) (direction east) (pos-x ?r) (pos-y ?c))
        (node (ident ?curr) (gcost ?g))
        ;(goal ?x ?y)
		(dummy_target (pos-x ?x) (pos-y ?y))
		
		=>
		(assert (exec-star (anc ?curr) (id =(+ ?n 7)) (op go-forward) (direction east) (pos-x ?r) (pos-y ?c)))
		(assert	(newnode (ident (+ ?n 7)) (pos-r ?r) (pos-c (+ ?c 1)) (direction east)
                (gcost (+ ?g 10)) (fcost (+ (+(*(+(abs (- ?x ?r)) (abs (- ?y (+ ?c 1)))) 10) 5) ?g 10))
				(father ?curr)))
		(retract ?f1)
		(focus NEW)
)

(defrule right-apply-east
        (declare (salience 50))
        (current (id ?curr))
        (node (ident ?curr) (pos-r ?r) (pos-c ?c) (direction east) (open yes))
        ;(cell (pos-r =(+ ?r 1)) (pos-c ?c) (contains empty|gate))
		(prior_cell (pos-r =(- ?r 1)) (pos-c ?c) (type gate | lake | rural | urban))

		=> 
		(assert (apply (id ?curr) (op go-right) (direction east) (pos-x ?r) (pos-y ?c)))
)

(defrule right-exec-east
        (declare (salience 50))
        (current (id ?curr))
        (lastnode (id ?n))
?f1 <- 	(apply (id ?curr) (op go-right) (direction east) (pos-x ?r) (pos-y ?c))
        (node (ident ?curr) (gcost ?g))
        ;(goal ?x ?y)
		(dummy_target (pos-x ?x) (pos-y ?y))
		
		=>
		(assert (exec-star (anc ?curr) (id =(+ ?n 8)) (op go-right) (direction east) (pos-x ?r) (pos-y ?c)))
		(assert	(newnode (ident (+ ?n 8)) (pos-r (- ?r 1)) (pos-c ?c) (direction south)
                (gcost (+ ?g 15)) (fcost (+ (+(*(+(abs (- ?x (- ?r 1))) (abs (- ?y ?c))) 10) 5) ?g 15))
				(father ?curr)))
		(retract ?f1)
		(focus NEW)
)

(defrule left-apply-east
        (declare (salience 50))
        (current (id ?curr))
        (node (ident ?curr) (pos-r ?r) (pos-c ?c) (direction east) (open yes))
        ;(cell (pos-r =(+ ?r 1)) (pos-c ?c) (contains empty|gate))
		(prior_cell (pos-r =(+ ?r 1)) (pos-c ?c) (type gate | lake | rural | urban))

		=> 
		(assert (apply (id ?curr) (op go-left) (direction east) (pos-x ?r) (pos-y ?c)))
)

(defrule left-exec-east
        (declare (salience 50))
        (current (id ?curr))
        (lastnode (id ?n))
?f1 <- 	(apply (id ?curr) (op go-left) (direction east) (pos-x ?r) (pos-y ?c))
        (node (ident ?curr) (gcost ?g))
        ;(goal ?x ?y)
		(dummy_target (pos-x ?x) (pos-y ?y))
		
		=>
		(assert (exec-star (anc ?curr) (id =(+ ?n 9)) (op go-left) (direction east) (pos-x ?r) (pos-y ?c)))
		(assert	(newnode (ident (+ ?n 9)) (pos-r (+ ?r 1)) (pos-c ?c) (direction north)
                (gcost (+ ?g 15)) (fcost (+ (+(*(+(abs (- ?x (+ ?r 1))) (abs (- ?y ?c))) 10) 5) ?g 15))
				(father ?curr)))
		(retract ?f1)
		(focus NEW)
)


(defrule go-forward-apply-south
        (declare (salience 50))
        (current (id ?curr))
        (node (ident ?curr) (pos-r ?r) (pos-c ?c) (direction south) (open yes))
        ;(cell (pos-r =(+ ?r 1)) (pos-c ?c) (contains empty|gate))
		(prior_cell (pos-r =(- ?r 1)) (pos-c ?c) (type gate | lake | rural | urban))

		=> 
		(assert (apply (id ?curr) (op go-forward) (direction south) (pos-x ?r) (pos-y ?c)))
)

(defrule go-forward-exec-south
        (declare (salience 50))
        (current (id ?curr))
        (lastnode (id ?n))
?f1 <- 	(apply (id ?curr) (op go-forward) (direction south) (pos-x ?r) (pos-y ?c))
        (node (ident ?curr) (gcost ?g))
        ;(goal ?x ?y)
		(dummy_target (pos-x ?x) (pos-y ?y))
		
		=>
		(assert (exec-star (anc ?curr) (id =(+ ?n 10)) (op go-forward) (direction south) (pos-x ?r) (pos-y ?c)))
		(assert	(newnode (ident (+ ?n 10)) (pos-r (- ?r 1)) (pos-c ?c) (direction south)
                (gcost (+ ?g 10)) (fcost (+ (+(*(+(abs (- ?x (- ?r 1))) (abs (- ?y ?c))) 10) 5) ?g 10))
				(father ?curr)))
		(retract ?f1)
		(focus NEW)
)

(defrule right-apply-south
        (declare (salience 50))
        (current (id ?curr))
        (node (ident ?curr) (pos-r ?r) (pos-c ?c) (direction south) (open yes))
        ;(cell (pos-r =(+ ?r 1)) (pos-c ?c) (contains empty|gate))
		(prior_cell (pos-r ?r) (pos-c =(- ?c 1)) (type gate | lake | rural | urban))

		=> 
		(assert (apply (id ?curr) (op go-right) (direction south) (pos-x ?r) (pos-y ?c)))
)

(defrule right-exec-south
        (declare (salience 50))
        (current (id ?curr))
        (lastnode (id ?n))
?f1 <- 	(apply (id ?curr) (op go-right) (direction south) (pos-x ?r) (pos-y ?c))
        (node (ident ?curr) (gcost ?g))
        ;(goal ?x ?y)
		(dummy_target (pos-x ?x) (pos-y ?y))
		
		=>
		(assert (exec-star (anc ?curr) (id =(+ ?n 11)) (op go-right) (direction south) (pos-x ?r) (pos-y ?c)))
		(assert	(newnode (ident (+ ?n 11)) (pos-r ?r) (pos-c (- ?c 1)) (direction west)
                (gcost (+ ?g 15)) (fcost (+ (+(*(+(abs (- ?x ?r)) (abs (- ?y (- ?c 1)))) 10) 5) ?g 15))
				(father ?curr)))
		(retract ?f1)
		(focus NEW)
)

(defrule left-apply-south
        (declare (salience 50))
        (current (id ?curr))
        (node (ident ?curr) (pos-r ?r) (pos-c ?c) (direction south) (open yes))
        ;(cell (pos-r =(+ ?r 1)) (pos-c ?c) (contains empty|gate))
		(prior_cell (pos-r ?r) (pos-c =(+ ?c 1)) (type gate | lake | rural | urban))

		=> 
		(assert (apply (id ?curr) (op go-left) (direction south) (pos-x ?r) (pos-y ?c)))
)

(defrule left-exec-south
        (declare (salience 50))
        (current (id ?curr))
        (lastnode (id ?n))
?f1 <- 	(apply (id ?curr) (op go-left) (direction south) (pos-x ?r) (pos-y ?c))
        (node (ident ?curr) (gcost ?g))
        ;(goal ?x ?y)
		(dummy_target (pos-x ?x) (pos-y ?y))
		
		=>
		(assert (exec-star (anc ?curr) (id =(+ ?n 12)) (op go-left) (direction south) (pos-x ?r) (pos-y ?c)))
		(assert	(newnode (ident (+ ?n 12)) (pos-r ?r) (pos-c (+ ?c 1)) (direction east)
                (gcost (+ ?g 15)) (fcost (+ (+(*(+(abs (- ?x ?r)) (abs (- ?y (+ ?c 1)))) 10) 5) ?g 15))
				(father ?curr)))
		(retract ?f1)
		(focus NEW)
)
;--------------Fine azioni movimento--------------------

;; CONTROLLARE QUESTO COMMENTO
; Se il current fosse il goal avrei attivato la regola achieved-goal, quindi
; trovo il fatto di tipo node con fcost minore e continuo l'esplorazione da 
; quello

(defrule change-current
		(declare (salience 49))
		?f1 <-   (current (id ?curr))
		?f2 <-   (node (ident ?curr))
		(node (ident ?best&:(neq ?best ?curr)) (fcost ?bestcost) (open yes))
		(not (node (ident ?id&:(neq ?id ?curr)) (fcost ?gg&:(< ?gg ?bestcost)) (open yes)))
		?f3 <-   (lastnode (id ?last))
		=>    
		(assert (current (id ?best))
                        (lastnode (id (+ ?last 13)))
                )
		(retract ?f1 ?f3)
		(modify ?f2 (open no))
) 

; se il current node non ha più sbocchi allora chiudo questo percorso
(defrule close-empty
         (declare (salience 49))
?f1 <-   (current (id ?curr))
?f2 <-   (node (ident ?curr))
         (not (node (ident ?id&:(neq ?id ?curr)) (open yes)))
    => 
         (retract ?f1)
         (modify ?f2 (open no))
         (printout t " fail (last  node expanded " ?curr ")" crlf)
         ;(halt)
		 (focus POSTASTAR)
)    

(defrule post-astar
    (declare (salience 0))
    =>
    (focus POSTASTAR)
)
; -----------------------------------------------------------------------------------------------------