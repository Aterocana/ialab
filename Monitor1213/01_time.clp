(defmodule TIME (import AGENT ?ALL) (export ?ALL))

;; Eseguo questa regola per ogni gate. Intendo valutare il costo di 
;; raggiungimento dello stesso a partire dalla posizione attuale
(defrule astar-find-exit
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
    (assert (lastnode (id 0)))
    (focus ASTAR-ALGORTIHM)
)

;; controllo se effettivamente è stata trovata un'uscita. Se sì, mi salvo il 
;; costo migliore tra quelli trovati (potrebbero essere raggiungibili più 
;; uscite) per poi confrontarlo con il tempo.

;; Asserisco un fatto best-exit con le coordinate dell'uscita più conveniente
(defrule check-exit-cost
        (declare (salience 10))
        (prior_cell (pos-r ?x) (pos-c ?y) (type gate))
        (costo-check (cost ?g))
        (costo-check (pos-r ?x) (pos-c ?y) (cost ?cost&:(< ?cost ?g)))        
    =>
        (assert (best-exit ?x ?y))
)

;; cancello i fatti di tipo path delle uscite non convenienti
(defrule delete-path
        (declare (salience 9))
        (best-exit ?x ?y)
?p <-   (path (target-r ?r) (target-c ?c))
        (test
            (or
                (neq ?x ?r)
                (neq ?y ?c)
            )
        )
    =>
        (retract ?p)
)

;; cancello i fatti di tipo costo-check delle uscite non convenienti
(defrule delete-cc
        (declare (salience 8))
        (best-exit ?x ?y)
?cc <-  (costo-check (pos-r ?r) (pos-c ?c))
        (test
            (or
                (neq ?x ?r)
                (neq ?y ?c)
            )
        )
    =>
        (retract ?cc)
)

;; se il tempo della soluzione, a cui aggiungo un certo delta (20 per ora), 
;; è maggiore del tempo rimasto asserisco hurry, ovvero faccio in modo che 
;; vengano attivati solo fatti che computino il percorso verso l'uscita (ho
;; ancora i fatti path salvati).
(defrule not-in-time
        (declare (salience 5))
        (costo-check (cost ?g) (pos-r ?x) (pos-c ?y))
        (status (step ?s))
        (perc-vision (time ?t))
        (test (< (+ ?g 20) ?t))
    =>
        (printout t "ATTENZIONE: tempo insufficiente" crlf)
        (assert (hurry ?x ?y))
        ;;aggiungere condizioni per attivare le regole di computazione hurry
)


;; se ho ancora sufficiente tempo ritraggo i fatti di tipo path generati per
;; l'uscita migliore
(defrule clean-path
        (declare (salience 1))
        (not (hurry ?a ?b))
        (best-exit ?x ?y)
?p <-   (path (target-r ?x) (target-c ?y))
    =>
        (retract ?p)
)

;; se ho ancora sufficiente tempo ritraggo il fatto best-exit e il suo costo, 
;; quindi asserisco time_checked
(defrule time-ok
        (declare (salience 0))
        (not (hurry ?a ?b))
        (status (step ?s))
?be <-  (best-exit ?x ?y)
?cc <-  (costo-check (pos-r ?x) (pos-c ?y))
    =>
        (printout t "Concluso controllo tempo turno " ?s crlf)
        (retract ?be)
        (retract ?cc)
        (assert (time_checked ?s))
)