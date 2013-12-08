
;;;;;   REGOLE MINIMALI PER IL FUNZIONAMENTO DELL'AGENTE
;;;;;   Ad ogni istante utente umano deve fornire indicazione sulla regola da eseguire tramite
;;;;;   apposita assert

(defmodule AGENT (import MAIN ?ALL) (export ?ALL))

(deftemplate kagent (slot time) (slot step) (slot pos-r) (slot pos-c) 
                    (slot direction))

(defrule  beginagent
    (declare (salience 10))
    (status (step 0))
    (not (exec (step 0)))
    (initial_agentstatus (pos-r ?r) (pos-c ?c) (direction ?d))
  => 
    (assert (kagent (time 0) (step 0)
                           (pos-r ?r) (pos-c ?c) (direction ?d)))
    )

;; COMMENTATO PER VEDERLO NELL'INTERFACCIA
;;(defrule ask_act
;; ?f <-   (status (step ?i))
;;    =>  (printout t crlf crlf)
;;        (printout t "action to be executed at step:" ?i)
;;        (printout t crlf crlf)
;;        (modify ?f (result no)))

(defrule exec_act
    (status (step ?i))
    (exec (step ?i))
 => (focus MAIN))


; Nel seguito viene riportata una semplice sequenza di comandi che dovrebbe
; servire a verificare il comportamento del modulo ENV nel dominio descritto 
; nel file precedente.
; non tutte le azioni sono utili in vista di una esplorazione, ma sono state 
; inserite per verificare il comportamento del modulo ENV che deve segnalare
; esito non nominale di alcune azioni

;(assert (exec (action go-forward) (step 0)))
;(assert (exec (action go-forward) (step 1)))
;(assert (exec (action go-forward) (step 2)))
;(assert (exec (action go-forward) (step  3))) 
;(assert (exec (action inform) (param1 6) (param2 6) (param3 flood) (step 4)))
;(assert (exec (action go-left) (step 5)))
;(assert (exec (action inform) (param1 4) (param2 3) (param3 flood) (step 6)))
;(assert (exec (action inform) (param1 5) (param2 4) (param3 flood) (step 7)))
;(assert (exec (action inform) (param1 4) (param2 4) (param3 flood) (step 8)))
;(assert (exec (action inform) (param1 4) (param2 4) (param3 ok) (step 9)))
;(assert (exec (action go-forward) (step 10)))
;(assert (exec (action go-left) (step 11)))
;(assert (exec (action loiter-monitoring) (step 12)))
;(assert (exec (action inform) (param1 4) (param2 3) (param3 initial-flood) (step 13)))
;(assert (exec (action go-forward) (step  14))) 
;(assert (exec (action loiter-monitoring) (step 15)))
;(assert (exec (action inform) (param1 3) (param2 3) (param3 initial-flood) (step 16)))
;(assert (exec (action go-right) (step 17)))
;(assert (exec (action inform) (param1 2) (param2 3) (param3 flood) (step 18)))
;(assert (exec (action inform) (param1 2) (param2 2) (param3 flood) (step 19)))
;(assert (exec (action go-right) (step 20)))
;(assert (exec (action go-forward) (step  21))) 
;(assert (exec (action go-forward) (step  22))) 
;(assert (exec (action inform) (param1 6) (param2 2) (param3 flood) (step 23)))
;(assert (exec (action go-forward) (step  24))) 
;(assert (exec (action go-right) (step 25)))
;(assert (exec (action inform) (param1 7) (param2 2) (param3 ok) (step 26)))
;(assert (exec (action inform) (param1 8) (param2 2) (param3 ok) (step 27)))
;(assert (exec (action inform) (param1 8) (param2 3) (param3 flood) (step 28)))
;(assert (exec (action inform) (param1 7) (param2 3) (param3 flood) (step 29)))
;(assert (exec (action inform) (param1 6) (param2 4) (param3 flood) (step 30)))
;(assert (exec (action inform) (param1 7) (param2 4) (param3 flood) (step 31)))
;(assert (exec (action inform) (param1 8) (param2 4) (param3 ok) (step 32)))
;(assert (exec (action go-forward) (step  33)))
;(assert (exec (action inform) (param1 8) (param2 5) (param3 flood) (step 34)))
;(assert (exec (action inform) (param1 7) (param2 5) (param3 ok) (step 35)))
;(assert (exec (action inform) (param1 6) (param2 5) (param3 ok) (step 36)))
;(assert (exec (action go-forward) (step  37)))
;(assert (exec (action inform) (param1 8) (param2 6) (param3 flood) (step 38)))
;(assert (exec (action inform) (param1 7) (param2 6) (param3 flood) (step 39)))
;(assert (exec (action go-forward) (step  40)))	
;(assert (exec (action loiter-monitoring) (step 41)))
;(assert (exec (action inform) (param1 7) (param2 6) (param3 severe-flood) (step 42)))


(defrule turno0   
        ;(declare (salience 25))
        ?f <-   (status (step 0))
        =>
        (assert (exec (action go-forward) (step 0)))
        (assert (dummy_target (pos-x 10) (pos-y 7)))
        (assert (nearest_gate (pos-x 50) (pos-y 50)))
)

(defrule turno1   
        ;(declare (salience 25))
        ?f <-   (status (step 1))
		(perc-vision (step ?s) (pos-r ?r) (pos-c ?c))
		(dummy_target (pos-x ?x) (pos-y ?y))
        =>
        (assert (node (ident 0) (gcost 0) (fcost (+ (abs (- ?x ?r)) (abs (- ?y ?c)))) 
			(father NA) (pos-r ?r) (pos-c ?c) (direction north) (open yes))
		) 
        (assert(current (id 0)))
		(assert (lastnode 0))
)

;regola da verificare
(defrule achieved-goal
		(declare (salience 100))
		(current (id ?curr))
		(dummy_target (pos-x ?x) (pos-y ?y))
		(node (ident ?curr) (pos-r ?x) (pos-c ?y) (gcost ?g))  
		=> 
		(printout t " Esiste soluzione per goal (" ?x "," ?y ") con costo "  ?g crlf)
		(assert (last (id ?curr)))
)

(defrule execute-exec-star

		(declare (salience 101))
		?f<-(last (id ?id))
		(node (ident ?id) (father ?anc&~NA))  
		(exec-star (anc ?anc) (id ?id) (op ?oper) (direction ?dir) (pos-x ?r) (pos-y ?c))

		=> (printout t " Eseguo azione " ?oper " da stato (" ?r "," ?c "), essendo in direzione " ?dir " in nodo "?id" con exec anc:"?anc" - id:"?id" " crlf)
		(assert (ex-mon ?id ?oper))
		(assert (last (id ?anc)))
		(retract ?f)

)

(defrule execute-exec-star2

		(declare (salience 0))
		(status (step ?s))
?f <-	(ex-mon ?id ?oper)
		(not (ex-mon ?id2&:(neq ?id ?id2)&:(< ?id2 ?id)))
		=>
		 (printout t "Eseguo exec: "?id" " crlf)
		(assert (exec (action ?oper) (step ?s)))
		(retract ?f)
)

;===========  regole di movimento  =============

; CONTROLLARE LE F_COST (fatto)
; mancano le azioni south

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
        (lastnode ?n)
?f1 <- 	(apply (id ?curr) (op go-forward) (direction north) (pos-x ?r) (pos-y ?c))
        (node (ident ?curr) (gcost ?g))
        ;(goal ?x ?y)
		(dummy_target (pos-x ?x) (pos-y ?y))
		
		=>
		(assert (exec-star (anc ?curr) (id =(+ ?n 1)) (op go-forward) (direction north) (pos-x ?r) (pos-y ?c)))
		(assert	(newnode (ident (+ ?n 1)) (pos-r (+ ?r 1)) (pos-c ?c) (direction north)
                (gcost (+ ?g 1)) (fcost (+ (abs (- ?x (+ ?r 1))) (abs (- ?y ?c)) ?g 1))
				(father ?curr)))
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
        (lastnode ?n)
?f1 <- 	(apply (id ?curr) (op go-right) (direction north) (pos-x ?r) (pos-y ?c))
        (node (ident ?curr) (gcost ?g))
        ;(goal ?x ?y)
		(dummy_target (pos-x ?x) (pos-y ?y))
		
		=>
		(assert (exec-star (anc ?curr) (id =(+ ?n 2)) (op go-right) (direction north) (pos-x ?r) (pos-y ?c)))
		(assert	(newnode (ident (+ ?n 2)) (pos-r ?r) (pos-c (+ ?c 1)) (direction east)
                (gcost (+ ?g 1)) (fcost (+ (abs (- ?x ?r)) (abs (- ?y (+ ?c 1))) ?g 1))
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
        (lastnode ?n)
?f1 <- 	(apply (id ?curr) (op go-left) (direction north) (pos-x ?r) (pos-y ?c))
        (node (ident ?curr) (gcost ?g))
        ;(goal ?x ?y)
		(dummy_target (pos-x ?x) (pos-y ?y))
		
		=>
		(assert (exec-star (anc ?curr) (id =(+ ?n 3)) (op go-left) (direction north) (pos-x ?r) (pos-y ?c)))
		(assert	(newnode (ident (+ ?n 3)) (pos-r ?r) (pos-c (- ?c 1)) (direction west)
                (gcost (+ ?g 1)) (fcost (+ (abs (- ?x ?r)) (abs (- ?y (- ?c 1))) ?g 1))
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
        (lastnode ?n)
?f1 <- 	(apply (id ?curr) (op go-forward) (direction west) (pos-x ?r) (pos-y ?c))
        (node (ident ?curr) (gcost ?g))
        ;(goal ?x ?y)
		(dummy_target (pos-x ?x) (pos-y ?y))
		
		=>
		(assert (exec-star (anc ?curr) (id =(+ ?n 4)) (op go-forward) (direction west) (pos-x ?r) (pos-y ?c)))
		(assert	(newnode (ident (+ ?n 4)) (pos-r ?r) (pos-c (- ?c 1)) (direction west)
                (gcost (+ ?g 1)) (fcost (+ (abs (- ?x ?r)) (abs (- ?y (- ?c 1))) ?g 1))
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
        (lastnode ?n)
?f1 <- 	(apply (id ?curr) (op go-right) (direction west) (pos-x ?r) (pos-y ?c))
        (node (ident ?curr) (gcost ?g))
        ;(goal ?x ?y)
		(dummy_target (pos-x ?x) (pos-y ?y))
		
		=>
		(assert (exec-star (anc ?curr) (id =(+ ?n 5)) (op go-right) (direction west) (pos-x ?r) (pos-y ?c)))
		(assert	(newnode (ident (+ ?n 5)) (pos-r (+ ?r 1)) (pos-c ?c) (direction north)
                (gcost (+ ?g 1)) (fcost (+ (abs (- ?x (+ ?r 1))) (abs (- ?y ?c)) ?g 1))
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
        (lastnode ?n)
?f1 <- 	(apply (id ?curr) (op go-left) (direction west) (pos-x ?r) (pos-y ?c))
        (node (ident ?curr) (gcost ?g))
        ;(goal ?x ?y)
		(dummy_target (pos-x ?x) (pos-y ?y))
		
		=>
		(assert (exec-star (anc ?curr) (id =(+ ?n 6)) (op go-left) (direction west) (pos-x ?r) (pos-y ?c)))
		(assert	(newnode (ident (+ ?n 6)) (pos-r (- ?r 1)) (pos-c ?c) (direction south)
                (gcost (+ ?g 1)) (fcost (+ (abs (- ?x (- ?r 1))) (abs (- ?y ?c)) ?g 1))
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
        (lastnode ?n)
?f1 <- 	(apply (id ?curr) (op go-forward) (direction east) (pos-x ?r) (pos-y ?c))
        (node (ident ?curr) (gcost ?g))
        ;(goal ?x ?y)
		(dummy_target (pos-x ?x) (pos-y ?y))
		
		=>
		(assert (exec-star (anc ?curr) (id =(+ ?n 7)) (op go-forward) (direction east) (pos-x ?r) (pos-y ?c)))
		(assert	(newnode (ident (+ ?n 7)) (pos-r ?r) (pos-c (+ ?c 1)) (direction east)
                (gcost (+ ?g 1)) (fcost (+ (abs (- ?x ?r)) (abs (- ?y (+ ?c 1))) ?g 1))
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
        (lastnode ?n)
?f1 <- 	(apply (id ?curr) (op go-right) (direction east) (pos-x ?r) (pos-y ?c))
        (node (ident ?curr) (gcost ?g))
        ;(goal ?x ?y)
		(dummy_target (pos-x ?x) (pos-y ?y))
		
		=>
		(assert (exec-star (anc ?curr) (id =(+ ?n 8)) (op go-right) (direction east) (pos-x ?r) (pos-y ?c)))
		(assert	(newnode (ident (+ ?n 8)) (pos-r (- ?r 1)) (pos-c ?c) (direction south)
                (gcost (+ ?g 1)) (fcost (+ (abs (- ?x (- ?r 1))) (abs (- ?y ?c)) ?g 1))
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
        (lastnode ?n)
?f1 <- 	(apply (id ?curr) (op go-left) (direction east) (pos-x ?r) (pos-y ?c))
        (node (ident ?curr) (gcost ?g))
        ;(goal ?x ?y)
		(dummy_target (pos-x ?x) (pos-y ?y))
		
		=>
		(assert (exec-star (anc ?curr) (id =(+ ?n 9)) (op go-left) (direction east) (pos-x ?r) (pos-y ?c)))
		(assert	(newnode (ident (+ ?n 9)) (pos-r (+ ?r 1)) (pos-c ?c) (direction north)
                (gcost (+ ?g 1)) (fcost (+ (abs (- ?x (+ ?r 1))) (abs (- ?y ?c)) ?g 1))
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
        (lastnode ?n)
?f1 <- 	(apply (id ?curr) (op go-forward) (direction south) (pos-x ?r) (pos-y ?c))
        (node (ident ?curr) (gcost ?g))
        ;(goal ?x ?y)
		(dummy_target (pos-x ?x) (pos-y ?y))
		
		=>
		(assert (exec-star (anc ?curr) (id =(+ ?n 1)) (op go-forward) (direction south) (pos-x ?r) (pos-y ?c)))
		(assert	(newnode (ident (+ ?n 10)) (pos-r (- ?r 1)) (pos-c ?c) (direction south)
                (gcost (+ ?g 1)) (fcost (+ (abs (- ?x (- ?r 1))) (abs (- ?y ?c)) ?g 1))
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
        (lastnode ?n)
?f1 <- 	(apply (id ?curr) (op go-right) (direction south) (pos-x ?r) (pos-y ?c))
        (node (ident ?curr) (gcost ?g))
        ;(goal ?x ?y)
		(dummy_target (pos-x ?x) (pos-y ?y))
		
		=>
		(assert (exec-star (anc ?curr) (id =(+ ?n 2)) (op go-right) (direction south) (pos-x ?r) (pos-y ?c)))
		(assert	(newnode (ident (+ ?n 11)) (pos-r ?r) (pos-c (- ?c 1)) (direction west)
                (gcost (+ ?g 1)) (fcost (+ (abs (- ?x ?r)) (abs (- ?y (- ?c 1))) ?g 1))
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
        (lastnode ?n)
?f1 <- 	(apply (id ?curr) (op go-left) (direction south) (pos-x ?r) (pos-y ?c))
        (node (ident ?curr) (gcost ?g))
        ;(goal ?x ?y)
		(dummy_target (pos-x ?x) (pos-y ?y))
		
		=>
		(assert (exec-star (anc ?curr) (id =(+ ?n 3)) (op go-left) (direction south) (pos-x ?r) (pos-y ?c)))
		(assert	(newnode (ident (+ ?n 12)) (pos-r ?r) (pos-c (+ ?c 1)) (direction east)
                (gcost (+ ?g 1)) (fcost (+ (abs (- ?x ?r)) (abs (- ?y (+ ?c 1))) ?g 1))
				(father ?curr)))
		(retract ?f1)
		(focus NEW)
)
;--------------Fine azioni movimento--------------------

;lastnode ci serve???
(defrule change-current

		(declare (salience 49))
		?f1 <-   (current (id ?curr))
		?f2 <-   (node (ident ?curr))
		(node (ident ?best&:(neq ?best ?curr)) (fcost ?bestcost) (open yes))
		(not (node (ident ?id&:(neq ?id ?curr)) (fcost ?gg&:(< ?gg ?bestcost)) (open yes)))
		?f3 <-   (lastnode ?last)
		=>    
		(assert (current (id ?best)) (lastnode (+ ?last 13)))
		(retract ?f1 ?f3)
		(modify ?f2 (open no))
) 

(defrule close-empty
         (declare (salience 49))
?f1 <-   (current (id ?curr))
?f2 <-   (node (ident ?curr))
         (not (node (ident ?id&:(neq ?id ?curr))  (open yes)))
		=> 
         (retract ?f1)
         (modify ?f2 (open no))
         (printout t " fail (last  node expanded " ?curr ")" crlf)
         ;(halt)
)    

; -----------------------------------------------------------------------------------------------------

