; Questo programma contiene la bozza di codice CLIPS per MONITOR 2013
;
; Una descrizione metodologica è contenuta nel file Monitor-2013

(defmodule MAIN (export ?ALL))

;; LE AZIONI CHE PUÓ FARE UAV:
(deftemplate exec
      (slot step) 
      (slot action 
      (allowed-values go-forward go-left go-right loiter loiter-monitoring inform done))
      (slot param1)
      (slot param2)
      (slot param3 (allowed-values ok flood initial-flood severe-flood)))
	  
	  
;; ***** LE NOSTRE MODIFICHE *****
(deftemplate dummy_target
			(slot pos-x)
			(slot pos-y)
)

(deftemplate nearest_gate 
			(slot pos-x) 
			(slot pos-y)
)


;; lo stato globale fornito dal sistema
(deftemplate status (slot step) (slot time) (slot result) )

;; la percezione visiva fornita dopo ogni azione
(deftemplate perc-vision
          (slot step)
          (slot time)
          (slot pos-r)
          (slot pos-c)
          (slot direction (allowed-values  north west south east))
          (slot perc1 (allowed-values  urban rural hill water gate border))
          (slot perc2 (allowed-values  urban rural hill water gate border))
          (slot perc3 (allowed-values  urban rural hill water gate border))
          (slot perc4 (allowed-values  urban rural hill water gate border))
          (slot perc5 (allowed-values  urban rural water))
	      (slot perc6 (allowed-values  urban rural hill water gate border))
          (slot perc7 (allowed-values  urban rural hill water gate border))
          (slot perc8 (allowed-values  urban rural hill water gate border))
          (slot perc9 (allowed-values  urban rural hill water gate border))
          )

;; La percezione perc-monitor viene restituita dal modulo ENV solo quando al 
;; passo precedente è stata eseguita una azione di LoiterMonitor. 
;; Nello slot perc viene restituita la percezione precisa che è other se il 
;; monitoraggio preciso viene richiesto su una cella che non contiene acqua.
(deftemplate perc-monitor
               (slot step)
               (slot time)
               (slot pos-r)
               (slot pos-c)
               (slot perc  (allowed-values low-water deep-water other)))

;; l’agente ha una conoscenza a priori su come è fatto l’ambiente PRIMA 
;; degli eventi meteorologici che sono causa dell’esondazione. 
;; Questa  conoscenza a priori è definita nel MAIN e quindi è accessibile anche all’agente.
(deftemplate prior_cell 
	(slot pos-r)
	(slot pos-c)
	(slot type (allowed-values urban rural lake hill gate border)))

;;  questo template serve solo per avere una struttura per asserire lo stato iniziale dell'agente
;;  L'informazione deve essere messa nel file 2_initial_map.clp
;;  quasta info viene propagata per mezzo di regole sia ad agenstatus in ENV che in kagent in AGENT

(deftemplate initial_agentstatus 
	(slot pos-r) 
	(slot pos-c)
	(slot direction))

(defrule createworld 
    ?f<-   (create) =>
           (assert (create-actual-map) (create-initial-setting) (create-discovered))  
           (retract ?f)
           (focus ENV))        

;; SI PASSA AL MODULO AGENT SE NON  E' ESAURITO IL TEMPO (indicato da maxduration)
(defrule go-on-agent
   (declare (salience 20))
        (maxduration ?d)
        (status (time ?t&:(< ?t ?d)) (result no))
 => 
        ;(printout t crlf crlf)
        ;(printout t "vado ad agent  " ?t)
        (focus AGENT))

;; tempo esaurito
(defrule finish1
   (declare (salience 20))
        (maxduration ?d)
        (status (time ?t) (result no))
        (test (or (> ?t ?d) (= ?t ?d)))
        (penalty ?p)
          =>       
          (printout t crlf crlf)
          (printout t "time over   " ?t)
          (printout t crlf crlf)
          (printout t "penalty:" (+ ?p 10000000))
          (printout t crlf crlf)
          (halt))

;; l'agent ha dichiarato che ha terminato il suo compito (messaggio done)
(defrule finish2
   (declare (salience 20))
        (status (time ?t) (result done))
        (penalty ?p)
          => 
          (printout t crlf crlf)
          (printout t "done at time   " ?t)
          (printout t crlf crlf)
          (printout t "penalty:" ?p)
          (printout t crlf crlf)
          (halt))

;; SI BLOCCA TUTTO SE OCCORRE DISASTER 
(defrule disaster
   (declare (salience 20))
        (status (time ?t) (result disaster))
 => 
        (printout t crlf crlf)
        (printout t "Sorry, UAV has been gone lost at time:" ?t)
        (printout t crlf crlf)
        (halt))

;;  SI PASSA AL MODULO ENV DOPO CHE AGENTE HA DECISO L'AZIONE DA FARE
(defrule go-on-env	
	(declare (salience 21))
?f1<-	(status (step ?i))
	(exec (step ?i)) 
=>
	(focus ENV))
