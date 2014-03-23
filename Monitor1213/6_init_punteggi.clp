(defmodule INIT_PUNTEGGI (import AGENT ?ALL) (export ?ALL))
;; CREAZIONE DEI FATTI score_cell
(defrule create_score_cell
    (declare (salience 2))
    (prior_cell (pos-r ?x) (pos-c ?y) (type ?t))
    (not (score_cell (pos-r ?x) (pos-c ?y)))
    =>
    (assert (score_cell (pos-r ?x) (pos-c ?y) (type ?t)))
)

(defrule init_border_cell
    (declare (salience 1))
    (prior_cell (pos-r ?x) (pos-c ?y) (type border))
    ?cella <- (score_cell (pos-r ?x) (pos-c ?y) (val nil))
    =>
    (modify ?cella (val 0) (abs_score -1000))
)

(defrule init_gate_cell
    (declare (salience 1))
    (prior_cell (pos-r ?x) (pos-c ?y) (type gate))
    ?cella <- (score_cell (pos-r ?x) (pos-c ?y) (val nil))
    =>
    (modify ?cella (val 20) (abs_score -500))
)

(defrule init_lake_cell
    (declare (salience 1))
    (prior_cell (pos-r ?x) (pos-c ?y) (type lake))
    ?cella <- (score_cell (pos-r ?x) (pos-c ?y) (val nil))
    =>
    (modify ?cella (val 20))
)

(defrule init_hill_cell
    (declare (salience 1))
    (prior_cell (pos-r ?x) (pos-c ?y) (type hill))
    ?cella <- (score_cell (pos-r ?x) (pos-c ?y) (val nil))
    =>
    (modify ?cella (val 0) (abs_score -1000))
)

(defrule init_urban_cell
    (declare (salience 1))
    (prior_cell (pos-r ?x) (pos-c ?y) (type urban))
    ?cella <- (score_cell (pos-r ?x) (pos-c ?y) (val nil))
    =>
    (modify ?cella (val 400))
)

(defrule init_rural_cell
    (declare (salience 1))
    (prior_cell (pos-r ?x) (pos-c ?y) (type rural))
    ?cella <- (score_cell (pos-r ?x) (pos-c ?y) (val nil))
    =>
    (modify ?cella (val 300))
)

;;CALCOLO DEI VALORI ASSOLUTI
(defrule calc_abs_score
    ;;escludo le celle sul perimetro e le celle di tipo hill, perché non è possibile andarci.
    (prior_cell (pos-r ?x) (pos-c ?y) (type lake | rural | urban))
    ?cella <- (score_cell (pos-r ?x) (pos-c ?y) (val ?v) (abs_score nil))

    ;;recupero i valori nelle 8 celle circostanti
    (score_cell (pos-r =(- ?x 1)) (pos-c =(- ?y 1)) (val ?sw))
    (score_cell (pos-r =(- ?x 1)) (pos-c ?y) (val ?s))
    (score_cell (pos-r =(- ?x 1)) (pos-c =(+ ?y 1)) (val ?se))
    (score_cell (pos-r ?x) (pos-c =(- ?y 1)) (val ?w))
    (score_cell (pos-r ?x) (pos-c =(+ ?y 1)) (val ?e))
    (score_cell (pos-r =(+ ?x 1)) (pos-c =(- ?y 1)) (val ?nw))
    (score_cell (pos-r =(+ ?x 1)) (pos-c ?y) (val ?n))
    (score_cell (pos-r =(+ ?x 1)) (pos-c =(+ ?y 1)) (val ?ne))    
    =>
    ;;sommo i valori e li salvo in abs_score. NON HO ANCORA USATO I COEFFICIENTI POSIZIONALI    
    (modify ?cella (abs_score (+ ?sw ?s ?se ?w ?v ?e ?nw ?n ?ne)))
)
