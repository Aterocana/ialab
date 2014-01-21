(defmodule PUNTEGGI (import AGENT ?ALL) (export ?ALL))

(defrule update_rel_score_current_cell
    (status (step ?s))
    (perc-vision (step ?s) (pos-r ?r) (pos-c ?c))
    ?cella <- (prior_cell (pos-r ?r) (pos-c ?c) (abs_step ?as&:(neq ?as ?s)))
    =>
    ;; ASSEGNO UN PUNTEGGIO RELATIVO MOLTO BASSO ALLA CELLA SU CUI SONO
    (modify ?cella
        (rel_score -1000)
        (abs_step ?s)
    )
)

(defrule update_rel_score
    (status (step ?s)) ;; mi serve capire quale sia lo step attuale per poter aggiornare solo gli absolute score obsoleti (del passo precedente)
    (perc-vision (step ?s) (pos-r ?r) (pos-c ?c))
    ;; Escludo la cella attuale per evitare divisioni per zero visto che la distanza Manhattan sarebbe zero.
    ?cella <- (prior_cell (pos-r ?x) (pos-c ?y) (type lake | rural | urban) (abs_score ?abs_score) (abs_step ?as&:(neq ?as ?s)))
    (test
        (or
            (neq ?x ?r)
            (neq ?y ?c)
        )
    )
        
    =>
    ;; MOLTIPLICARE ?abs_score PER 1/DISTANZA (USARE MANHATTAN COME VALORE DI DISTANZA), AGGIORNARE abs_step a ?s
	(printout t "test: " (neq ?x ?r) " " (neq ?y ?c) crlf)
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

(defrule best-cell
	;(declare (salience 50))
?f <-	(temporary_target (pos-x ?r1) (pos-y ?c1))
	;(not (astar-go))
	(prior_cell (pos-r ?r1) (pos-c ?c1) (rel_score ?rel&:(neq ?rel nil)))
	(prior_cell (pos-r ?r2) (pos-c ?c2) (rel_score ?best&:(neq ?best nil)))
	(test (< ?rel ?best))
	(not (analizzata ?r2 ?c2))
    =>
	(retract ?f)
	(assert (temporary_target (pos-x ?r2) (pos-y ?c2)))
	(assert (analizzata ?r2 ?c2))
	;(assert (astar-go))
	(printout t "Best-cell "?r1" : "?c1" " crlf)
	(printout t "cella prova "?r2" : "?c2" "?rel" "?best" " crlf)
	(printout t (< ?rel ?best) " " crlf)
)