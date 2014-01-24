(defmodule EXIT (import AGENT ?ALL) (export ?ALL))

(defrule exit-ok
    (declare (salience 0))
    =>
    (assert (exit_checked))
)