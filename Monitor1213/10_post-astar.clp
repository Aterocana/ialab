(defmodule POSTASTAR (import ASTAR-ALGORITHM ?ALL) (export ?ALL))

;regola per riordinare le azioni di movimento trovate da A*
;gira al contrario il percorso generato da A*
(defrule execute-exec-star
        (declare (salience 50))
?f1 <-  (last (id ?id))
        (node (ident ?id) (father ?anc&~NA))  
?f2 <-  (exec-star (anc ?anc) (id ?id) (op ?oper) (direction ?dir) (pos-x ?r) (pos-y ?c))
        ;(not (double-check))
    =>  
        (printout t " Eseguo azione " ?oper " da cella (" ?r "," ?c ") " crlf)
        (assert (path (id ?id) (oper ?oper)))
        (assert (last (id ?anc)))
        (retract ?f1)
        (retract ?f2)
)

;regole per eliminare i fatti generati da A* non più utili
(defrule clean-astar1
        (declare (salience 25))
?f <-	(node)
        =>
	(retract ?f)
)

(defrule clean-astar2
        (declare (salience 25))
?f <-	(exec-star)
	=>
        (retract ?f)
)

(defrule clean-astar3
        (declare (salience 25))
?f <-	(last)
	=>
        (retract ?f)
)

;; Commentata perché già presente nel modulo ASTAR
; (defrule clean-astar4
        ; (declare (salience 25))
; ?f <-	(lastnode)
	; =>
        ; (retract ?f)
; )
