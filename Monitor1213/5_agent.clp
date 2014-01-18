
;;;;;   REGOLE MINIMALI PER IL FUNZIONAMENTO DELL'AGENTE
;;;;;   Ad ogni istante utente umano deve fornire indicazione sulla regola da eseguire tramite
;;;;;   apposita assert

(defmodule AGENT (import MAIN ?ALL) (export ?ALL))

(deftemplate kagent (slot time) (slot step) (slot pos-r) (slot pos-c) 
    (slot direction)
)
					
(deftemplate dummy_target
    (slot pos-x)
    (slot pos-y)
)

(deftemplate nearest_gate 
    (slot pos-x) 
    (slot pos-y)
)

(deftemplate node (slot ident) (slot gcost) (slot fcost) (slot father) (slot pos-r)
    (slot pos-c) (slot direction) (slot open)
)

(deftemplate newnode (slot ident) (slot gcost) (slot fcost) (slot father) (slot pos-r)
    (slot pos-c) (slot direction)
)

(deftemplate current (slot id))

(deftemplate apply
    (slot id) (slot op) (slot direction) (slot pos-x) (slot pos-y)
)

;; anc = ancestor
(deftemplate exec-star
    (slot anc) (slot id) (slot op) (slot direction) (slot pos-x) (slot pos-y)
)

(deftemplate last (slot id))

;template temporaneo
(deftemplate visitata
    (slot pos-r)
    (slot pos-c)
)

;ALE: gli slot pos-r e pos-c posso essere eliminati se non servono
(deftemplate costo-check 
    (slot pos-r)
    (slot pos-c)
    (slot cost)
)

(defrule  beginagent
    (declare (salience 10))
    (status (step 0))
    (not (exec (step 0)))
    (initial_agentstatus (pos-r ?r) (pos-c ?c) (direction ?d))
  => 
    (assert (kagent (time 0) (step 0)
                           (pos-r ?r) (pos-c ?c) (direction ?d)))
    (focus INIT_PUNTEGGI)
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
    (assert (dummy_target (pos-x 9) (pos-y 7)))
            ;(assert (dummy_target (pos-x 4) (pos-y 4)))
    (assert (nearest_gate (pos-x 50) (pos-y 50)))
)

(defrule turno1   
    ;(declare (salience 25))
    ?f <-   (status (step 1))
    =>
            (assert (astar-go))
            (focus PUNTEGGI)
)

;-------------- Regole legate al modulo ASTAR ------------------------


;ALE: controlla se esiste il fatto costo-check
;imposta un gate come target e lancia A*
; controllo che sia raggiungibile un gate a partire da dummy target
(defrule checkpath
        (declare (salience 10))
?f1 <-	(costo-check)
        (prior_cell (pos-r ?x1) (pos-c ?y1) (type gate))
?f2 <-	(dummy_target (pos-x ?x2) (pos-y ?y2))
	=>
        (retract ?f1)
        (retract ?f2)
        (assert (dummy_target (pos-x ?x1) (pos-y ?y1)))
        (assert (node (ident 0) (gcost 0) (fcost (+ (* (+ (abs (- ?x1 ?x2)) (abs (- ?y1 ?y1))) 10) 5)) 
            (father NA) (pos-r ?x2) (pos-c ?x1) (direction north) (open yes))
        )
        (assert (current (id 0)))
        (assert (lastnode 0))
; double-check è il flag per non produrre fatti di tipo path (in quanto questo è
; solo un controllo per vedere se almeno un gate è raggiungibile)
        (assert (double-check))
        (focus ASTAR)
)

;regola per eseguire le azioni trovate da A*, precedentemente ordinate in path
;questa regola viene attivata solo se è presente il fatto costo-check
(defrule execute-exec-star2
        (declare (salience 0))
        (status (step ?s))
		(costo-check)
?f <-	(path ?id ?oper)
        (not (path ?id2&:(neq ?id ?id2)&:(< ?id2 ?id)))
	=>
        (printout t "Eseguo exec: "?id" " crlf)
        (assert (exec (action ?oper) (step ?s)))
        (retract ?f)
)

; regola per attivare A* sul nuovo target:
; inizializzo i fatti di tipo node, current e lastnode
(defrule astar-go
        (declare (salience 0))
?f <-	(astar-go)
        (status (step ?s))
        (perc-vision (step ?s) (pos-r ?r) (pos-c ?c))
        (dummy_target (pos-x ?x) (pos-y ?y))
	=>
        (retract ?f)

;RICORDARSI DI MODIFICARE direction north IN UNA DIREZIONE PARAMETRICA A SECONDA DI DOVE "INIZIA" l'UAV

        (assert (node (ident 0) (gcost 0) (fcost (+ (* (+ (abs (- ?x ?r)) (abs (- ?y ?c))) 10) 5)) 
            (father NA) (pos-r ?r) (pos-c ?c) (direction north) (open yes))
        ) 
        (assert (current (id 0)))
        (assert (lastnode 0))
        (focus ASTAR)
)