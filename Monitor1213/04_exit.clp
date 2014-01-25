(defmodule EXIT (import AGENT ?ALL) (export ?ALL))

(defrule exit-ok
    (declare (salience 0))
    (status (step ?s))
    =>
    (assert (exit_checked ?s))
)