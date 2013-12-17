(defmodule PUNTEGGI (import AGENT ?ALL) (export ?ALL))

(defrule update_rel_score
    (status (step ?s)) ;; mi serve capire quale sia lo step attuale per poter aggiornare solo gli absolute score obsoleti (del passo precedente)
    (perc-vision (step ?s) (pos-r ?r) (pos-c ?c))
    ?cella <- (prior_cell (pos-r ?x) (pos-c ?y) (type lake | rural | urban) (abs_score ?abs_score) (abs_step ?s&:(not ?s)))
    =>
    ;; MOLTIPLICARE ?abs_score PER 1/DISTANZA (USARE MANHATTAN COME VALORE DI DISTANZA), AGGIORNARE abs_step a ?s
    (modify ?cella 
        (rel_score 
            (/ 
                ?abs_score 
                (+ (abs (- ?x ?r)) (abs (- ?y ?c)))
            )
        )
        (abs_step ?s)
    )
)
