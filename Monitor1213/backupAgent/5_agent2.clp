
;;;;;   REGOLE MINIMALI PER IL FUNZIONAMENTO DELL'AGENTE
;;;;;   Ad ogni istante utente umano deve fornire indicazione sulla regola da eseguire tramite
;;;;;   apposita assert

(defmodule AGENT (import MAIN ?ALL))

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
        ?f <-   (status (step 0))
        =>
        (assert (exec (action go-forward) (step 0)))
        (assert (dummy_target (pos-x 10) (pos-y 7)))
        (assert (nearest-gate (pos-x 100) (pos-y 100)))
)

(defrule turno1   
        ?f <-   (status (step 1))      
        =>  
        (assert (exec (action go-forward) (step 1)))
)

;*******************************************************************
;**** Regole per muovere verso il terget con UAV rivolto a nord ****
;*******************************************************************

(defrule dummy_move_to_target_north_1
                    (status (step ?s))
                    (dummy_target (pos-x ?x) (pos-y ?y))
                    (perc-vision (step ?s) (pos-r ?r) (pos-c ?c) 
                    (direction north) (perc2 urban | rural | water | gate))
                    (test (< ?r ?x))
                    
                    =>
                    (assert (exec (action go-forward) (step ?s)))
)


;se il target � dietro di me, mi giro a sx, se a sx non c'� una collina
(defrule dummy_move_to_target_north_2a
                    (status (step ?s))
                    (dummy_target (pos-x ?x) (pos-y ?y))
                    (perc-vision (step ?s) (pos-r ?r) (pos-c ?c) 
                    (direction north) (perc4 urban | rural | water | gate))
                    (or
                        (test (> ?r ?x))
                        (test (> ?c ?y))
                    )
                    =>
                    (assert (exec (action go-left) (step ?s)))
)

;se devo andare a nord-est ma ho delle colline sia a nord che ad est
(defrule dummy_move_to_target_north_2b
                    (status (step ?s))
                    (dummy_target (pos-x ?x) (pos-y ?y))
                    (perc-vision (step ?s) (pos-r ?r) (pos-c ?c) 
                    (direction north) (perc2 hill | border) 
                    (perc4 urban | rural | water | gate) (perc6 hill | border))
                    (or
                        (test (< ?r ?x))
                        (test (< ?c ?y))
                    )
                    =>
                    (assert (exec (action go-left) (step ?s)))
)

;se il target � dietro di me, mi giro a dx, se a dx non c'� una collina
(defrule dummy_move_to_target_north_3a
                    (status (step ?s))
                    (dummy_target (pos-x ?x) (pos-y ?y))
                    (perc-vision (step ?s) (pos-r ?r) 
                    (pos-c ?c) (direction north) 
                    (perc6 urban | rural | water | gate))
                    (or
                        (test (> ?r ?x))
                        (test (> ?c ?y))
                    )
                    =>
                    (assert (exec (action go-right) (step ?s)))
)

;se devo andare a nord-ovest ma ho delle colline sia a nord che ad est
(defrule dummy_move_to_target_north_3b
                    (status (step ?s))
                    (dummy_target (pos-x ?x) (pos-y ?y))
                    (perc-vision (step ?s) (pos-r ?r) (pos-c ?c) 
                    (direction north) (perc2 hill | border) 
                    (perc6 urban | rural | water | gate) (perc4 hill | border))
                    (or
                        (test (< ?r ?x))
                        (test (> ?c ?y))
                    )
                    =>
                    (assert (exec (action go-right) (step ?s)))
)

;*******************************************************************
;**** Regole per muovere verso il terget con UAV rivolto a ovest ***
;*******************************************************************

(defrule dummy_move_to_target_west_1
                    (status (step ?s))
                    (dummy_target (pos-x ?x) (pos-y ?y))
                    (perc-vision (step ?s) (pos-r ?r) (pos-c ?c) 
                    (direction west) (perc2 urban | rural | water | gate))
                    (test (> ?c ?y))
                    
                    =>
                    (assert (exec (action go-forward) (step ?s)))
)


;se il target � dietro di me, mi giro a sx, se a sx non c'� una collina
(defrule dummy_move_to_target_west_2a
                    (status (step ?s))
                    (dummy_target (pos-x ?x) (pos-y ?y))
                    (perc-vision (step ?s) (pos-r ?r) (pos-c ?c) 
                    (direction west) (perc4 urban | rural | water | gate))
                    (or
                        (test (> ?r ?x))
                        (test (< ?c ?y))
                    )
                    =>
                    (assert (exec (action go-left) (step ?s)))
)

;se il target � dietro di me, mi giro a dx, se a dx non c'� una collina
(defrule dummy_move_to_target_west_3a
                    (status (step ?s))
                    (dummy_target (pos-x ?x) (pos-y ?y))
                    (perc-vision (step ?s) (pos-r ?r) 
                    (pos-c ?c) (direction west) 
                    (perc6 urban | rural | water | gate))
                    (or
                        (test (< ?r ?x))
                        (test (< ?c ?y))
                    )
                    =>
                    (assert (exec (action go-right) (step ?s)))
)

;*******************************************************************
;**** Regole per muovere verso il terget con UAV rivolto a est ***
;*******************************************************************

(defrule dummy_move_to_target_east_1
                    (status (step ?s))
                    (dummy_target (pos-x ?x) (pos-y ?y))
                    (perc-vision (step ?s) (pos-r ?r) (pos-c ?c) 
                    (direction east) (perc2 urban | rural | water | gate))
                    (test (< ?c ?y))
                    
                    =>
                    (assert (exec (action go-forward) (step ?s)))
)


;se il target � dietro di me, mi giro a sx, se a sx non c'� una collina
(defrule dummy_move_to_target_east_2a
                    (status (step ?s))
                    (dummy_target (pos-x ?x) (pos-y ?y))
                    (perc-vision (step ?s) (pos-r ?r) (pos-c ?c) 
                    (direction east) (perc4 urban | rural | water | gate))
                    (or
                        (test (< ?r ?x))
                        (test (> ?c ?y))
                    )
                    =>
                    (assert (exec (action go-left) (step ?s)))
)

;se il target � dietro di me, mi giro a dx, se a dx non c'� una collina
(defrule dummy_move_to_target_east_2b
                    (status (step ?s))
                    (dummy_target (pos-x ?x) (pos-y ?y))
                    (perc-vision (step ?s) (pos-r ?r) (pos-c ?c) 
                    (direction east) (perc6 urban | rural | water | gate))
                    (or
                        (test (> ?r ?x))
                        (test (> ?c ?y))
                    )
                    =>
                    (assert (exec (action go-right) (step ?s)))
)



(defrule nearest_gate
                    (status (time ?time) (step ?s))
                    (maxduration ?maxdur)
?f2 <-              (dummy_target (pos-x ?x3) (pos-y ?y3))
                    (perc-vision (step ?s) (pos-r ?r) (pos-c ?c))
                    (prior_cell (pos-r ?x1) (pos-c ?y1) (type gate))
                    ;qua serve avere uno (o più) stato nella kb che identifica l'azione
                    ;che verrà eseguita al passo successivo, nel quale deve essere esplicitata
                    ;la durata dell'azione (da legare alla variabile k)
                    ;test < ?time ?maxdur non basta. Bisogna sommare a time il tempo per raggiungere il gate
                    ;Per il momento implementiamo una versione più semplice della regola
?f1 <-              (nearest-gate (pos-x ?x2) (pos-y ?y2))
                    (test (neq ?x1 ?r))
                    (test (neq ?y1 ?c))
                    (test   (< 
                                (+ (abs (- ?x1 ?r)) (abs (- ?y1 ?c))) 
                                (+ (abs (- ?x2 ?r)) (abs (- ?y2 ?c))) 
                            ) 
                    )
                   
                    =>
                    (assert ciao)
                    ;(modify ?f1 (pos-x ?x1) (pos-y ?y1))
                    ;(modify ?f2 (pos-x ?x1) (pos-y ?y1))
)