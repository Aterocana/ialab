(defmodule INFORM (import AGENT ?ALL) (export ?ALL))

; Funzione che restituisce TRUE se è già stata eseguita una azione di tipo inform
; per la cella di coordinate ?r ?c
(deffunction informed (?r ?c)
    return (any-factp ((?e exec)) (and (= (str-compare ?e:action inform) 0) (= ?e:param1 ?r) (= ?e:param2 ?c)))
)

; Funzione che restituisce TRUE se la cella (prior_cell) di coordinate ?r ?c è
; interessante (ossia di tipo rural o urban) NB Se servisse altrove, fattorizzare in altro modulo
(deffunction interesting (?r ?c)
    return (any-factp ((?cell prior_cell)) (and (= ?cell:pos-r ?r) (= ?cell:pos-c ?c) (or (= (str-compare ?cell:type rural) 0) (= (str-compare ?cell:type urban) 0))))
)

; Funzione che:
; * esegue l'azione di inform sulla cella ?cell di coordinate ?r ?c
;   (se interessante e non già informata) allo step ?step
; * asserisce un fatto di tipo must-update-rel-score
(deffunction inform (?r ?c ?cell ?step)
    (if (and (not (informed ?r ?c)) (interesting ?r ?c)) then
        (if (= (str-compare ?cell water) 0) then
            (printout t "Asserisco flood in " ?r ", " ?c crlf)
            (assert (exec (step ?step) (action inform) (param1 ?r) (param2 ?c) (param3 flood)))
        else
            (printout t "Asserisco ok in " ?r ", " ?c crlf)
            (assert (exec (step ?step) (action inform) (param1 ?r) (param2 ?c) (param3 ok)))
        )
        (assert (must-update-val ?r ?c))
    )
)

; Funzione che cicla le nove celle percepite dall'UAV in un dato momento, e su
; ciascuna invoca la funzione inform
(deffunction inspect (?r ?c ?step ?cells)
    (progn$ (?cell ?cells)
        (switch ?cell-index
            (case 1 then (inform (+ ?r 1) (- ?c 1) ?cell ?step))
            (case 2 then (inform (+ ?r 1) ?c ?cell ?step))
            (case 3 then (inform (+ ?r 1) (+ ?c 1) ?cell ?step))
            (case 4 then (inform ?r (- ?c 1) ?cell ?step))
            (case 5 then (inform ?r ?c ?cell ?step))
            (case 6 then (inform ?r (+ ?c 1) ?cell ?step))
            (case 7 then (inform (- ?r 1) (- ?c 1) ?cell ?step))
            (case 8 then (inform (- ?r 1) ?c ?cell ?step))
            (case 9 then (inform (- ?r 1) (+ ?c 1) ?cell ?step))
        )
    )
)

; Regola per ispezionare celle mentre ci si sposta in direzione nord
(defrule inspect-north
    (declare (salience 50))
    (status (step ?step))
    (perc-vision
        (step ?step) (pos-r ?r) (pos-c ?c) (direction north)
        ; percezioni delle celle circostanti
        (perc1 ?nw)
        (perc2 ?n)
        (perc3 ?ne)
        (perc4 ?w)
        (perc5 ?cella)
        (perc6 ?e)
        (perc7 ?sw)
        (perc8 ?s)
        (perc9 ?se)
    )
=>
    (inspect ?r ?c ?step (create$ ?nw ?n ?ne ?w ?cella ?e ?sw ?s ?se))
)

; Regola per ispezionare celle mentre ci si sposta in direzione est
(defrule inspect-east
    (declare (salience 50))
    (status (step ?step))
    (perc-vision
        (step ?step) (pos-r ?r) (pos-c ?c) (direction east)
        ; percezioni delle celle circostanti
        (perc1 ?ne)
        (perc2 ?e)
        (perc3 ?se)
        (perc4 ?n)
        (perc5 ?cella)
        (perc6 ?s)
        (perc7 ?nw)
        (perc8 ?w)
        (perc9 ?sw)
    )
=>
    (inspect ?r ?c ?step (create$ ?nw ?n ?ne ?w ?cella ?e ?sw ?s ?se))
)

; Regola per ispezionare celle mentre ci si sposta in direzione sud
(defrule inspect-south
    (declare (salience 50))
    (status (step ?step))
    (perc-vision
        (step ?step) (pos-r ?r) (pos-c ?c) (direction south)
        ; percezioni delle celle circostanti
        (perc1 ?se)
        (perc2 ?s)
        (perc3 ?sw)
        (perc4 ?e)
        (perc5 ?cella)
        (perc6 ?w)
        (perc7 ?ne)
        (perc8 ?n)
        (perc9 ?nw)
    )
=>
    (inspect ?r ?c ?step (create$ ?nw ?n ?ne ?w ?cella ?e ?sw ?s ?se))
)

; Regola per ispezionare celle mentre ci si sposta in direzione ovest
(defrule inspect-west
    (declare (salience 50))
    (status (step ?step))
    (perc-vision
        (step ?step) (pos-r ?r) (pos-c ?c) (direction west)
        ; percezioni delle celle circostanti
        (perc1 ?sw)
        (perc2 ?w)
        (perc3 ?nw)
        (perc4 ?s)
        (perc5 ?cella)
        (perc6 ?n)
        (perc7 ?se)
        (perc8 ?e)
        (perc9 ?ne)
    )
=>
    (inspect ?r ?c ?step (create$ ?nw ?n ?ne ?w ?cella ?e ?sw ?s ?se))
)

; Regola che aggiorna il valore di una cella dopo la inform (di tipo normale):
; se è una cella di tipo urban il valore viene portato a -20, se è una cella di
; tipo rural il valore viene portato a -30.
(defrule update_val
    (declare (salience 2))
?f <- (must-update-val ?x ?y)
?g <- (score_cell (pos-r ?x) (pos-c ?y) (val ?v) (type ?type))
=>
    (printout t "Update_val eseguita per cella " ?x ", " ?y crlf)
    (retract ?f)
    (if (= (str-compare ?type urban) 0) then
        (modify ?g (val 50))
    else
        (modify ?g (val 40))
    )
    ;(modify ?g (val (/ ?v 2)))
    (loop-for-count (?i (- ?x 1) (+ ?x 1)) do
        (loop-for-count (?j (- ?y 1) (+ ?y 1)) do
            (assert (must-update-abs-score ?i ?j))
        )
    )
)

; Regola che aggiorna il valore di una cella dopo la "FULL" inform
;(defrule update_full_val
;)

; Regola che aggiorna il punteggio assoluo di una cella quando cambiano il suo valore
; ed eventualmente quello delle celle circostanti a seguito di esecuzioni di update_val o update_full_val
(defrule update_abs_score
    (declare (salience 1))
?f <- (must-update-abs-score ?x ?y)
    (score_cell (pos-r =(+ ?x 1)) (pos-c =(- ?y 1)) (val ?nw))
    (score_cell (pos-r =(+ ?x 1)) (pos-c ?y) (val ?n))
    (score_cell (pos-r =(+ ?x 1)) (pos-c =(+ ?y 1)) (val ?ne))
    (score_cell (pos-r ?x) (pos-c =(- ?y 1)) (val ?w))
?cella <- (score_cell (pos-r ?x) (pos-c ?y) (val ?v))
    (score_cell (pos-r ?x) (pos-c =(+ ?y 1)) (val ?e))
    (score_cell (pos-r =(- ?x 1)) (pos-c =(- ?y 1)) (val ?sw))
    (score_cell (pos-r =(- ?x 1)) (pos-c ?y) (val ?s))
    (score_cell (pos-r =(- ?x 1)) (pos-c =(+ ?y 1)) (val ?se))
=>
    (modify ?cella (abs_score (+ ?sw ?s ?se ?w ?v ?e ?nw ?n ?ne)))
    (retract ?f)
    (printout t "Update_abs_score eseguita per cella " ?x ", " ?y crlf)
)

; Regola che asserisce la fine di una sessione di inform
(defrule inform-ok
    (declare (salience 0))
    (status (step ?s))
=>    
    (assert (inform_checked ?s))
)
