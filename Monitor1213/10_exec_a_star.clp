(defmodule EXECASTAR (import AGENT ?ALL) (export ?ALL))

;-------------- Regole legate al modulo ASTAR ------------------------

;regola per riordinare le azioni di movimento trovate da A*
(defrule execute-exec-star

		(declare (salience 50))
		?f<-(last (id ?id))
		(node (ident ?id) (father ?anc&~NA))  
		(exec-star (anc ?anc) (id ?id) (op ?oper) (direction ?dir) (pos-x ?r) (pos-y ?c))

		=> (printout t " Eseguo azione " ?oper " da stato (" ?r "," ?c "), essendo in direzione " ?dir " in nodo "?id" con exec anc:"?anc" - id:"?id" " crlf)
		(assert (ex-mon ?id ?oper))
		(assert (last (id ?anc)))
		(retract ?f)
)


;regola per eseguire le azioni trovate da A*, precedentemente ordinate
(defrule execute-exec-star2

		(declare (salience 0))
		(status (step ?s))
?f <-	(ex-mon ?id ?oper)
		(not (ex-mon ?id2&:(neq ?id ?id2)&:(< ?id2 ?id)))
		=>
		(printout t "Eseguo exec: "?id" " crlf)
		(assert (exec (action ?oper) (step ?s)))
		(retract ?f)
)