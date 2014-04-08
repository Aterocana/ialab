;;;;   *****************************
;;;;   *****************************
;;                 MODULO ENV
;;;;   *****************************

(defmodule ENV (import MAIN ?ALL)(export ?ALL))

;; OGNI CELLA CONTIENE IL NUMERO DI RIGA E DI COLONNA , che COSA CONTIENE all’inizio (type) e il suo stato vero (actual)
(deftemplate actual_cell
                  (slot pos-r)
                  (slot pos-c)
                  (slot type (allowed-values urban rural lake hill gate border))
                  (slot actual (allowed-values ok  initial-flood severe-flood))
)

(deftemplate agentstatus
           (slot time)
           (slot step)
           (slot pos-r)
           (slot pos-c)
           (slot direction)
           (slot dur-last-act))

(deftemplate discovered
	(slot step)
	(slot pos-r)
	(slot pos-c)
	(slot utility)
    (slot discover)
	(slot abstract)
    (slot precise))

(defrule creation2
(declare (salience 24))
      (create-discovered)
      (actual_cell (pos-r ?r) (pos-c ?c) (type border|gate|hill|lake))
=>  (assert (discovered (step 0) (pos-r ?r) (pos-c ?c) (utility no)
                        (discover no) (abstract ok) (precise ok)))
    )

(defrule creation3
(declare (salience 24))
      (create-discovered)
      (actual_cell (pos-r ?r) (pos-c ?c) (type urban|rural) (actual initial-flood))
=>  (assert (discovered (step 0) (pos-r ?r) (pos-c ?c) (utility yes)
                        (discover no) (abstract flood)(precise initial-flood)))
    )

(defrule creation4
(declare (salience 24))
      (create-discovered)
      (actual_cell (pos-r ?r) (pos-c ?c) (type urban|rural) (actual severe-flood))
  =>  (assert (discovered (step 0) (pos-r ?r) (pos-c ?c) (utility yes)
                        (discover no) (abstract flood)(precise severe-flood)))
      )

(defrule creation5
(declare (salience 24))
      (create-discovered)
      (actual_cell (pos-r ?r) (pos-c ?c) (type urban|rural) (actual ok))
  =>  (assert (discovered (step 0) (pos-r ?r) (pos-c ?c) (utility yes)
                          (discover no) (abstract ok) (precise ok)))
      )

 (defrule creation-start
 (declare (salience 23))
 ?f1 <-   (create-initial-setting)
 ?f2 <-   (create-discovered)
 ?f3 <-   (initial_agentstatus (pos-r ?r) (pos-c ?c) (direction ?d))
 =>
    (assert (status (time 0) (step 0)(result no))
            (agentstatus  (step 0) (time 0) (pos-r ?r) (pos-c ?c)
                          (direction ?d) (dur-last-act 0))
            (penalty 0))
      (retract ?f1 ?f2)
      (focus MAIN))

;;--------------------------------------------------------------------------------------------------------------
;;   REGOLE DI go-forward

(defrule go-forward-north-ok
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  go-forward))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c)(direction north))
        (actual_cell (pos-r =(+ ?r 1)) (pos-c ?c) (type ~border&~hill))
       => (modify ?f1 (pos-r (+ ?r 1)) (step (+ ?i 1))
                      (time (+ ?t 10)) (dur-last-act 10))
          (modify ?f2 (step (+ ?i 1)) (time (+ ?t 10))))

(defrule go-forward-north-disaster
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  go-forward))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c)(direction north))
        (actual_cell (pos-r =(+ ?r 1)) (pos-c ?c) (type border|hill))
       => (modify ?f2 (step (+ ?i 1)) (time (+ ?t 10)) (result disaster))
  (focus MAIN))

 (defrule go-forward-south-ok
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  go-forward))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c)(direction south))
        (actual_cell (pos-r =(- ?r 1)) (pos-c ?c) (type ~border&~hill))
       => (modify ?f1 (pos-r (- ?r 1)) (step (+ ?i 1))
                      (time (+ ?t 10)) (dur-last-act 10))
          (modify ?f2 (step (+ ?i 1)) (time (+ ?t 10))))

(defrule go-forward-south-disaster
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  go-forward))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c)(direction south))
        (actual_cell (pos-r =(- ?r 1)) (pos-c ?c) (type border|hill))
=> (modify ?f2 (step (+ ?i 1)) (time (+ ?t 10)) (result disaster))
  (focus MAIN))

(defrule go-forward-west-ok
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  go-forward))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c)(direction west))
        (actual_cell (pos-r ?r) (pos-c =(- ?c 1)) (type ~border&~hill))
       => (modify ?f1 (pos-c (- ?c 1)) (step (+ ?i 1))
                      (time (+ ?t 10)) (dur-last-act 10))
          (modify ?f2 (step (+ ?i 1)) (time (+ ?t 10))))

(defrule go-forward-west-disaster
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  go-forward))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c)(direction west))
        (actual_cell (pos-r ?r) (pos-c =(- ?c 1)) (type border|hill))
       => (modify ?f2 (step (+ ?i 1)) (time (+ ?t 10)) (result disaster))
  (focus MAIN))


(defrule go-forward-east-ok
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  go-forward))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c)(direction east))
        (actual_cell (pos-r ?r) (pos-c =(+ ?c 1)) (type ~border&~hill))
       => (modify ?f1 (pos-c (+ ?c 1)) (step (+ ?i 1))
                      (time (+ ?t 10)) (dur-last-act 10))
          (modify ?f2 (step (+ ?i 1)) (time (+ ?t 10))))

(defrule go-forward-east-disaster
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  go-forward))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c)(direction east))
        (actual_cell (pos-r ?r) (pos-c =(+ ?c 1)) (type border|hill))
      => (modify ?f2 (step (+ ?i 1)) (time (+ ?t 10)) (result disaster))
  (focus MAIN))

;;   REGOLE go-left
(defrule go-left-north-ok
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  go-left))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c)(direction north))
        (actual_cell (pos-r ?r) (pos-c =(- ?c 1)) (type ~border&~hill))
       => (modify ?f1 (pos-c (- ?c 1)) (direction west)(step (+ ?i 1))
                      (time (+ ?t 15)) (dur-last-act 15))
          (modify ?f2 (step (+ ?i 1)) (time (+ ?t 15))))


(defrule go-left-north-disaster
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  go-left))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c)(direction north))
        (actual_cell (pos-r ?r) (pos-c =(- ?c 1))(type border|hill))
      => (modify ?f2 (step (+ ?i 1)) (time (+ ?t 15)) (result disaster))
         (focus MAIN))

 (defrule go-left-south-ok
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  go-left))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c)(direction south))
        (actual_cell (pos-r ?r) (pos-c =(+ ?c 1))  (type ~border&~hill))
       => (modify ?f1 (pos-c (+ ?c 1)) (direction east) (step (+ ?i 1))
                      (time (+ ?t 15)) (dur-last-act 15))
          (modify ?f2 (step (+ ?i 1)) (time (+ ?t 15))))

(defrule go-left-south-disaster
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  go-left))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c)(direction south))
        (actual_cell (pos-r ?r) (pos-c =(+ ?c 1)) (type border|hill))
    =>  (modify ?f2 (step (+ ?i 1)) (time (+ ?t 15)) (result disaster))
        (focus MAIN))

 (defrule go-left-west-ok
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  go-left))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c)(direction west))
        (actual_cell (pos-r =(- ?r 1)) (pos-c ?c) (type ~border&~hill))
       => (modify ?f1 (pos-r (- ?r 1)) (direction south) (step (+ ?i 1))
                      (time (+ ?t 15)) (dur-last-act 15))
          (modify ?f2 (step (+ ?i 1)) (time (+ ?t 15))))

(defrule go-left-west-disaster
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  go-left))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c)(direction west))
        (actual_cell (pos-r =(- ?r 1)) (pos-c ?c) (type border|hill))
      =>(modify ?f2 (step (+ ?i 1)) (time (+ ?t 15)) (result disaster))
        (focus MAIN))

(defrule go-left-east-ok
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  go-left))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c)(direction east))
        (actual_cell (pos-r =(+ ?r 1)) (pos-c ?c) (type ~border&~hill))
       => (modify ?f1 (pos-r (+ ?r 1)) (direction north) (step (+ ?i 1))
                      (time (+ ?t 15)) (dur-last-act 15))
          (modify ?f2 (step (+ ?i 1)) (time (+ ?t 15))))

(defrule go-left-east-disaster
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  go-left))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c)(direction east))
        (actual_cell (pos-r =(+ ?r 1)) (pos-c ?c) (type border|hill))
     => (modify ?f2 (step (+ ?i 1)) (time (+ ?t 15)) (result disaster))
        (focus MAIN))

; regole  per go-right
(defrule go-right-north-ok
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  go-right))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c)(direction north))
        (actual_cell (pos-r ?r) (pos-c =(+ ?c 1)) (type ~border&~hill))
       => (modify ?f1 (pos-c (+ ?c 1)) (direction east)(step (+ ?i 1))
                      (time (+ ?t 15)) (dur-last-act 15))
          (modify ?f2 (step (+ ?i 1)) (time (+ ?t 15))))

(defrule go-right-north-disaster
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  go-right))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c)(direction north))
        (actual_cell (pos-r ?r) (pos-c =(+ ?c 1))(type border|hill))
     => (modify ?f2 (step (+ ?i 1)) (time (+ ?t 15)) (result disaster))
        (focus MAIN))

 (defrule go-right-south-ok
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  go-right))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c)(direction south))
        (actual_cell (pos-r ?r) (pos-c =(- ?c 1))  (type ~border&~hill))
       => (modify ?f1 (pos-c (- ?c 1)) (direction west) (step (+ ?i 1))
                      (time (+ ?t 15)) (dur-last-act 15))
          (modify ?f2 (step (+ ?i 1)) (time (+ ?t 15))))

(defrule go-right-south-disaster
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  go-right))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c)(direction south))
        (actual_cell (pos-r ?r) (pos-c =(- ?c 1)) (type border|hill))
  =>    (modify ?f2 (step (+ ?i 1)) (time (+ ?t 15)) (result disaster))
        (focus MAIN))


 (defrule go-right-west-ok
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  go-right))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c)(direction west))
        (actual_cell (pos-r =(+ ?r 1)) (pos-c ?c) (type ~border&~hill))
       => (modify ?f1 (pos-r (+ ?r 1)) (direction north) (step (+ ?i 1))
                      (time (+ ?t 15)) (dur-last-act 15))
          (modify ?f2 (step (+ ?i 1)) (time (+ ?t 15))))

(defrule go-right-west-disaster
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  go-right))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c)(direction west))
        (actual_cell (pos-r =(+ ?r 1)) (pos-c ?c) (type border|hill))
     => (modify ?f2 (step (+ ?i 1)) (time (+ ?t 15)) (result disaster))
        (focus MAIN))

(defrule go-right-east-ok
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  go-right))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c)(direction east))
        (actual_cell (pos-r =(- ?r 1)) (pos-c ?c) (type ~border&~hill))
       => (modify ?f1 (pos-r (- ?r 1)) (direction south) (step (+ ?i 1))
                      (time (+ ?t 15)) (dur-last-act 15))
          (modify ?f2 (step (+ ?i 1)) (time (+ ?t 15))))

(defrule go-right-east-disaster
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  go-right))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c)(direction east))
        (actual_cell (pos-r =(- ?r 1)) (pos-c ?c) (type border|hill))
     => (modify ?f2 (step (+ ?i 1)) (time (+ ?t 15)) (result disaster))
 (focus MAIN))

;;   REGOLE DI LOITER
(defrule loiter
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  loiter))
  ?f1<- (agentstatus (step ?i))
       => (modify ?f1 (step (+ ?i 1)) (time (+ ?t 40)) (dur-last-act 40))
          (modify ?f2 (step (+ ?i 1)) (time (+ ?t 40))))

;;   REGOLE DI Loiter-monitoring
(defrule loiter-monitor-1
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  loiter-monitoring))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c))
        (actual_cell (pos-r ?r) (pos-c ?c) (type hill|gate))
=>   (assert (perc-monitor (step (+ ?i 1)) (time (+ ?t 50)) (pos-r ?r)
                         (pos-c ?c) (perc other)))
     (modify ?f1 (step (+ ?i 1)) (time (+ ?t 50)) (dur-last-act 50))
     (modify ?f2 (step (+ ?i 1)) (time (+ ?t 50))))

(defrule loiter-monitor-2
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  loiter-monitoring))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c))
        (actual_cell (pos-r ?r) (pos-c ?c) (type lake))
=>  (assert (perc-monitor (step (+ ?i 1)) (time (+ ?t 50)) (pos-r ?r)
                         (pos-c ?c) (perc deep-water)))
    (modify ?f1 (step (+ ?i 1)) (time (+ ?t 50)) (dur-last-act 50))
    (modify ?f2 (step (+ ?i 1)) (time (+ ?t 50))))

(defrule loiter-monitor-3
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  loiter-monitoring))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c))
        (actual_cell (pos-r ?r) (pos-c ?c) (type urban|rural)
                      (actual initial-flood))
=>  (assert (perc-monitor (step (+ ?i 1)) (time (+ ?t 50)) (pos-r ?r)
                         (pos-c ?c) (perc low-water)))
    (modify ?f1 (step (+ ?i 1)) (time (+ ?t 50)) (dur-last-act 50))
    (modify ?f2 (step (+ ?i 1)) (time (+ ?t 50))))

(defrule loiter-monitor-4
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  loiter-monitoring))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c))
         (actual_cell (pos-r ?r) (pos-c ?c) (type urban|rural)
                      (actual severe-flood))
=> (assert (perc-monitor (step (+ ?i 1)) (time (+ ?t 50)) (pos-r ?r)
                         (pos-c ?c) (perc deep-water)))
    (modify ?f1 (step (+ ?i 1)) (time (+ ?t 50)) (dur-last-act 50))
    (modify ?f2 (step (+ ?i 1)) (time (+ ?t 50))))

(defrule loiter-monitor-5
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  loiter-monitoring))
  ?f1<- (agentstatus (step ?i)(pos-r ?r) (pos-c ?c))
        (actual_cell (pos-r ?r) (pos-c ?c) (type urban|rural)
                      (actual ok))
=>  (assert (perc-monitor (step (+ ?i 1)) (time (+ ?t 50)) (pos-r ?r)
                         (pos-c ?c) (perc other)))
    (modify ?f1 (step (+ ?i 1)) (time (+ ?t 50)) (dur-last-act 50))
    (modify ?f2 (step (+ ?i 1)) (time (+ ?t 50))))


;;;;******************************
;;;;******************************
;;;;          DONE

(defrule done-undiscovered1
   (declare (salience 21))
  ?f2<- (status (step ?i))
        (exec (step ?i) (action  done))
  ?f3<- (discovered (step ?i) (pos-r ?x) (pos-c ?y) (utility yes)
                        (discover no) (abstract flood))
  ?f1<- (penalty ?p)
        => (assert (penalty (+ ?p 1000000)))
           (retract ?f1 ?f3)
           )

(defrule done-undiscovered2
   (declare (salience 21))
  ?f2<- (status (step ?i))
        (exec (step ?i) (action  done))
  ?f3<- (discovered (step ?i) (pos-r ?x) (pos-c ?y) (utility yes)
                        (discover no) (abstract ok))
  ?f1<- (penalty ?p)
        => (assert (penalty (+ ?p 100000)))
           (retract ?f1 ?f3)
)

(defrule done-no-gate
   (declare (salience 20))
  ?f2<- (status (step ?i))
        (exec (step ?i) (action  done))
        (agentstatus (step ?i) (pos-r ?r) (pos-c ?c))
        (actual_cell (pos-r ?r) (pos-c ?c) (type ~gate))
  ?f1<- (penalty ?p)
        => (assert (penalty (+ ?p 2000000)))
           (retract ?f1)
          (modify ?f2 (step (+ ?i 1)) (result done))
           (focus MAIN)
)

(defrule done-in-gate
   (declare (salience 20))
  ?f2<- (status (step ?i))
        (exec (step ?i) (action  done))
        ; (agentstatus (time ?i) (pos-r ?r) (pos-c ?c))
        (agentstatus (step ?i) (pos-r ?r) (pos-c ?c))
        (actual_cell (pos-r ?r) (pos-c ?c) (type gate))
        =>
          (modify ?f2 (step (+ ?i 1)) (result done))
           (focus MAIN)
)

;;;;******************************
;;;;******************************
;;;;          INFORM

(defrule inform-precise-no-utility
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  inform) (param1 ?x) (param2 ?y)
               (param3 ?actual&ok|initial-flood|severe-flood))
  ?f4<- (discovered (step ?i) (pos-r ?x) (pos-c ?y) (utility no)
                    (precise  ?actual))
  ?f1<- (agentstatus (step ?i) (time ?t))
  ?f3<- (penalty ?p)
        => (modify  ?f1 (step (+ ?i 1))(time (+ ?t 1)) (dur-last-act 1))
           (modify  ?f2 (step (+ ?i 1))(time (+ ?t 1)))
           (modify  ?f4 (step (+ ?i 1)))
           (retract ?f3)
           (assert (penalty (+ ?p 50000)))
)

(defrule inform-precise-useful
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  inform) (param1 ?x) (param2 ?y)
              (param3 ?actual&ok|initial-flood|severe-flood))
  ?f4<- (discovered (step ?i) (pos-r ?x) (pos-c ?y) (utility yes)
                    (discover no|abstract) (precise ?actual))
  ?f1<- (agentstatus (step ?i) (time ?t))
        => (modify  ?f1 (step (+ ?i 1))(time (+ ?t 1)) (dur-last-act 1))
           (modify  ?f2 (step (+ ?i 1))(time (+ ?t 1)))
           (modify  ?f4 (step (+ ?i 1)) (discover yes) (utility no))
)

(defrule inform-precise-wrong
   (declare (salience 20))
   ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  inform) (param1 ?x) (param2 ?y)
               (param3 ?actual&ok|initial-flood|severe-flood))
  ?f4<- (discovered (step ?i) (pos-r ?x) (pos-c ?y)
                    (precise  ?actual1))
        (test (neq ?actual ?actual1))
  ?f1<- (agentstatus (step ?i) (time ?t))
  ?f3<- (penalty ?p)
        => (modify  ?f1 (step (+ ?i 1))(time (+ ?t 1)) (dur-last-act 1))
           (modify  ?f2 (step (+ ?i 1))(time (+ ?t 1)))
           (modify  ?f4 (step (+ ?i 1)))
           (retract ?f3)
           (assert (penalty (+ ?p 1000000)))
)

(defrule inform-abstract-useful
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  inform) (param1 ?x) (param2 ?y) (param3 flood))
  ?f4<- (discovered (step ?i) (pos-r ?x) (pos-c ?y) (utility yes)
                    (discover no)(abstract flood))
  ?f1<- (agentstatus (step ?i) (time ?t))
        => (modify  ?f1 (step (+ ?i 1))(time (+ ?t 1)) (dur-last-act 1))
           (modify  ?f2 (step (+ ?i 1))(time (+ ?t 1)))
           (modify  ?f4 (step (+ ?i 1))(discover abstract))
)

(defrule inform-abstract-wrong
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  inform) (param1 ?x) (param2 ?y) (param3 flood))
  ?f4<- (discovered (step ?i) (pos-r ?x) (pos-c ?y) (abstract ~flood))
  ?f1<- (agentstatus (step ?i) (time ?t))
  ?f3<- (penalty ?p)
        => (modify  ?f1 (step (+ ?i 1))(time (+ ?t 1)) (dur-last-act 1))
           (modify  ?f2 (step (+ ?i 1))(time (+ ?t 1)))
           (modify  ?f4 (step (+ ?i 1)))
           (retract ?f3)
           (assert (penalty (+ ?p 1000000)))
           )

(defrule inform-abstract-repeated
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action  inform) (param1 ?x) (param2 ?y) (param3 flood))
  ?f4<- (discovered (step ?i) (pos-r ?x) (pos-c ?y)
                    (discover abstract|yes) (abstract flood))
?f1<- (agentstatus (step ?i) (time ?t))
?f3<-  (penalty ?p)
        => (modify  ?f1 (step (+ ?i 1))(time (+ ?t 1)) (dur-last-act 1))
           (modify  ?f2 (step (+ ?i 1))(time (+ ?t 1)))
           (modify  ?f4 (step (+ ?i 1)))
           (retract ?f3)
           (assert (penalty (+ ?p 50000)))
           )

;; **************************************************************
;; **************************************************************
;;
;;  Regole per evoluzione temporale  di DISCOVERED e gestione penalità
;;  se non c'è stato aggiornamento allo step corrente di discovered di una cella
;;  si aggiorna dicovered a step corrente e sulla base della durata dell'ultima
;;  azione eseguita
;;  si aggiornano le penalità

(defrule Evolution1
	(declare (salience 10))
	(status (step ?i) (time ?t))
?f1<-	(discovered (step =(- ?i 1)) (pos-r ?r) (pos-c ?c) (discover no))
        (not (discovered (step ?i) (pos-r ?r) (pos-c ?c)))
        (actual_cell (pos-r ?r) (pos-c ?c) (type urban) (actual severe-flood))
        (agentstatus (step ?i) (dur-last-act ?dur))
?f2<-	(penalty ?p)
=>
	(modify ?f1 (step ?i))
	(assert (penalty (+ ?p (* 10 ?dur))))
	(retract ?f2)
)

(defrule Evolution2
	(declare (salience 10))
	(status (step ?i) (time ?t))
?f1<-	(discovered (step =(- ?i 1)) (pos-r ?r) (pos-c ?c) (discover no))
        (not (discovered (step ?i) (pos-r ?r) (pos-c ?c)))
        (actual_cell (pos-r ?r) (pos-c ?c) (type urban) (actual initial-flood))
        (agentstatus (step ?i) (dur-last-act ?dur))
?f2<-	(penalty ?p)
=>
	(modify ?f1 (step ?i))
	(assert (penalty (+ ?p (* 6 ?dur))))
	(retract ?f2)
)

(defrule Evolution3
	(declare (salience 10))
	(status (step ?i) (time ?t))
?f1<-	(discovered (step =(- ?i 1)) (pos-r ?r) (pos-c ?c) (discover no))
        (not (discovered (step ?i) (pos-r ?r) (pos-c ?c)))
        (actual_cell (pos-r ?r) (pos-c ?c) (type rural) (actual severe-flood))
        (agentstatus (step ?i) (dur-last-act ?dur))
?f2<-	(penalty ?p)
=>
	(modify ?f1 (step ?i))
	(assert (penalty (+ ?p (* 4 ?dur))))
	(retract ?f2)
)

(defrule Evolution4
	(declare (salience 10))
	(status (step ?i) (time ?t))
?f1<-	(discovered (step =(- ?i 1)) (pos-r ?r) (pos-c ?c) (discover no))
        (not (discovered (step ?i) (pos-r ?r) (pos-c ?c)))
        (actual_cell (pos-r ?r) (pos-c ?c) (type rural) (actual initial-flood))
        (agentstatus (step ?i) (dur-last-act ?dur))
?f2<-	(penalty ?p)
=>
	(modify ?f1 (step ?i))
	(assert (penalty (+ ?p (* 2 ?dur))))
	(retract ?f2)
)

(defrule Evolution5
	(declare (salience 10))
	(status (step ?i) (time ?t))
?f1<-	(discovered (step =(- ?i 1)) (pos-r ?r) (pos-c ?c) (discover abstract))
        (not (discovered (step ?i) (pos-r ?r) (pos-c ?c)))
        (actual_cell (pos-r ?r) (pos-c ?c) (type urban) (actual severe-flood))
        (agentstatus (step ?i) (dur-last-act ?dur))
?f2<-	(penalty ?p)
=>
	(modify ?f1 (step ?i))
	(assert (penalty (+ ?p (* 5 ?dur))))
	(retract ?f2)
)

(defrule Evolution6
	(declare (salience 10))
	(status (step ?i) (time ?t))
?f1<-	(discovered (step =(- ?i 1)) (pos-r ?r) (pos-c ?c) (discover abstract))
        (not (discovered (step ?i) (pos-r ?r) (pos-c ?c)))
        (actual_cell (pos-r ?r) (pos-c ?c) (type urban) (actual initial-flood))
        (agentstatus (step ?i) (dur-last-act ?dur))
?f2<-	(penalty ?p)
=>
	(modify ?f1 (step ?i))
	(assert (penalty (+ ?p (* 3 ?dur))))
	(retract ?f2)
)

(defrule Evolution7
	(declare (salience 10))
	(status (step ?i) (time ?t))
?f1<-	(discovered (step =(- ?i 1)) (pos-r ?r) (pos-c ?c) (discover abstract))
        (not (discovered (step ?i) (pos-r ?r) (pos-c ?c)))
        (actual_cell (pos-r ?r) (pos-c ?c) (type rural) (actual severe-flood))
        (agentstatus (step ?i) (dur-last-act ?dur))
?f2<-	(penalty ?p)
=>
	(modify ?f1 (step ?i))
	(assert (penalty (+ ?p (* 2 ?dur))))
	(retract ?f2)
)

(defrule Evolution8
	(declare (salience 10))
	(status (step ?i) (time ?t))
?f1<-	(discovered (step =(- ?i 1)) (pos-r ?r) (pos-c ?c) (discover abstract))
        (not (discovered (step ?i) (pos-r ?r) (pos-c ?c)))
        (actual_cell (pos-r ?r) (pos-c ?c) (type rural) (actual initial-flood))
        (agentstatus (step ?i) (dur-last-act ?dur))
?f2<-	(penalty ?p)
=>
	(modify ?f1 (step ?i))
	(assert (penalty (+ ?p (* 1 ?dur))))
	(retract ?f2)
)

(defrule Evolution9
	(declare (salience 10))
	(status (step ?i) (time ?t))
?f1<-	(discovered (step =(- ?i 1)) (pos-r ?r) (pos-c ?c) (discover no))
        (not (discovered (step ?i) (pos-r ?r) (pos-c ?c)))
        (actual_cell (pos-r ?r) (pos-c ?c) (type rural|urban) (actual ok))
        (agentstatus (step ?i) (dur-last-act ?dur))
?f2<-	(penalty ?p)
=>
	(modify ?f1 (step ?i))
	(assert (penalty (+ ?p (* 1 ?dur))))
	(retract ?f2)
)

(defrule Evolution10
	(declare (salience 9))
	(status (step ?i) (time ?t))
?f1<-	(discovered (step =(- ?i 1)) (pos-r ?r) (pos-c ?c))
        (not (discovered (step ?i) (pos-r ?r) (pos-c ?c)))
=>
	(modify ?f1 (step ?i))
)


;;;;******************************************
;;;;******************************************
;;;;          GENERAZIONE PERCEZIONI VISIVE

(defrule percept-north
(declare (salience 5))
  ?f1<- (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction north))
        (actual_cell (pos-r =(+ ?r 1)) (pos-c =(- ?c 1)) (type ?x1))
        (actual_cell (pos-r =(+ ?r 1)) (pos-c ?c)  (type ?x2))
        (actual_cell (pos-r =(+ ?r 1)) (pos-c =(+ ?c 1)) (type ?x3))
        (actual_cell (pos-r ?r)  (pos-c =(- ?c 1)) (type ?x4))
        (actual_cell (pos-r ?r)  (pos-c ?c)  (type ?x5))
        (actual_cell (pos-r ?r)  (pos-c =(+ ?c 1)) (type ?x6))
        (actual_cell (pos-r =(- ?r 1)) (pos-c =(- ?c 1)) (type ?x7))
        (actual_cell (pos-r =(- ?r 1)) (pos-c ?c)  (type ?x8))
        (actual_cell (pos-r =(- ?r 1)) (pos-c =(+ ?c 1)) (type ?x9))
      =>
        (assert (perc-vision (time ?t) (step ?i) (pos-r ?r) (pos-c ?c)
                           (direction north)
                           (perc1 ?x1) (perc2 ?x2) (perc3 ?x3)
                           (perc4 ?x4) (perc5 ?x5) (perc6 ?x6)
                           (perc7 ?x7) (perc8 ?x8) (perc9 ?x9)))
)

(defrule percept-north-water1
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction north))
         (or (actual_cell (pos-r =(+ ?r 1)) (pos-c =(- ?c 1)) (type lake))
             (actual_cell (pos-r =(+ ?r 1)) (pos-c =(- ?c 1))
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 1 ?i))
     => (modify ?f2 (perc1 water))
        (assert (percwater 1 ?i)))

(defrule percept-north-water2
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction north))
         (or (actual_cell (pos-r =(+ ?r 1)) (pos-c ?c) (type lake))
             (actual_cell (pos-r =(+ ?r 1)) (pos-c ?c)
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 2 ?i))
     => (modify ?f2 (perc2 water))
        (assert (percwater 2 ?i)))

(defrule percept-north-water3
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction north))
         (or (actual_cell (pos-r =(+ ?r 1)) (pos-c =(+ ?c 1)) (type lake))
             (actual_cell (pos-r =(+ ?r 1)) (pos-c =(+ ?c 1))
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 3 ?i))
     => (modify ?f2 (perc3 water))
        (assert (percwater 3 ?i)))

(defrule percept-north-water4
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction north))
         (or (actual_cell (pos-r ?r) (pos-c =(- ?c 1)) (type lake))
             (actual_cell (pos-r ?r) (pos-c =(- ?c 1))
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 4 ?i))
     => (modify ?f2 (perc4 water))
        (assert (percwater 4 ?i)))

(defrule percept-water5
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     )
         (or (actual_cell (pos-r ?r) (pos-c ?c) (type lake))
             (actual_cell (pos-r ?r) (pos-c ?c)
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 5 ?i))
     => (modify ?f2 (perc5 water))
        (assert (percwater 5 ?i)))

(defrule percept-north-water6
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction north))
         (or (actual_cell (pos-r ?r) (pos-c =(+ ?c 1)) (type lake))
             (actual_cell (pos-r ?r) (pos-c =(+ ?c 1))
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 6 ?i))
     => (modify ?f2 (perc6 water))
        (assert (percwater 6 ?i)))

(defrule percept-north-water7
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction north))
         (or (actual_cell (pos-r =(- ?r 1)) (pos-c =(- ?c 1)) (type lake))
             (actual_cell (pos-r =(- ?r 1)) (pos-c =(- ?c 1))
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 7 ?i))
     => (modify ?f2 (perc7 water))
        (assert (percwater 7 ?i)))

(defrule percept-north-water8
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction north))
         (or (actual_cell (pos-r =(- ?r 1)) (pos-c ?c) (type lake))
             (actual_cell (pos-r =(- ?r 1)) (pos-c ?c)
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 8 ?i))
     => (modify ?f2 (perc8 water))
        (assert (percwater 8 ?i)))

(defrule percept-north-water9
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction north))
         (or (actual_cell (pos-r =(- ?r 1)) (pos-c =(+ ?c 1)) (type lake))
             (actual_cell (pos-r =(- ?r 1)) (pos-c =(+ ?c 1))
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 9 ?i))
     => (modify ?f2 (perc9 water))
        (assert (percwater 9 ?i)))

(defrule percept-south
(declare (salience 5))
  ?f1<- (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction south))
        (actual_cell (pos-r =(- ?r 1)) (pos-c =(+ ?c 1)) (type ?x1))
        (actual_cell (pos-r =(- ?r 1)) (pos-c ?c)  (type ?x2))
        (actual_cell (pos-r =(- ?r 1)) (pos-c =(- ?c 1)) (type ?x3))
        (actual_cell (pos-r ?r)  (pos-c =(+ ?c 1)) (type ?x4))
        (actual_cell (pos-r ?r)  (pos-c ?c)  (type ?x5))
        (actual_cell (pos-r ?r)  (pos-c =(- ?c 1)) (type ?x6))
        (actual_cell (pos-r =(+ ?r 1)) (pos-c =(+ ?c 1)) (type ?x7))
        (actual_cell (pos-r =(+ ?r 1)) (pos-c ?c)  (type ?x8))
        (actual_cell (pos-r =(+ ?r 1)) (pos-c =(- ?c 1)) (type ?x9))
      =>
        (assert (perc-vision (time ?t) (step ?i) (pos-r ?r) (pos-c ?c)
                           (direction south)
                           (perc1 ?x1) (perc2 ?x2) (perc3 ?x3)
                           (perc4 ?x4) (perc5 ?x5) (perc6 ?x6)
                           (perc7 ?x7) (perc8 ?x8) (perc9 ?x9)))
       )

(defrule percept-south-water1
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction south))
         (or (actual_cell (pos-r =(- ?r 1)) (pos-c =(+ ?c 1))  (type lake))
             (actual_cell (pos-r =(- ?r 1)) (pos-c =(+ ?c 1))
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 1 ?i))
     => (modify ?f2 (perc1 water))
        (assert (percwater 1 ?i)))

(defrule percept-south-water2
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction south))
         (or (actual_cell (pos-r =(- ?r 1)) (pos-c ?c) (type lake))
             (actual_cell (pos-r =(- ?r 1)) (pos-c ?c)
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 2 ?i))
     => (modify ?f2 (perc2 water))
        (assert (percwater 2 ?i)))

(defrule percept-south-water3
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction south))
         (or (actual_cell (pos-r =(- ?r 1)) (pos-c =(- ?c 1)) (type lake))
             (actual_cell (pos-r =(- ?r 1)) (pos-c =(- ?c 1))
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 3 ?i))
     => (modify ?f2 (perc3 water))
        (assert (percwater 3 ?i)))

(defrule percept-south-water4
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction south))
         (or (actual_cell (pos-r ?r) (pos-c =(+ ?c 1)) (type lake))
             (actual_cell (pos-r ?r) (pos-c =(+ ?c 1))
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 4 ?i))
     => (modify ?f2 (perc4 water))
        (assert (percwater 4 ?i)))

(defrule percept-south-water6
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction south))
         (or (actual_cell (pos-r ?r) (pos-c =(- ?c 1)) (type lake))
             (actual_cell (pos-r ?r) (pos-c =(- ?c 1))
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 6 ?i))
     => (modify ?f2 (perc6 water))
        (assert (percwater 6 ?i)))

(defrule percept-south-water7
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction south))
         (or (actual_cell (pos-r =(+ ?r 1)) (pos-c =(+ ?c 1)) (type lake))
             (actual_cell (pos-r =(+ ?r 1)) (pos-c =(+ ?c 1))
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 7 ?i))
     => (modify ?f2 (perc7 water))
        (assert (percwater 7 ?i)))

(defrule percept-south-water8
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction north))
         (or (actual_cell (pos-r =(+ ?r 1)) (pos-c ?c) (type lake))
             (actual_cell (pos-r =(+ ?r 1)) (pos-c ?c)
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 8 ?i))
     => (modify ?f2 (perc8 water))
        (assert (percwater 8 ?i)))

(defrule percept-south-water9
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction south))
         (or (actual_cell (pos-r =(+ ?r 1)) (pos-c =(- ?c 1)) (type lake))
             (actual_cell (pos-r =(+ ?r 1)) (pos-c =(- ?c 1))
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 9 ?i))
     => (modify ?f2 (perc9 water))
        (assert (percwater 9 ?i)))

(defrule percept-east
(declare (salience 5))
  ?f1<- (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction east))
        (actual_cell (pos-r =(+ ?r 1)) (pos-c =(+ ?c 1)) (type ?x1))
        (actual_cell (pos-c =(+ ?c 1)) (pos-r ?r)  (type ?x2))
        (actual_cell (pos-r =(- ?r 1)) (pos-c =(+ ?c 1)) (type ?x3))
        (actual_cell (pos-c ?c)  (pos-r =(+ ?r 1)) (type ?x4))
        (actual_cell (pos-c ?c)  (pos-r ?r)  (type ?x5))
        (actual_cell (pos-c ?c)  (pos-r =(- ?r 1)) (type ?x6))
        (actual_cell (pos-c =(- ?c 1)) (pos-r =(+ ?r 1)) (type ?x7))
        (actual_cell (pos-c =(- ?c 1)) (pos-r ?r)  (type ?x8))
        (actual_cell (pos-c =(- ?c 1)) (pos-r =(- ?r 1)) (type ?x9))
      =>
        (assert (perc-vision (time ?t) (step ?i) (pos-r ?r) (pos-c ?c)
                           (direction east)
                           (perc1 ?x1) (perc2 ?x2) (perc3 ?x3)
                           (perc4 ?x4) (perc5 ?x5) (perc6 ?x6)
                           (perc7 ?x7) (perc8 ?x8) (perc9 ?x9)))
       )

(defrule percept-east-water1
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction east))
         (or (actual_cell (pos-r =(+ ?r 1)) (pos-c =(+ ?c 1)) (type lake))
             (actual_cell (pos-r =(+ ?r 1)) (pos-c =(+ ?c 1))
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 1 ?i))
     => (modify ?f2 (perc1 water))
        (assert (percwater 1 ?i)))

(defrule percept-east-water2
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction east))
         (or (actual_cell (pos-c =(+ ?c 1)) (pos-r ?r) (type lake))
             (actual_cell (pos-c =(+ ?c 1)) (pos-r ?r)
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 2 ?i))
     => (modify ?f2 (perc2 water))
        (assert (percwater 2 ?i)))

(defrule percept-east-water3
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction east))
         (or (actual_cell (pos-r =(- ?r 1)) (pos-c =(+ ?c 1))  (type lake))
             (actual_cell (pos-r =(- ?r 1)) (pos-c =(+ ?c 1))
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 3 ?i))
     => (modify ?f2 (perc3 water))
        (assert (percwater 3 ?i)))

(defrule percept-east-water4
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction east))
         (or (actual_cell (pos-c ?c)  (pos-r =(+ ?r 1)) (type lake))
             (actual_cell (pos-c ?c)  (pos-r =(+ ?r 1)) (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 4 ?i))
     => (modify ?f2 (perc4 water))
        (assert (percwater 4 ?i)))

(defrule percept-east-water6
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction east))
         (or (actual_cell (pos-c ?c) (pos-r =(- ?r 1)) (type lake))
             (actual_cell (pos-c ?c) (pos-r =(- ?r 1))
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 6 ?i))
     => (modify ?f2 (perc6 water))
        (assert (percwater 6 ?i)))

(defrule percept-east-water7
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction east))
         (or (actual_cell (pos-c =(- ?c 1)) (pos-r =(+ ?r 1)) (type lake))
             (actual_cell (pos-c =(- ?c 1)) (pos-r =(+ ?r 1))
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 7 ?i))
     => (modify ?f2 (perc7 water))
        (assert (percwater 7 ?i)))

(defrule percept-east-water8
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction east))
         (or (actual_cell (pos-c =(- ?c 1)) (pos-r ?r) (type lake))
             (actual_cell (pos-c =(- ?c 1)) (pos-r ?r)
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 8 ?i))
     => (modify ?f2 (perc8 water))
        (assert (percwater 8 ?i)))

(defrule percept-east-water9
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction east))
         (or (actual_cell (pos-r =(- ?r 1)) (pos-c =(- ?c 1)) (type lake))
             (actual_cell (pos-r =(- ?r 1)) (pos-c =(- ?c 1))
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 9 ?i))
     => (modify ?f2 (perc9 water))
        (assert (percwater 9 ?i)))

(defrule percept-west
(declare (salience 5))
  ?f1<- (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction west))
        (actual_cell (pos-r =(- ?r 1)) (pos-c =(- ?c 1)) (type ?x1))
        (actual_cell (pos-c =(- ?c 1)) (pos-r ?r)  (type ?x2))
        (actual_cell (pos-r =(+ ?r 1)) (pos-c =(- ?c 1)) (type ?x3))
        (actual_cell (pos-c ?c)  (pos-r =(- ?r 1)) (type ?x4))
        (actual_cell (pos-c ?c)  (pos-r ?r)  (type ?x5))
        (actual_cell (pos-c ?c)  (pos-r =(+ ?r 1)) (type ?x6))
        (actual_cell (pos-c =(+ ?c 1)) (pos-r =(- ?r 1)) (type ?x7))
        (actual_cell (pos-c =(+ ?c 1)) (pos-r ?r)  (type ?x8))
        (actual_cell (pos-c =(+ ?c 1)) (pos-r =(+ ?r 1)) (type ?x9))
      =>
        (assert (perc-vision (time ?t) (step ?i) (pos-r ?r) (pos-c ?c)
                           (direction west)
                           (perc1 ?x1) (perc2 ?x2) (perc3 ?x3)
                           (perc4 ?x4) (perc5 ?x5) (perc6 ?x6)
                           (perc7 ?x7) (perc8 ?x8) (perc9 ?x9)))
       )

(defrule percept-west-water1
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction west))
         (or (actual_cell (pos-r =(- ?r 1)) (pos-c =(- ?c 1)) (type lake))
             (actual_cell (pos-r =(- ?r 1)) (pos-c =(- ?c 1))
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 1 ?i))
     => (modify ?f2 (perc1 water))
        (assert (percwater 1 ?i)))

(defrule percept-west-water2
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction west))
         (or (actual_cell (pos-c =(- ?c 1)) (pos-r ?r) (type lake))
             (actual_cell (pos-c =(- ?c 1)) (pos-r ?r)
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 2 ?i))
     => (modify ?f2 (perc2 water))
        (assert (percwater 2 ?i)))

(defrule percept-west-water3
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction west))
         (or (actual_cell (pos-r =(+ ?r 1)) (pos-c =(- ?c 1))  (type lake))
             (actual_cell (pos-r =(+ ?r 1)) (pos-c =(- ?c 1))
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 3 ?i))
     => (modify ?f2 (perc3 water))
        (assert (percwater 3 ?i)))

(defrule percept-west-water4
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction west))
         (or (actual_cell (pos-c ?c)  (pos-r =(- ?r 1)) (type lake))
             (actual_cell (pos-c ?c)  (pos-r =(- ?r 1)) (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 4 ?i))
     => (modify ?f2 (perc4 water))
        (assert (percwater 4 ?i)))

(defrule percept-west-water6
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction west))
         (or (actual_cell (pos-c ?c) (pos-r =(+ ?r 1)) (type lake))
             (actual_cell (pos-c ?c) (pos-r =(+ ?r 1))
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 6 ?i))
     => (modify ?f2 (perc6 water))
        (assert (percwater 6 ?i)))

(defrule percept-west-water7
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction west))
         (or (actual_cell (pos-c =(+ ?c 1)) (pos-r =(- ?r 1)) (type lake))
             (actual_cell (pos-c =(+ ?c 1)) (pos-r =(- ?r 1))
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 7 ?i))
     => (modify ?f2 (perc7 water))
        (assert (percwater 7 ?i)))

(defrule percept-west-water8
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction west))
         (or (actual_cell (pos-c =(+ ?c 1)) (pos-r ?r) (type lake))
             (actual_cell (pos-c =(+ ?c 1)) (pos-r ?r)
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 8 ?i))
     => (modify ?f2 (perc8 water))
        (assert (percwater 8 ?i)))

(defrule percept-west-water9
(declare (salience 4))
         (agentstatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c)
                     (direction west))
         (or (actual_cell (pos-r =(+ ?r 1)) (pos-c =(+ ?c 1)) (type lake))
             (actual_cell (pos-r =(+ ?r 1)) (pos-c =(+ ?c 1))
                          (type rural|urban)
                          (actual initial-flood|severe-flood)))
  ?f2<- (perc-vision (step ?i))
        (not (percwater 9 ?i))
     => (modify ?f2 (perc9 water))
        (assert (percwater 9 ?i)))

(defrule perc-vision-done
(declare (salience 3))
    (status (time ?t))
     =>
        (focus MAIN))

