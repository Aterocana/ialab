;;(defmodule PUNTEGGI (import MAIN ?ALL)(export ?ALL)) vedere import ed export

;; INIZIALIZZAZIONE
(defrule init_border_cell
    ?cella <- (prior_cell (pos-r ?x) (pos-c ?y) (type border) (val UNDEFINED)) ;;controllare come si fa UNDEFINED o, eventualmente, dare un valore fuffa
    =>
    (modify ?cella (val -100))
)

(defrule init_gate_cell
    ?cella <- (prior cell (pos-r ?x) (pos-c ?y) (type gate) (val UNDEFINED))
    =>
    (modify ?cella (val 0))
    
)

(defrule init_lake_cell
    ?cella <- (prior cell (pos-r ?x) (pos-c ?y) (type lake) (val UNDEFINED))
    =>
    (modify ?cella (val 0))
)

(defrule init_hill_cell
    ?cella <- (prior cell (pos-r ?x) (pos-c ?y) (type hill) (val UNDEFINED))
    =>
    (modify ?cella (val -100))
)

(defrule init_city_cell
    ?cella <- (prior cell (pos-r ?x) (pos-c ?y) (type city) (val UNDEFINED))
    =>
    (modify ?cella (val 100))
)

(defrule init_rural_cell
    ?cella <- (prior cell (pos-r ?x) (pos-c ?y) (type rural) (val UNDEFINED))
    =>
    (modify ?cella (val 50))
)

;;CALCOLO DEI VALORI ASSOLUTI

(defrule calc_abs_score
    ?cella <- (prior_cell (pos-r ?x) (pos-c ?y) (type (lake | rural | city)) (val ?v) (abs_score UNDEFINED))
		;;escludo le celle sul perimetro e le celle di tipo hill, perché non è possibile andarci.
		;;controllare come si fa UNDEFINED o, eventualmente, dare un valore fuffa
    ;;recupero i valori nelle 8 celle circostanti
    (prior_cell (pos-r (- ?x 1)) (pos-c (- ?y 1)) (val ?sw))
    (prior_cell (pos-r (- ?x 1)) (pos-c ?y) (val ?s))
    (prior_cell (pos-r (- ?x 1)) (pos-c (+ ?y 1)) (val ?se))
    (prior_cell (pos-r ?x) (pos-c (- ?y 1)) (val ?w))
    (prior_cell (pos-r ?x) (pos-c (+ ?y 1)) (val ?e))
    (prior_cell (pos-r (+ ?x 1)) (pos-c (- ?y 1)) (val ?nw))
    (prior_cell (pos-r (+ ?x 1)) (pos-c ?y) (val ?n))
    (prior_cell (pos-r (+ ?x 1)) (pos-c (+ ?y 1)) (val ?ne))    
    =>
    ;;sommo i valori e li salvo in abs_score. NON HO ANCORA USATO I COEFFICIENTI POSIZIONALI
    (modify ?cella (abs_score (+ ?sw ?s ?se ?w ?v ?e ?nw ?n ?ne)))
)

(defrule update_rel_score
    (status (step ?s)) ;; mi serve capire quale sia lo step attuale per poter aggiornare solo gli absolute score obsoleti (del passo precedente)
    ?cella <- (prior_cell (pos-r ?x) (pos-c ?y) (type (lake | rural | city) (abs_score ?abs) (not (step ?s))) ;;verificare l'operatore NOT
    =>
    ;; MOLTIPLICARE ?abs PER 1/DISTANZA (USARE MANHATTAN COME VALORE DI DISTANZA), AGGIORNARE abs_step a ?s
)
