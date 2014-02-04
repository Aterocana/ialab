(defmodule INFORM (import AGENT ?ALL) (export ?ALL))

(defrule inspect
    (declare (salience 50))
    (status (step ?step))
    (perc-vision (step ?step) (pos-r ?x) (pos-c ?y))
=>
    (do-for-all-facts
        ((?pc prior_cell))
        (and
            (<= (- ?x 1) ?pc:pos-r (+ ?x 1))
            (<= (- ?y 1) ?pc:pos-c (+ ?y 1))
        )
        (printout t ?pc:type " " ?pc:pos-r " " ?pc:pos-c crlf)
    )
)

(defrule inform-ok
    (declare (salience 0))
    (status (step ?s))
    =>
    (assert (inform_checked ?s))
)
