(defmodule TIME (import AGENT ?ALL) (export ?ALL))

(defrule time-clean1
		(declare (salience 150))
?f <-	(last-direction)
	=>
		(retract ?f)
)

(defrule time-clean2
		(declare (salience 150))
?f <-	(path)
	=>
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

(defrule time-clean4
		(declare (salience 40))
?f <-	(analizzato)
	=>
		(retract ?f)
)

(defrule not-in-time
       (declare (salience 20))
	   (best-exit ?x ?y)
       (costo-check (cost ?g) (pos-r ?x) (pos-c ?y))
       (status (step ?s) (time ?t))
	   (maxduration ?m)
       (test (> (+ ?g 40) 
				(- ?m ?t))
		)
?f <-	(dummy_target)
	   (not (punteggi_checked ?s))
	   (not (exit_checked ?s))
   =>
       (printout t "ATTENZIONE: tempo insufficiente" crlf)
	   (printout t "Tempo: "?t" " crlf)
	   (printout t "Costo gate più vicino: "?g" " crlf)
	   (retract ?f)
	   (assert (dummy_target (pos-x ?x) (pos-y ?y)))
	   (assert (hurry))
; si potrebbe semplicemente attivare le altre control alla presenza di time_checked
; in questo caso non si asserisce time_checked e si salta direttamente ad a_star
	   (assert (punteggi_checked ?s))
	   (assert (exit_checked ?s))
)

(defrule time-ok
		(declare (salience 20))
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

(defrule time-clean5
		(declare (salience 5))
?f <-	(best-exit)
	=>
		(retract ?f)
)

(defrule time-clean6
		(declare (salience 5))
?f <-	(costo-check)
	=>
		(retract ?f)
)

;; REGOLA DI PROVA DA CANCELLARE
; (defrule costi-astar
    ; (declare (salience 9))
; ?c <-   (costo-check (pos-r ?x) (pos-c ?y) (cost ?g))
    ; =>
    ; (printout t "trovato percorso verso l'uscita " ?x "," ?y "con costo pari a " ?g)
; )

;; controllo se effettivamente è stata trovata un'uscita. Se sì, mi salvo il 
;; costo migliore tra quelli trovati (potrebbero essere raggiungibili più 
;; uscite) per poi confrontarlo con il tempo.

; (defrule check-time
		; (declare (salience 40))
		; (best-exit ?x ?y)
		; (costo-check (pos-r ?x) (pos-c ?y) (cost ?cost))
		; (perc-vision (time ?t))

;; cancello i fatti di tipo path delle uscite non convenienti
;(defrule delete-path
;        (declare (salience 9))
;        (best-exit ?x ?y)
;?p <-   (path (target-r ?r) (target-c ?c))
;        (test
;            (or
;                (neq ?x ?r)
;                (neq ?y ?c)
;            )
;        )
;    =>
;        (retract ?p)
;)

;; cancello i fatti di tipo costo-check delle uscite non convenienti
;(defrule delete-cc
;        (declare (salience 8))
;        (best-exit ?x ?y)
;?cc <-  (costo-check (pos-r ?r) (pos-c ?c))
;        (test
;            (or
;                (neq ?x ?r)
;                (neq ?y ?c)
;            )
;       )
;    =>
;        (retract ?cc)
;)

;; se il tempo della soluzione, a cui aggiungo un certo delta (20 per ora), 
;; è maggiore del tempo rimasto asserisco hurry, ovvero faccio in modo che 
;; vengano attivati solo fatti che computino il percorso verso l'uscita (ho
;; ancora i fatti path salvati).
;(defrule not-in-time
;        (declare (salience 5))
;        (costo-check (cost ?g) (pos-r ?x) (pos-c ?y))
;        (status (step ?s))
;        (perc-vision (time ?t))
;        (test (< (+ ?g 20) ?t))
;    =>
;        (printout t "ATTENZIONE: tempo insufficiente" crlf)
;        (assert (hurry ?x ?y))
;;aggiungere condizioni per attivare le regole di computazione hurry
;)

;; se ho ancora sufficiente tempo ritraggo i fatti di tipo path generati per
;; l'uscita migliore
;(defrule clean-path
;        (declare (salience 1))
;        (not (hurry ?a ?b))
;        (best-exit ?x ?y)
;?p <-   (path (target-r ?x) (target-c ?y))
;    =>
;        (retract ?p)
;)

;; se ho ancora sufficiente tempo ritraggo il fatto best-exit e il suo costo, 
;; quindi asserisco time_checked
;(defrule time-ok
;        (declare (salience 0))
;        (not (hurry ?a ?b))
;        (status (step ?s))
;?be <-  (best-exit ?x ?y)
;?cc <-  (costo-check (pos-r ?x) (pos-c ?y))
;    =>
;        (printout t "Concluso controllo tempo turno " ?s crlf)
;        (retract ?be)
;        (retract ?cc)
;        (assert (time_checked ?s))
;)