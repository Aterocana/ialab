(defmodule TIME (import AGENT ?ALL) (export ?ALL))

(defrule nearest-gate
?f1 <-(costo ?costo)
    =>
    (retract ?f1)   
)