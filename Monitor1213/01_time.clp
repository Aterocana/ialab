(defmodule TIME (import AGENT ?ALL) (export ?ALL))

(defrule time-clean1
		(declare (salience 150))
?f <-	(last-direction)
	=>
		(retract ?f)
)

(defrule time-clean2
		(declare (salience 150))
?f <-	(path (id ?id) (oper ?oper))
	=>
		(assert (path-star (id ?id) (oper ?oper)))
		(retract ?f)
)

(defrule time-clean3
		(declare (salience 150))
?f <-	(lastnode)
	=>
		(retract ?f)
)

;; Eseguo questa regola per ogni gate. Intendo valutare il costo di 
;; raggiungimento dello stesso a partire dalla posizione attuale
;; PROBLEMA: calcola il percorso solo per il primo gate che matcha
(defrule astar-find-exit
    (declare (salience 100))
    (prior_cell (pos-r ?x) (pos-c ?y) (type gate))
    (status (step ?s))
    (perc-vision (step ?s) (direction ?dir) (pos-r ?r) (pos-c ?c))
    (not (costo-check (pos-r ?x) (pos-c ?y)))
	
	(not (analizzato ?x ?y ?s))
	
?f <- (dummy_target)
    =>
	
	(printout t "Time da ("?r","?c")" crlf)
	(printout t "Time per ("?x","?y")" crlf)
	
    (retract ?f)
	
	(assert (analizzato ?x ?y ?s))
	
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
    (assert (lastnode (id 0)))
    (focus ASTAR-ALGORITHM)
)

(defrule time-clean4
		(declare (salience 90))
		; (not(costo-check))
		(not(hurry))
?f <-	(path-star)
	=>
		(retract ?f)
)

;; Asserisco un fatto best-exit con le coordinate dell'uscita più conveniente
(defrule check-exit-cost1
		(declare (salience 50))
		(not (best-exit ?a ?b))
		(prior_cell (pos-r ?x) (pos-c ?y) (type gate))
		(costo-check (cost ?g))
		(costo-check (pos-r ?x) (pos-c ?y) (cost ?cost))
		(test (< ?cost ?g))
	=>
		(assert (best-exit ?x ?y))
)

(defrule check-exit-cost2
		(declare (salience 50))
?f <-	(best-exit ?x1 ?y1)
		(costo-check (pos-r ?x1) (pos-c ?y1) (cost ?cost))
		(costo-check (pos-r ?x2) (pos-c ?y2) (cost ?best))
		(test(< ?best ?cost))
   =>
		(retract ?f)
		(assert (best-exit ?x2 ?y2))
)

; (defrule time-clean5
		; (declare (salience 40))
; ?f <-	(analizzato ?x ?y ?s)
	; =>
		; (retract ?f)
; )

(defrule not-in-time
       (declare (salience 20))
	   (best-exit ?x ?y)
?f1 <- (costo-check (cost ?g) (pos-r ?x) (pos-c ?y))
       (status (step ?s) (time ?t))
	   (maxduration ?m)
       (test (> (+ ?g 40) 
				(- ?m ?t))
		)
?f2 <-	(dummy_target)
	   (not (punteggi_checked ?s))
	   (not (exit_checked ?s))
   =>
       (printout t "ATTENZIONE: tempo insufficiente" crlf)
	   (printout t "Tempo: "?t" " crlf)
	   (printout t "Costo gate più vicino: "?g" " crlf)
	   ;cancello il costo check associato, altrimenti non ricomputa A*
	   (retract ?f1)
	   (retract ?f2)
	   (assert (dummy_target (pos-x ?x) (pos-y ?y)))
	   (assert (hurry))
; si potrebbe semplicemente attivare le altre control alla presenza di time_checked
; in questo caso non si asserisce time_checked e si salta direttamente ad a_star
	   (assert (punteggi_checked ?s))
	   (assert (exit_checked ?s))
)	

(defrule path-to-finish
		(declare (salience 20))
		(hurry)
		(status (step ?s))
		(perc-vision (step ?s) (direction ?dir) (pos-r ?r) (pos-c ?c))
		(dummy_target (pos-x ?x) (pos-y ?y))
		=>
		
		(printout t "Uscita da ("?r","?c")" crlf)
		(printout t "Uscita per ("?x","?y")" crlf)
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
		(assert (lastnode (id 0)))
		(focus ASTAR-ALGORITHM)
)				

(defrule time-ok
		(declare (salience 19))
		(best-exit ?x ?y)
		(costo-check (cost ?g) (pos-r ?x) (pos-c ?y))
		(status (step ?s) (time ?t))
		(maxduration ?m)
		(test (< (+ ?g 20) 
				(- ?m ?t))
		)
	=>
		(printout t "Tempo ok." crlf)
		(assert (time_checked ?s))
)

(defrule time-clean6
		(declare (salience 5))
?f <-	(best-exit)
	=>
		(retract ?f)
)

(defrule time-clean7
		(declare (salience 5))
?f <-	(costo-check)
	=>
		(retract ?f)
)