;;(defmodule PUNTEGGI (import MAIN ?ALL)(export ?ALL)) vedere import ed export

;; INIZIALIZZAZIONE
(defrule init_border_cell
	?cella <- (prior_cell (pos-r ?x) (pos-c ?y) (type border) (val UNDEFINED)) ;;controllare come si fa UNDEFINED o, eventualmente, dare un valore fuffa
    (modify ?cella (val -100))
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
    ?cella <- (prior_cell (pos-r ?x) (pos-c ?y) (type (lake | rural | city)) (abs_score UNDEFINED))
		;;escludo le celle sul perimetro e le celle di tipo hill, perché non è possibile andarci.
		;;controllare come si fa UNDEFINED o, eventualmente, dare un valore fuffa
	(OR
    =>
    ;;SOMMARE I VAL DELLE 9 CELLE IN QUESTIONE (CONVOLUZIONE) E SALVARE IL PUNTEGGIO IN abs_score
)

(defrule update_rel_score
	(status (step ?s)) ;; mi serve capire quale sia lo step attuale per poter aggiornare solo gli absolute score obsoleti (del passo precedente)
    ?cella <- (prior_cell (pos-r ?x) (pos-c ?y) (abs_score ?abs) (not (step ?s))) ;;verificare l'operatore NOT
    =>
    ;; MOLTIPLICARE ?abs PER 1/DISTANZA (USARE MANHATTAN COME VALORE DI DISTANZA), AGGIORNARE abs_step a ?s
)
