(defmodule INFORM (import AGENT ?ALL) (export ?ALL))

(deffunction informed (?r ?c)
    return (any-factp ((?e exec)) (and (= (str-compare ?e:action inform) 0) (= ?e:param1 ?r) (= ?e:param2 ?c)))
)

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
    (progn$ (?cell (create$ ?nw ?n ?ne ?w ?cella ?e ?sw ?s ?se))
        ;(printout t "Step " ?step ": " ?cell " in (" ?r ", " ?c ") " ?cell-index crlf)
        (switch ?cell-index
            (case 1 then
                (if (not (informed (+ ?r 1) (- ?c 1))) then
                    (if (= (str-compare ?cell water) 0) then
                        (printout t "Asserisco flood in " (+ ?r 1) ", " (- ?c 1) crlf)
                        (assert (exec (step ?step) (action inform) (param1 (+ ?r 1)) (param2 (- ?c 1)) (param3 flood)))
                    else
                        (printout t "Asserisco ok in " (+ ?r 1) ", " (- ?c 1) crlf)
                        (assert (exec (step ?step) (action inform) (param1 (+ ?r 1)) (param2 (- ?c 1)) (param3 ok)))
                    )
                    (assert (must-update-abs-score (+ ?r 1) (- ?c 1)))
                )
            )
            (case 2 then
                (if (not (informed (+ ?r 1) ?c)) then
                    (if (= (str-compare ?cell water) 0) then
                        (printout t "Asserisco flood in " (+ ?r 1) ", " ?c crlf)
                        (assert (exec (step ?step) (action inform) (param1 (+ ?r 1)) (param2 ?c) (param3 flood)))
                    else
                        (printout t "Asserisco ok in " (+ ?r 1) ", " ?c crlf)
                        (assert (exec (step ?step) (action inform) (param1 (+ ?r 1)) (param2 ?c) (param3 ok)))
                    )
                    (assert (must-update-abs-score (+ ?r 1) ?c))
                )
            )
            (case 3 then
                (if (not (informed (+ ?r 1) (+ ?c 1))) then
                    (if (= (str-compare ?cell water) 0) then
                        (printout t "Asserisco flood in " (+ ?r 1) ", " (+ ?c 1) crlf)
                        (assert (exec (step ?step) (action inform) (param1 (+ ?r 1)) (param2 (+ ?c 1)) (param3 flood)))
                    else
                        (printout t "Asserisco ok in " (+ ?r 1) ", " (+ ?c 1) crlf)
                        (assert (exec (step ?step) (action inform) (param1 (+ ?r 1)) (param2 (+ ?c 1)) (param3 ok)))
                    )
                    (assert (must-update-abs-score (+ ?r 1) (+ ?c 1)))
                )
            )
            (case 4 then
                (if (not (informed ?r (- ?c 1))) then
                    (if (= (str-compare ?cell water) 0) then
                        (printout t "Asserisco flood in " ?r ", " (- ?c 1) crlf)
                        (assert (exec (step ?step) (action inform) (param1 ?r) (param2 (- ?c 1)) (param3 flood)))
                    else
                        (printout t "Asserisco ok in " ?r ", " (- ?c 1) crlf)
                        (assert (exec (step ?step) (action inform) (param1 ?r) (param2 (- ?c 1)) (param3 ok)))
                    )
                    (assert (must-update-abs-score ?r (- ?c 1)))
                )
            )
            (case 5 then
                (if (not (informed ?r ?c)) then
                    (if (= (str-compare ?cell water) 0) then
                        (printout t "Asserisco flood in " ?r ", " ?c crlf)
                        (assert (exec (step ?step) (action inform) (param1 ?r) (param2 ?c) (param3 flood)))
                    else
                        (printout t "Asserisco ok in " ?r ", " ?c crlf)
                        (assert (exec (step ?step) (action inform) (param1 ?r) (param2 ?c) (param3 ok)))
                    )
                    (assert (must-update-abs-score ?r ?c))
                )
            )
            (case 6 then
                (if (not (informed ?r (+ ?c 1))) then
                    (if (= (str-compare ?cell water) 0) then
                        (printout t "Asserisco flood in " ?r ", " (+ ?c 1) crlf)
                        (assert (exec (step ?step) (action inform) (param1 ?r) (param2 (+ ?c 1)) (param3 flood)))
                    else
                        (printout t "Asserisco ok in " ?r ", " (+ ?c 1) crlf)
                        (assert (exec (step ?step) (action inform) (param1 ?r) (param2 (+ ?c 1)) (param3 ok)))
                    )
                    (assert (must-update-abs-score ?r (+ ?c 1)))
                )
            )
            (case 7 then
                (if (not (informed (- ?r 1) (- ?c 1))) then
                    (if (= (str-compare ?cell water) 0) then
                        (printout t "Asserisco flood in " (- ?r 1) ", " (- ?c 1) crlf)
                        (assert (exec (step ?step) (action inform) (param1 (- ?r 1)) (param2 (- ?c 1)) (param3 flood)))
                    else
                        (printout t "Asserisco ok in " (- ?r 1) ", " (- ?c 1) crlf)
                        (assert (exec (step ?step) (action inform) (param1 (- ?r 1)) (param2 (- ?c 1)) (param3 ok)))
                    )
                    (assert (must-update-abs-score (- ?r 1) (- ?c 1)))
                )
            )
            (case 8 then
                (if (not (informed (- ?r 1) ?c)) then
                    (if (= (str-compare ?cell water) 0) then
                        (printout t "Asserisco flood in " (- ?r 1) ", " ?c crlf)
                        (assert (exec (step ?step) (action inform) (param1 (- ?r 1)) (param2 ?c) (param3 flood)))
                    else
                        (printout t "Asserisco ok in " (- ?r 1) ", " ?c crlf)
                        (assert (exec (step ?step) (action inform) (param1 (- ?r 1)) (param2 ?c) (param3 ok)))
                    )
                    (assert (must-update-abs-score (- ?r 1) ?c))
                )
            )
            (case 9 then
                (if (not (informed (- ?r 1) (+ ?c 1))) then
                    (if (= (str-compare ?cell water) 0) then
                        (printout t "Asserisco flood in " (- ?r 1) ", " (+ ?c 1) crlf)
                        (assert (exec (step ?step) (action inform) (param1 (- ?r 1)) (param2 (+ ?c 1)) (param3 flood)))
                    else
                        (printout t "Asserisco ok in " (- ?r 1) ", " (+ ?c 1) crlf)
                        (assert (exec (step ?step) (action inform) (param1 (- ?r 1)) (param2 (+ ?c 1)) (param3 ok)))
                    )
                    (assert (must-update-abs-score (- ?r 1) (+ ?c 1)))
                )
            )
        )
    )
)

(defrule update_val
    (declare (salience 2))
?f <- (must-update-abs-score ?x ?y)
?g <- (score_cell (pos-r ?x) (pos-c ?y) (val ?v))
    =>
    (printout t "Update_val eseguita per cella " ?x ", " ?y crlf)
    (retract ?f)
    (modify ?g (val (/ ?v 2)))
)

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
)

(defrule inform-ok
    (declare (salience 0))
    (status (step ?s))
    =>
    (printout t "Finito inform" crlf)
    (assert (inform_checked ?s))
)
