(defmodule INFORM (import AGENT ?ALL) (export ?ALL))

(defrule inform-ok
    (declare (salience 0))
    (status (step ?s))
    =>
    (assert (inform_checked ?s))
)