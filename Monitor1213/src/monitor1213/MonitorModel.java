package monitor1213;

import xclipsjni.ClipsModel;
import xclipsjni.ClipsException;

/**
 * L'implementazione della classe ClipsModel specifica per il progetto Monitor
 * 2012/2013.
 *
 * @author Violanti Luca, Varesano Marco, Busso Marco, Cotrino Roberto
 */
public class MonitorModel extends ClipsModel {

    private String[][] map;
    private String direction;
    private int durlastact;
    private Integer time;
    private Integer step;
    private Integer maxduration;
    private String result;
    private String communications;
    private int score;

    /**
     * Costruttore del modello per il progetto Monitor
     *
     */
    public MonitorModel() {
        super();
    }

    /**
     * Inizializza il modello in base al contenuto del file clips caricato.
     *
     */
    private synchronized void init() {
        result = "no";
        time = 0;
        step = 0;
        maxduration = Integer.MAX_VALUE;
        try {
            //System.out.println("RICERCA DEI PARAMETRI DI FINE IN CORSO...");
            DebugFrame.appendText("RICERCA DEI PARAMETRI DI FINE IN CORSO...");
            maxduration = new Integer(core.findOrderedFact("MAIN", "maxduration"));
            //System.out.println("INIZIALIZZAZIONE DELLA MAPPA IN CORSO...");
            DebugFrame.appendText("INIZIALIZZAZIONE DELLA MAPPA IN CORSO...");
            String[] array = {"pos-r", "pos-c", "type"};
            String[][] mp = core.findAllFacts("MAIN", "prior_cell", "TRUE", array);
            int maxr = 0;
            int maxc = 0;
            for (int i = 0; i < mp.length; i++) {
                int r = new Integer(mp[i][0]);
                int c = new Integer(mp[i][1]);
                if (r > maxr) {
                    maxr = r;
                }
                if (c > maxc) {
                    maxc = c;
                }
            }
            map = new String[maxr][maxc];
            for (int i = 0; i < mp.length; i++) {
                int r = new Integer(mp[i][0]);
                int c = new Integer(mp[i][1]);
                map[r - 1][c - 1] = mp[i][2];
            }
            //System.out.println("INIZIALIZZATA LA MAPPA");
            DebugFrame.appendText("INIZIALIZZATA LA MAPPA");
            
        } catch (ClipsException ex) {
            //System.out.println("SI E' VERIFICATO UN ERRORE DURANTE L'INIZIALIZZAZIONE: ");
            DebugFrame.appendText("SI E' VERIFICATO UN ERRORE DURANTE L'INIZIALIZZAZIONE: ");
            //System.out.println(ex.toString());
            DebugFrame.appendText(ex.toString());
        }
    }

    //ATTENZIONE: questo metodo aggiorna la mappa ogni volta che si esegue un'azione,
    // questo perché nella versione 2010 il mondo era dinamico,
    // mentre nella versione attuale la mappa è statica!
    /**
     * Aggiorna la mappa leggendola dal file clips
     *
     * @throws ClipsException
     */
    private synchronized void updateMap() throws ClipsException {
        //System.out.println("AGGIORNAMENTO MAPPA IN CORSO...");
        DebugFrame.appendText("AGGIORNAMENTO MAPPA IN CORSO...");
        String[] array = {"pos-r", "pos-c", "type", "actual"};
        String[][] mp;
        mp = core.findAllFacts("ENV", "actual_cell", "TRUE", array);
        for (int i = 0; i < mp.length; i++) {
            int r = new Integer(mp[i][0]);
            int c = new Integer(mp[i][1]);
            // agggiunto underscore per la sovrapposizione dei tag di type e actual
            map[r - 1][c - 1] = mp[i][2] + "_" + mp[i][3];
        }
        //System.out.println("...RIEMPITA BASE...");
        DebugFrame.appendText("...RIEMPITA BASE...");
        String[] arrayRobot = {"pos-r", "pos-c", "direction", "dur-last-act", "time", "step"};
        String[] robot = core.findFact("ENV", "agentstatus", "TRUE", arrayRobot);
        if (robot[0] != null) {
            int r = new Integer(robot[0]);
            int c = new Integer(robot[1]);
            direction = robot[2];
            durlastact = new Integer(robot[3]);
            time = new Integer(robot[4]);
            step = new Integer(robot[5]);
            String background = map[r - 1][c - 1];
            map[r - 1][c - 1] = "robot_" + background;
        }
        //nel vecchio progetto ogni azione costava una unità di tempo;
        //nel vecchio progetto veniva stampato l'equivalente del nostro step
        //System.out.println("...AGGIORNATO LO STATO DEL ROBOT...");
        DebugFrame.appendText("...AGGIORNATO LO STATO DEL ROBOT...");
        String[] arrayStatus = {"step", "time", "result"};
        String[] status = core.findFact("MAIN", "status", "TRUE", arrayStatus);
        if (status[0] != null) {
            step = new Integer(status[0]);
            time = new Integer(status[1]);
            result = status[2];
            //System.out.println("STEP: " + step + " TIME: " + time + " RESULT: " + result);
            DebugFrame.appendText("STEP: " + step + " TIME: " + time + " RESULT: " + result);
        }
        //System.out.println("...AGGIORNATO LO STATUS...");
        DebugFrame.appendText("...AGGIORNATO LO STATUS...");
        String[] arrayExec = {"action", "param1", "param2", "param3"};
        String[] exec = core.findFact("MAIN", "exec", "= ?f:step " + step, arrayExec);
        // N.B.: la stampa di "inform..." è effettuata prima di eseguire
        // l'azione di inform vera e propria
        if (exec[0] != null && exec[0].equalsIgnoreCase("inform")) {
            communications = "step: " + step + ", inform about (" + exec[1] + "," + exec[2] + "," + exec[3] + ")";
        } else {
            communications = null;
        }

//        if (DEBUG) {
//            System.out.println("Da eseguire: " + exec[0]);
//        }
        DebugFrame.appendText("Da eseguire: " + exec[0]);

//        System.out.println("...AGGIORNATE LE COMUNICAZIONI...");
//        System.out.println("AGGIORNAMENTO COMPLETATO");
        DebugFrame.appendText("...AGGIORNATE LE COMUNICAZIONI...");
        DebugFrame.appendText("AGGIORNAMENTO COMPLETATO");
    }

    /**
     * metodo per ottenere tutte le comunicazioni fatte dall'agente fino a
     * questo momento.
     *
     * @return una stringa contenente le comunicazioni
     */
    public synchronized String getCommunications() {
        return communications;
    }

    /**
     * metodo per ottenere la mappa dell'ambiente come vista nel modulo ENV.
     *
     * @return la mappa come matrice di stringhe
     */
    public synchronized String[][] getMap() {
        return map;
    }

    /**
     * metodo per ottenere il verso in cui è girato l'agente
     *
     * @return up, down, left, right
     */
    public synchronized String getDirection() {
        return direction;
    }

    /**
     * metodo per ottenere il punteggio dell'agente totalizzato a seguito delle
     * sue azioni
     *
     * @return il punteggio come intero
     */
    public synchronized int getScore() {
        return score;
    }

    /**
     * metodo per ottenere il motivo della terminazione dell'ambiente
     *
     * @return disaster, done
     */
    public synchronized String getResult() {
        return result;
    }

    /**
     * metodo da chiamare per ottenere il turno attuale
     *
     * @return il turno attuale come intero
     */
    public synchronized int getTime() {
        return time;
    }

    /**
     * metodo da chiamare per ottenere il turno attuale
     *
     * @return il turno attuale come intero
     */
    public synchronized int getStep() {
        return step;
    }

    /**
     * metodo per ottenere il tempo massimo a disposizione dell'agente
     *
     * @return il tempo massimo come intero
     */
    public synchronized int getMaxDuration() {
        return maxduration;
    }

    /**
     * metodo per ottenere il campo dur-last-act
     *
     * @return il tempo massimo come intero
     */
    public synchronized int getDurLastAct() {
        return durlastact;
    }

    @Override
    protected void setup() throws ClipsException {
        init();
    }

    @Override
    protected void action() throws ClipsException {
        updateMap();
    }

    @Override
    protected boolean hasDone() {
        //finisce se time==maxduration
        if (time >= maxduration) {
            return true;
        }
        //o se result e' "disaster" o "done"
        return (!result.equalsIgnoreCase("no"));
    }

    @Override
    protected void dispose() throws ClipsException {
        score = new Integer(core.findOrderedFact("MAIN", "penalty"));
    }
}