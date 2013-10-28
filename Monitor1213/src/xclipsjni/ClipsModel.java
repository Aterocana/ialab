package xclipsjni;

import java.util.Observable;
import monitor1213.DebugFrame;

/**Questa classe astratta è la parte di model (in un'architettura MVC) che si interfaccia e mantiene con i dati.
 * Nella fattispecie, le implentazioni di questa classe dovranno mantenere copie
 * dei fatti rilevanti estratti dall'ambiente di clips, cosicchè possano essere usati per le interfacce.
 * Estendendo Observable qualunque view che voglia essere aggiornata con i cambiamenti del model deve implementare Observer.
 *
 * @author Piovesan Luca, Verdoja Francesco
 * Edited by: @author  Violanti Luca, Varesano Marco, Busso Marco, Cotrino Roberto
 */
public abstract class ClipsModel extends Observable implements Runnable {

	protected ClipsCore core;
	private boolean stepByStep;
	private boolean onlyRunOne;
	private Thread t;

	/**costruttore del modello.
	 * 
	 */
	public ClipsModel() {
		stepByStep = true;
		onlyRunOne = false;
		t = new Thread(this);
	}

	/**Esegue l'ambiente in singlethread. Per eseguire l'ambiente in multithread vedere il metodo execute().
	 *
	 */
	@Override
	public void run() {
		try {
			core.reset();
			setup();
			this.setChanged();
			this.notifyObservers("setupDone");
			while (!hasDone()) {
				if (stepByStep) {
					this.suspend();
				}
				if (onlyRunOne) {
					core.step();
				} else {
					core.run();
				}
				action();
				this.setChanged();
				this.notifyObservers("actionDone");
			}
			dispose();
			this.setChanged();
			this.notifyObservers("disposeDone");
		} catch (Exception ex) {
			this.setChanged();
			this.notifyObservers(ex.toString());
		}
	}

	/**Esegue l'ambiente su un nuovo thread.
	 * Meglio a livello di prestazioni rispetto al metodo run() perchè sfrutta il multithread.
	 *
	 */
	public void execute() {
		t.start();
	}
	
	/**Cambia la modalita' di esecuzione dell'environment.
	 *
	 * @param mode ha 3 valori ammessi: RUN per eseguire i passi consecutivamente senza interruzioni,
	 * RUNONE per eseguire un passo Clips alla volta (in fase di debug),
	 * STEP per eseguire una exec alla volta.
	 */
	public synchronized void setMode(String mode) {
		if (mode.equals("RUN")) {
			stepByStep = false;
			onlyRunOne = false;
		}
		if (mode.equals("RUNONE")) {
			stepByStep = true;
			onlyRunOne = true;
		}
		if (mode.equals("STEP")) {
			stepByStep = true;
			onlyRunOne = false;
		}
	}

	/**Avvia l'environment di clips nel caso di default
	 * 
	 */
	public void startCore() {
		core = new ClipsCore();
		//System.out.println("[Clips Environment created and ready to run]");
                DebugFrame.appendText("[Clips Environment created and ready to run]");
	}
        
        /**Avvia l'environment di clips nel caso di mappe personalizzate
	 * 
	 * @param initialPath il path al file clips contenente la mappa "initial"
         * @param actualPath il path al file clips contenente la mappa "actual"
	 */
        public void startCore(String initialPath, String actualPath) {
		core = new ClipsCore(initialPath, actualPath);
		//System.out.println("[Clips Environment created and ready to run]");
                DebugFrame.appendText("[Clips Environment created and ready to run]");
	}

	/**Equivalente alla funzione facts di Clips.
	 * Restituisce la lista dei fatti del modulo corrente.
	 *
	 * @return una stringa che rappresenta i fatti del modulo corrente
	 * @throws ClipsException
	 */
	public synchronized String getFactList() throws ClipsException {
		return core.getFactList();
	}

	/**Equivalente alla funzione agenda di Clips.
	 * Restituisce la lista delle regole attualmente attivabili, in ordine di priorita' di attivazione.
	 *
	 * @return una stringa che rappresenta le azioni attivabili al momento
	 * @throws ClipsException
	 */
	public synchronized String getAgenda() throws ClipsException {
		return core.getAgenda();
	}

	/**Inizializza l'intero ambiente. Questo metodo viene invocato una sola volta all'inizio dell'applicazione.
	 *
	 * @throws ClipsException
	 */
	protected abstract void setup() throws ClipsException;

	/**Fa avanzare l'ambiente di un turno. Viene invocato ciclicamente finche' hasDone == false.
	 *
	 * @throws ClipsException
	 */
	protected abstract void action() throws ClipsException;

	/**Indica se l'ambiente ha finito la naturale esecuzione.
	 *
	 * @return true se l'esecuzione dell'ambiente e' terminata, false altrimenti
	 */
	protected abstract boolean hasDone();

	/**Pone fine all'ambiente costruendo i risultati e le statistiche finali. Eseguita un'unica volta dopo che hasDone == true.
	 *
	 * @throws ClipsException
	 */
	protected abstract void dispose() throws ClipsException;

	/**riprende il thread sospeso tramite il metodo suspend()
	 * 
	 */
	void resume() {
		t.resume();
	}

	/**sospende il thread, può essere ripreso con il metodo resume()
	 * 
	 */
	private void suspend() {
		t.suspend();
	}
}
