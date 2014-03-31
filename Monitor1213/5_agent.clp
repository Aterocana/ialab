
;;;;;   REGOLE MINIMALI PER IL FUNZIONAMENTO DELL'AGENTE
;;;;;   Ad ogni istante utente umano deve fornire indicazione sulla regola da eseguire tramite
;;;;;   apposita assert

(defmodule AGENT (import MAIN ?ALL) (export ?ALL))

(deftemplate kagent (slot time) (slot step) (slot pos-r) (slot pos-c)
    (slot direction)
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

;; ***** NOSTRE MODIFICHE *****
(deftemplate dummy_target
    (slot pos-x)
    (slot pos-y)
)

(deftemplate temporary_target
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

(deftemplate current (slot id))

(deftemplate newnode (slot ident) (slot gcost) (slot fcost) (slot father) (slot pos-r)
    (slot pos-c) (slot direction)
)

(deftemplate apply
    (slot id) (slot op) (slot direction) (slot pos-x) (slot pos-y)
)

;; anc = ancestor
(deftemplate exec-star
    (slot anc) (slot id) (slot op) (slot direction) (slot pos-x) (slot pos-y)
)

(deftemplate lastnode (slot id))

(deftemplate last (slot id))

(deftemplate last-direction (slot direction))

;template temporaneo
(deftemplate visitata
    (slot pos-r)
    (slot pos-c)
)

(deftemplate costo-check
    (slot pos-r)
    (slot pos-c)
    (slot cost)
)

;; ho incluso il type al solo scopo di debugging
(deftemplate score_cell
    (slot pos-r)
    (slot pos-c)
    (slot val)
    (slot abs_score)
    (slot rel_score)
    (slot abs_step)
    (slot type)
)

(deftemplate path
    (slot id)
    (slot oper)
    (slot target-r)
    (slot target-c)    
)

(deftemplate path-star
    (slot id)
    (slot oper)
    (slot target-r)
    (slot target-c)    
)

(deftemplate invalid-target
    (slot pos-r)
    (slot pos-c)
)
;------------------ Fine delle nostre modifiche --------------------

;; COMMENTATO PER VEDERLO NELL'INTERFACCIA
;;(defrule ask_act
;; ?f <-   (status (step ?i))
;;    =>  (printout t crlf crlf)
;;        (printout t "action to be executed at step:" ?i)
;;        (printout t crlf crlf)
;;        (modify ?f (result no)))

(defrule exec_act
    (declare (salience 10))
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
	(declare (salience 5))
    (status (step 0))

    =>
	;Da cancellare dopo il completamento di PUNTEGGI
	(assert (temporary_target (pos-x 2) (pos-y 5)))
	(assert (dummy_target (pos-x 2) (pos-y 5)))
	(assert (exec (action go-forward) (step 0)))
    (focus INIT_PUNTEGGI)
)

(defrule control-time
		(not (hurry))
       (status (step ?s))
       (not (time_checked ?s))
   =>
       (focus TIME)
)

(defrule control-inform
		(not (hurry))
        (status (step ?s))
        (not (inform_checked ?s))
        ;(time_checked ?s)
    =>
        (focus INFORM)
)

(defrule control-punteggi
		(not (hurry))
        (status (step ?s))
        ;(perc-vision (step ?s))
        (not (punteggi_checked ?s))
        (inform_checked ?s)
    =>
        (focus PUNTEGGI)
)

(defrule control-astar
		(not (hurry))
        (status (step ?s))
        (perc-vision (step ?s) (pos-r ?r) (pos-c ?c))
;?e <-	(exit-found)
		;momentaneo
		(punteggi_checked ?s)
        (not (astar_checked ?s))
        ; (exit_checked ?s)
    =>
        (printout t "control-astar turno " ?s crlf)
        ; (retract ?e)
		(focus ASTAR)
)

(defrule control-exit
		(not (hurry))
        (status (step ?s))
        (astar_checked ?s)
        (not (exit_checked ?s))
        (punteggi_checked ?s)
   =>
        (focus EXIT)
)

(defrule move
		(not (hurry))
        (status (step ?s))
?f1 <-	(astar_checked ?s)
; ?f2 <-	(exit_checked ?s)
?f3 <-	(punteggi_checked ?s)
;?f4 <-	(inform_checked ?s)
;?f5 <-	(time_checked)
?f6 <-	(path-star (id ?id) (oper ?oper))
        (not (path-star (id ?id2&:(neq ?id ?id2)&:(< ?id2 ?id))))
    =>
        (printout t "Eseguo exec: "?id", azione: "?oper" " crlf)
        (assert (exec (action ?oper) (step ?s)))
        (retract ?f1)
        ; (retract ?f2)
        (retract ?f3)
        ;(retract ?f4)
        ;(retract ?f5)
        (retract ?f6)
)

;se hurry matcha, vengono eseguiti tutti gli step fino al gate
;in seguito si dovrà definire una regola che asserisca exec(done)
(defrule move-to-finish
		(declare (salience 1))
		(hurry)
		(status (step ?s))
?f <-	(path-star (id ?id) (oper ?oper))
        (not (path-star (id ?id2&:(neq ?id ?id2)&:(< ?id2 ?id))))
		=>
		(retract ?f)
		(assert (exec (action ?oper) (step ?s)))
)

(defrule finish
		(hurry)
		(status (step ?s))
		=>
		(assert (exec (action done) (step ?s)))
)