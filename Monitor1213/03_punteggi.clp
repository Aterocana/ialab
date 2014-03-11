(defmodule PUNTEGGI (import AGENT ?ALL) (export ?ALL))

(defrule update_rel_score_current_cell
    (declare (salience 3))
    (status (step ?s))
    (perc-vision (step ?s) (pos-r ?r) (pos-c ?c))
    ?cella <- (score_cell (pos-r ?r) (pos-c ?c) (abs_step ?as&:(neq ?as ?s)))
    (not (invalid-target (pos-r ?r) (pos-c ?c)))
    =>
    ;; ASSEGNO UN PUNTEGGIO RELATIVO MOLTO BASSO ALLA CELLA SU CUI SONO
    (modify ?cella
        (rel_score -1000)
        (abs_step ?s)
    )
)

(defrule update_rel_score
    (declare (salience 3))
    (status (step ?s)) ;; mi serve capire quale sia lo step attuale per poter aggiornare solo gli absolute score obsoleti (del passo precedente)
    (perc-vision (step ?s) (pos-r ?r) (pos-c ?c))
    ;; Escludo la cella attuale per evitare divisioni per zero visto che la distanza Manhattan sarebbe zero.
    (prior_cell (pos-r ?x) (pos-c ?y) (type lake | rural | urban))
    ?cella <- (score_cell (pos-r ?x) (pos-c ?y)(abs_score ?abs_score) (abs_step ?as&:(neq ?as ?s)))
    (not (invalid-target (pos-r ?r) (pos-c ?c)))
    (test
        (or
            (neq ?x ?r)
            (neq ?y ?c)
        )
    )
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

;; contrassegno con un rel_score di -1000 le celle segnalate come invalide, nel caso non sia già stato fatto
(defrule invalid_target
        (declare (salience 2))
        (invalid-target (pos-r ?r) (pos-c ?c))
?f <-   (score_cell (pos-r ?r) (pos-c ?c) (rel_score ?rel_score&:(neq ?rel_score -1000)))
    =>
        (retract ?f)
        (assert (score_cell (pos-r ?r) (pos-c ?c) (rel_score -1000)))
)

(defrule best-cell
	(declare (salience 2))
?f <-	(temporary_target (pos-x ?r1) (pos-y ?c1))
	(score_cell (pos-r ?r1) (pos-c ?c1) (rel_score ?rel&:(neq ?rel nil)))
	(score_cell (pos-r ?r2) (pos-c ?c2) (rel_score ?best&:(neq ?best nil)))
	(test (< ?rel ?best))
	; (not (analizzata ?r2 ?c2))
    =>
	(retract ?f)
	(assert (temporary_target (pos-x ?r2) (pos-y ?c2)))
	; (assert (analizzata ?r2 ?c2))
	(printout t "rel ("?r1","?c1") "?rel" ---- best ("?r2","?c2") "?best" "crlf)
	(printout t "Best Cell: ("?r2", "?c2") - Rel Score: "?best" " crlf)
	(printout t (< ?rel ?best) " " crlf)
)

; (defrule best-cell
		; (declare (salience 2))
; ?f <-	(temporary_target (pos-x ?r1) (pos-y ?c1))
		; (score_cell (pos-r ?r1) (pos-c ?c1) (rel_score ?best&:(neq ?best nil)))
		; (score_cell (pos-r ?r2) (pos-c ?c2) (rel_score ?rel&:(> ?rel ?best)))
		; (test (< ?rel ?best))
		; (not (analizzata ?r2 ?c2))
		; =>
		; (retract ?f)
		; (assert (temporary_target (pos-x ?r1) (pos-y ?c1)))
		; (assert (analizzata ?r2 ?c2))
		; (printout t "Best Cell: ("?r1", "?c1") - Rel Score: "?best" " crlf)
		; (printout t (< ?rel ?best) " " crlf)
; )

; (defrule best-cell-clean
		; (declare (salience 1))
; ?f <-	(analizzata)
	; =>
		; (retract ?f)
; )

(defrule punteggi-ok
    (declare (salience 0))
    (status (step ?s))
    =>
    (printout t "Concluso aggiornamento punteggi turno " ?s crlf)
    (assert (punteggi_checked ?s))
)