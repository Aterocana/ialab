(defmodule PUNTEGGI (import AGENT ?ALL) (export ?ALL))

(defrule update_rel_score_current_cell
    (status (step ?s))
    (perc-vision (step ?s) (pos-r ?r) (pos-c ?c))
    ?cella <- (prior_cell (pos-r ?r) (pos-c ?c) (abs_step ?as&:(neq ?as ?s)))
    =>
    ;; ASSEGNO UN PUNTEGGIO RELATIVO MOLTO BASSO ALLA CELLA SU CUI SONO
    (modify ?cella
        (rel_score -1000)
    )
)

(defrule update_rel_score
    (status (step ?s)) ;; mi serve capire quale sia lo step attuale per poter aggiornare solo gli absolute score obsoleti (del passo precedente)
    (perc-vision (step ?s) (pos-r ?r) (pos-c ?c))
    ;; Escludo la cella attuale per evitare divisioni per zero visto che la distanza Manhattan sarebbe zero.
    ?cella <- (prior_cell (pos-r ?x&:(neq ?x ?r)) (pos-c ?y&:(neq ?y ?c)) (type lake | rural | urban) (abs_score ?abs_score) (abs_step ?as&:(neq ?as ?s)))
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