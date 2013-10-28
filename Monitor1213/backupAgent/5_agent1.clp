
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
                    assert (exec (action go-forward) (step 0))
)
(defrule turno1   ?f <-   (status (step 1))      =>  (assert (exec (action go-forward) (step 1))))
(defrule turno2   ?f <-   (status (step 2))      =>  (assert (exec (action go-forward) (step 2))))
(defrule turno3   ?f <-   (status (step 3))      =>  (assert (exec (action go-forward) (step 3))))
(defrule turno4   ?f <-   (status (step 4))      =>  (assert (exec (action inform) (param1 6) (param2 6) (param3 flood) (step 4))))
(defrule turno5   ?f <-   (status (step 5))      =>  (assert (exec (action go-left) (step 5))))
(defrule turno6   ?f <-   (status (step 6))      =>  (assert (exec (action inform) (param1 4) (param2 3) (param3 flood) (step 6))))
(defrule turno7   ?f <-   (status (step 7))      =>  (assert (exec (action inform) (param1 5) (param2 4) (param3 flood) (step 7))))
(defrule turno8   ?f <-   (status (step 8))      =>  (assert (exec (action inform) (param1 4) (param2 4) (param3 flood) (step 8))))
(defrule turno9   ?f <-   (status (step 9))      =>  (assert (exec (action inform) (param1 4) (param2 4) (param3 ok) (step 9))))
(defrule turno10  ?f <-   (status (step 10))     =>  (assert (exec (action go-forward) (step 10))))
(defrule turno11  ?f <-   (status (step 11))     =>  (assert (exec (action go-left) (step 11))))
(defrule turno12  ?f <-   (status (step 12))     =>  (assert (exec (action loiter-monitoring) (step 12))))
(defrule turno13  ?f <-   (status (step 13))     =>  (assert (exec (action inform) (param1 4) (param2 3) (param3 initial-flood) (step 13))))
(defrule turno14  ?f <-   (status (step 14))     =>  (assert (exec (action go-forward) (step  14))))
(defrule turno15  ?f <-   (status (step 15))     =>  (assert (exec (action loiter-monitoring) (step 15))))
(defrule turno16  ?f <-   (status (step 16))     =>  (assert (exec (action inform) (param1 3) (param2 3) (param3 initial-flood) (step 16))))
(defrule turno17  ?f <-   (status (step 17))     =>  (assert (exec (action go-right) (step 17))))
(defrule turno18  ?f <-   (status (step 18))     =>  (assert (exec (action inform) (param1 2) (param2 3) (param3 flood) (step 18))))
(defrule turno19  ?f <-   (status (step 19))     =>  (assert (exec (action inform) (param1 2) (param2 2) (param3 flood) (step 19))))
(defrule turno20  ?f <-   (status (step 20))     =>  (assert (exec (action go-right) (step 20))))
(defrule turno21  ?f <-   (status (step 21))     =>  (assert (exec (action go-forward) (step  21))))
(defrule turno22  ?f <-   (status (step 22))     =>  (assert (exec (action go-forward) (step  22))))
(defrule turno23  ?f <-   (status (step 23))     =>  (assert (exec (action inform) (param1 6) (param2 2) (param3 flood) (step 23))))
(defrule turno24  ?f <-   (status (step 24))     =>  (assert (exec (action go-forward) (step  24))))
(defrule turno25  ?f <-   (status (step 25))     =>  (assert (exec (action go-right) (step 25))))
(defrule turno26  ?f <-   (status (step 26))     =>  (assert (exec (action inform) (param1 7) (param2 2) (param3 ok) (step 26))))
(defrule turno27  ?f <-   (status (step 27))     =>  (assert (exec (action inform) (param1 8) (param2 2) (param3 ok) (step 27))))
(defrule turno28  ?f <-   (status (step 28))     =>  (assert (exec (action inform) (param1 8) (param2 3) (param3 flood) (step 28))))
(defrule turno29  ?f <-   (status (step 29))     =>  (assert (exec (action inform) (param1 7) (param2 3) (param3 flood) (step 29))))
(defrule turno30  ?f <-   (status (step 30))     =>  (assert (exec (action inform) (param1 6) (param2 4) (param3 flood) (step 30))))
(defrule turno31  ?f <-   (status (step 31))     =>  (assert (exec (action inform) (param1 7) (param2 4) (param3 flood) (step 31))))
(defrule turno32  ?f <-   (status (step 32))     =>  (assert (exec (action inform) (param1 8) (param2 4) (param3 ok) (step 32))))
(defrule turno33  ?f <-   (status (step 33))     =>  (assert (exec (action go-forward) (step  33))))
(defrule turno34  ?f <-   (status (step 34))     =>  (assert (exec (action inform) (param1 8) (param2 5) (param3 flood) (step 34))))
(defrule turno35  ?f <-   (status (step 35))     =>  (assert (exec (action inform) (param1 7) (param2 5) (param3 ok) (step 35))))
(defrule turno36  ?f <-   (status (step 36))     =>  (assert (exec (action inform) (param1 6) (param2 5) (param3 ok) (step 36))))
(defrule turno37  ?f <-   (status (step 37))     =>  (assert (exec (action go-forward) (step  37))))
(defrule turno38  ?f <-   (status (step 38))     =>  (assert (exec (action inform) (param1 8) (param2 6) (param3 flood) (step 38))))
(defrule turno39  ?f <-   (status (step 39))     =>  (assert (exec (action inform) (param1 7) (param2 6) (param3 flood) (step 39))))
(defrule turno40  ?f <-   (status (step 40))     =>  (assert (exec (action go-forward) (step  40))))
(defrule turno41  ?f <-   (status (step 41))     =>  (assert (exec (action loiter-monitoring) (step 41))))
(defrule turno42  ?f <-   (status (step 42))     =>  (assert (exec (action inform) (param1 7) (param2 6) (param3 severe-flood) (step 42))))
(defrule turno43  ?f <-   (status (step 43))     =>  (assert (exec (action go-forward) (step  43))))
(defrule turno44  ?f <-   (status (step 44))     =>  (assert (exec (action go-forward) (step  44))))
