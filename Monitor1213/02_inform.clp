(defmodule INFORM (import AGENT ?ALL) (export ?ALL))

(defrule inform-ok
    (declare (salience 0))
    =>
    (assert (inform_checked))
)