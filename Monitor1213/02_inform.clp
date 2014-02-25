(defmodule INFORM (import AGENT ?ALL) (export ?ALL))

(defrule inspect-curr
    (declare (salience 50))
    (status (step ?step))
    (perc-vision
        (step ?step) (pos-r ?r) (pos-c ?c)
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
    ;(prior_cell (pos-r ?r&:(= ?r (+ ?x 1))) (pos-c ?c&:(= ?c (- ?y 1))) (type urban | rural))
    ;(prior_cell (pos-r ?r) (pos-c ?c) (type urban|rural))
    ;(not (exec (action inform) (param1 ?r) (param2 ?c)))
=>
    (printout t "*************************************" crlf)
    (progn$ (?cell (create$ ?nw ?n ?ne ?w ?cella ?e ?sw ?s ?se))
        (printout t ?cell crlf)
    )
    (printout t "*************************************" crlf)
    ;(if (= (str-compare ?cella water) 0) then
        ;(assert (exec (step ?step) (action inform) (param1 ?r) (param2 ?c) (param3 flood)))
    ;    (printout t "****************" crlf "HO ASSERITO FLOOD IN ("?r","?c")" crlf "****************" crlf)
    ;else
        ;(assert (exec (step ?step) (action inform) (param1 ?r) (param2 ?c) (param3 ok)))
    ;    (printout t "****************" crlf "HO ASSERITO OK IN ("?r","?c")" crlf "****************" crlf)
    ;)
    ;(printout t "pc pos-r: " ?r " pc pos-c: " ?c crlf)
)

(defrule inform-ok
    (declare (salience 0))
    (status (step ?s))
    =>
    (assert (inform_checked ?s))
)
