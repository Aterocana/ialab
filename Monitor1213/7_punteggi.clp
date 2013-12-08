;;(defmodule PUNTEGGI (import MAIN ?ALL)(export ?ALL)) vedere import ed export

;; INIZIALIZZAZIONE
(defrule init_border_cell
	?prior <- (prior_cell (pos-r ?x) (pos-c ?y) (type border) (val UNDEFINED)) ;;controllare come si fa UNDEFINED o, eventualmente, dare un valore fuffa
	?actual <- (actual_cell (pos-r x) (pos-c y))
    =>
    (modify ?prior (val -100))
)

(defrule init_gate_cell
)

(defrule init_lake_cell
)

(defrule init_hill_cell
)

(defrule init_city_cell
)

(defrule init_rural_cell
)

;;CALCOLO DEI VALORI ASSOLUTI

(defrule calc_abs_score
    ?prior <- (prior_cell (pos-r ?x) (pos-c ?y) (abs_score UNDEFINED)) ;;controllare come si fa UNDEFINED o, eventualmente, dare un valore fuffa
    =>
    ;;SOMMARE I VAL DELLE 9 CELLE IN QUESTIONE (CONVOLUZIONE) E SALVARE IL PUNTEGGIO IN abs_score
)

(defrule update_rel_score
    ?rel <- (actual_cell (pos-r ?x) (pos-c ?y))
    ?abs <- (prior_cell (pos-r ?x) (pos-c ?y) (abs_score ?abs)) ;;controllare come si fa UNDEFINED o, eventualmente, dare un valore fuffa
    =>
    ;; MOLTIPLICARE ?abs PER 1/DISTANZA (USARE MANHATTAN COME VALORE DI DISTANZA)
)
