package xclipsjni;

import java.awt.Dimension;
import java.awt.Toolkit;
import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;
import java.io.File;
import java.io.IOException;
import java.util.Observable;
import java.util.Observer;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.filechooser.FileFilter;
import monitor1213.DebugFrame;

/**
 * Questa classe implementa il pannello di controllo di clips, questo modulo
 * consente di svolgere tutte le azioni più utili, fra cui: caricamento di un
 * file clips, run, run(1) e run di un turno, visualizzazione agenda e
 * visualizzazione fatti. Questo pannello può essere integrato in un'interfaccia
 * comprendente altre componenti, grazie al metodo getControlPanel(), oppure può
 * essere usato come finestra a se stante semplicemente attraverso il
 * costruttore.
 *
 * @author Piovesan Luca, Verdoja Francesco Edited by:
 * @author Violanti Luca, Varesano Marco, Busso Marco, Cotrino Roberto
 */
class ControlPanel extends JFrame implements Observer {

    ClipsModel model;
    PropertyMonitor agendaMonitor;
    PropertyMonitor factsMonitor;
    PropertyMonitor debugMonitor;

    /**
     * Crea un nuovo Pannello di controllo per un ambiente clips
     *
     * @param model il modello da controllare
     */
    public ControlPanel(ClipsModel model) {
        initComponents();
        this.model = model;
        Dimension screenDim = Toolkit.getDefaultToolkit().getScreenSize();
        Dimension propertyMonitorDim = new Dimension(600, 325);

        agendaMonitor = new PropertyMonitor("Agenda");
        agendaMonitor.setSize(propertyMonitorDim);
        agendaMonitor.setLocation(screenDim.width - agendaMonitor.getWidth(), 0);

        factsMonitor = new PropertyMonitor("Fatti");
        factsMonitor.setSize(propertyMonitorDim);
        factsMonitor.setLocation(screenDim.width - factsMonitor.getWidth(), agendaMonitor.getHeight());
        factsMonitor.setAutoScroll();

        this.model.addObserver((Observer) this);
        agendaMonitor.addWindowListener(new WindowListener() {
            @Override
            public void windowClosing(WindowEvent e) {
                visualizeAgendaButton.setSelected(false);
            }

            @Override
            public void windowOpened(WindowEvent e) {
                visualizeAgendaButton.setSelected(true);
            }

            @Override
            public void windowClosed(WindowEvent e) {
            }

            @Override
            public void windowIconified(WindowEvent e) {
            }

            @Override
            public void windowDeiconified(WindowEvent e) {
            }

            @Override
            public void windowActivated(WindowEvent e) {
            }

            @Override
            public void windowDeactivated(WindowEvent e) {
            }
        });

        factsMonitor.addWindowListener(new WindowListener() {
            @Override
            public void windowClosing(WindowEvent e) {
                visualizeFactsButton.setSelected(false);
            }

            @Override
            public void windowOpened(WindowEvent e) {
                visualizeFactsButton.setSelected(true);
            }

            @Override
            public void windowClosed(WindowEvent e) {
            }

            @Override
            public void windowIconified(WindowEvent e) {
            }

            @Override
            public void windowDeiconified(WindowEvent e) {
            }

            @Override
            public void windowActivated(WindowEvent e) {
            }

            @Override
            public void windowDeactivated(WindowEvent e) {
            }
        });
    }

    /**
     * Questo metodo è chiamato dal costruttore e inizializza il form WARNING:
     * NON modificare assolutamente questo metodo.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        controlPanel = new javax.swing.JPanel();
        loadDefaultFileButton = new javax.swing.JButton();
        loadFileLabel = new javax.swing.JLabel();
        separator = new javax.swing.JSeparator();
        runButton = new javax.swing.JButton();
        stepButton = new javax.swing.JButton();
        runOneButton = new javax.swing.JButton();
        visualizeLabel = new javax.swing.JLabel();
        visualizePunteggiButton = new javax.swing.JCheckBox();
        visualizeAgendaButton = new javax.swing.JCheckBox();
        visualizeFactsButton = new javax.swing.JCheckBox();
        loadCustomFileButton = new javax.swing.JButton();
        resetButton = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setTitle("Pannello di Controllo");
        setMinimumSize(new java.awt.Dimension(375, 100));
        setName("panelFrame"); // NOI18N

        controlPanel.setMinimumSize(new java.awt.Dimension(650, 90));
        controlPanel.setPreferredSize(new java.awt.Dimension(650, 90));
        controlPanel.setRequestFocusEnabled(false);

        loadDefaultFileButton.setText("Default");
        loadDefaultFileButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                loadDefaultFileButtonActionPerformed(evt);
            }
        });

        loadFileLabel.setText("Nessun file caricato");
        loadFileLabel.setEnabled(false);

        separator.setPreferredSize(new java.awt.Dimension(600, 2));

        runButton.setText("Run");
        runButton.setToolTipText("Esegue la Run di Clips");
        runButton.setEnabled(false);
        runButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                runButtonActionPerformed(evt);
            }
        });

        stepButton.setText("Step");
        stepButton.setToolTipText("Esegue Run fino alla prossima azione del Robot");
        stepButton.setEnabled(false);
        stepButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                stepButtonActionPerformed(evt);
            }
        });

        runOneButton.setText("Run(1)");
        runOneButton.setToolTipText("Esegue la Run(1) di Clips");
        runOneButton.setEnabled(false);
        runOneButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                runOneButtonActionPerformed(evt);
            }
        });

        visualizeLabel.setHorizontalAlignment(javax.swing.SwingConstants.RIGHT);
        visualizeLabel.setText("Visualizza:");
        visualizeLabel.setEnabled(false);

        visualizePunteggiButton.setSelected(true);
        visualizePunteggiButton.setText("Punteggi");
        visualizePunteggiButton.setEnabled(false);
        visualizePunteggiButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                visualizePunteggiButtonActionPerformed(evt);
            }
        });

        visualizeAgendaButton.setText("Agenda");
        visualizeAgendaButton.setEnabled(false);
        visualizeAgendaButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                visualizeAgendaButtonActionPerformed(evt);
            }
        });

        visualizeFactsButton.setText("Fatti");
        visualizeFactsButton.setEnabled(false);
        visualizeFactsButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                visualizeFactsButtonActionPerformed(evt);
            }
        });

        loadCustomFileButton.setText("Scegli mappe");
        loadCustomFileButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                loadCustomFileButtonActionPerformed(evt);
            }
        });

        resetButton.setFont(new java.awt.Font("Tahoma", 1, 11)); // NOI18N
        resetButton.setForeground(new java.awt.Color(255, 0, 0));
        resetButton.setText("RESET");
        resetButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                resetButtonActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout controlPanelLayout = new javax.swing.GroupLayout(controlPanel);
        controlPanel.setLayout(controlPanelLayout);
        controlPanelLayout.setHorizontalGroup(
            controlPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(controlPanelLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(controlPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(separator, javax.swing.GroupLayout.DEFAULT_SIZE, 626, Short.MAX_VALUE)
                    .addGroup(controlPanelLayout.createSequentialGroup()
                        .addComponent(loadDefaultFileButton)
                        .addGap(4, 4, 4)
                        .addComponent(loadCustomFileButton)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(loadFileLabel)
                        .addGap(0, 0, Short.MAX_VALUE))
                    .addGroup(controlPanelLayout.createSequentialGroup()
                        .addComponent(resetButton)
                        .addGap(18, 18, 18)
                        .addComponent(runButton)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(runOneButton)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(stepButton)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(visualizeLabel)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(visualizePunteggiButton)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(visualizeAgendaButton)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(visualizeFactsButton)))
                .addContainerGap())
        );
        controlPanelLayout.setVerticalGroup(
            controlPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(controlPanelLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(controlPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(loadDefaultFileButton)
                    .addComponent(loadFileLabel)
                    .addComponent(loadCustomFileButton))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(separator, javax.swing.GroupLayout.DEFAULT_SIZE, 3, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(controlPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(runButton)
                    .addComponent(runOneButton)
                    .addComponent(stepButton)
                    .addComponent(visualizeFactsButton)
                    .addComponent(resetButton)
                    .addComponent(visualizeLabel)
                    .addComponent(visualizePunteggiButton)
                    .addComponent(visualizeAgendaButton))
                .addContainerGap())
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(controlPanel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(controlPanel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void resetButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_resetButtonActionPerformed
        try {
            Runtime runtime = Runtime.getRuntime();
            runtime.exec("java -jar dist/Monitor1213.jar");
            runtime.exit(5386);
        } catch (IOException ex) {
            Logger.getLogger(ControlPanel.class.getName()).log(Level.SEVERE, null, ex);
        }
    }//GEN-LAST:event_resetButtonActionPerformed

    /**
     * azione eseguita quando si preme il bottone per il caricamento dei file
     * clips con le mappe "initial" e "actual"
     *
     * @param evt l'evento scatenante l'azione
     */
    private void loadCustomFileButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_loadCustomFileButtonActionPerformed
        final JFileChooser chooser = new JFileChooser(".");
        chooser.addChoosableFileFilter(new ClpFileFilter());
        int returnval = chooser.showDialog(null, "Carica mappa iniziale");
        int returnval2 = 0;
        String initialPath = "", actualPath = "";
        File file;

        if (returnval == JFileChooser.APPROVE_OPTION) {
            file = chooser.getSelectedFile();
            initialPath = file.getAbsolutePath();

            final JFileChooser chooser2 = new JFileChooser(".");
            chooser2.addChoosableFileFilter(new ClpFileFilter());
            returnval2 = chooser2.showDialog(null, "Carica mappa reale");
            if (returnval2 == JFileChooser.APPROVE_OPTION) {
                file = chooser2.getSelectedFile();
                actualPath = file.getAbsolutePath();
                loadDefaultFileButton.setEnabled(false);
                loadCustomFileButton.setEnabled(false);
                loadFileLabel.setText("Iniziale: " + filename(initialPath) + ", finale: " + filename(actualPath));
                loadFileLabel.setEnabled(true);
                runButton.setEnabled(true);
                stepButton.setEnabled(true);
                runOneButton.setEnabled(true);
                visualizeLabel.setEnabled(true);
                visualizeAgendaButton.setEnabled(true);
                visualizeFactsButton.setEnabled(true);
                visualizePunteggiButton.setEnabled(true);
                model.startCore(initialPath, actualPath);
                model.execute();
            }
        } else if (returnval != JFileChooser.CANCEL_OPTION && returnval != JFileChooser.ABORT && returnval2 != JFileChooser.CANCEL_OPTION && returnval2 != JFileChooser.ABORT) {
            throw new IllegalArgumentException("Incorrect file extension");
        }
    }//GEN-LAST:event_loadCustomFileButtonActionPerformed

    /**
     * azione eseguita quando si preme il checkbox per la visualizzazione dei
     * fatti
     *
     * @param evt l'evento scatenante l'azione
     */
    private void visualizeFactsButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_visualizeFactsButtonActionPerformed
        factsMonitor.setVisible(visualizeFactsButton.isSelected());
    }//GEN-LAST:event_visualizeFactsButtonActionPerformed

    /**
     * azione eseguita quando si preme il checkbox per la visualizzazione
     * dell'agenda
     *
     * @param evt l'evento scatenante l'azione
     */
    private void visualizeAgendaButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_visualizeAgendaButtonActionPerformed
        agendaMonitor.setVisible(visualizeAgendaButton.isSelected());
    }//GEN-LAST:event_visualizeAgendaButtonActionPerformed

    /**
     * azione eseguita quando si preme il tasto Run(1)
     *
     * @param evt l'evento scatenante l'azione
     */
    private void runOneButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_runOneButtonActionPerformed
        model.setMode("RUNONE");
        model.resume();
    }//GEN-LAST:event_runOneButtonActionPerformed

    /**
     * azione eseguita quando si preme il tasto Step
     *
     * @param evt l'evento scatenante l'azione
     */
    private void stepButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_stepButtonActionPerformed
        model.setMode("STEP");
        model.resume();
    }//GEN-LAST:event_stepButtonActionPerformed

    /**
     * azione eseguita quando si preme il tasto Run
     *
     * @param evt l'evento scatenante l'azione
     */
    private void runButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_runButtonActionPerformed
        if (runButton.getText().equals("Run")) {
            model.setMode("RUN");
            model.resume();
            runButton.setText("Stop");
            stepButton.setEnabled(false);
            runOneButton.setEnabled(false);
        } else {
            model.setMode("STEP");
            runButton.setText("Run");
            stepButton.setEnabled(true);
            runOneButton.setEnabled(true);
        }
    }//GEN-LAST:event_runButtonActionPerformed

    /**
     * azione eseguita quando si preme il bottone per il caricamento del file
     * clips di default
     *
     * @param evt l'evento scatenante l'azione
     */
    private void loadDefaultFileButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_loadDefaultFileButtonActionPerformed
        loadDefaultFileButton.setEnabled(false);
        loadCustomFileButton.setEnabled(false);
        loadFileLabel.setText("Default");
        loadFileLabel.setEnabled(true);
        runButton.setEnabled(true);
        stepButton.setEnabled(true);
        runOneButton.setEnabled(true);
        visualizeLabel.setEnabled(true);
        visualizeAgendaButton.setEnabled(true);
        visualizeFactsButton.setEnabled(true);
        visualizePunteggiButton.setEnabled(true);
        model.startCore();
        model.execute();
    }//GEN-LAST:event_loadDefaultFileButtonActionPerformed

    private void visualizePunteggiButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_visualizePunteggiButtonActionPerformed
        // TODO add your handling code here:
        model.showScores = this.visualizePunteggiButton.isSelected();
    }//GEN-LAST:event_visualizePunteggiButtonActionPerformed

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JPanel controlPanel;
    private javax.swing.JButton loadCustomFileButton;
    private javax.swing.JButton loadDefaultFileButton;
    private javax.swing.JLabel loadFileLabel;
    private javax.swing.JButton resetButton;
    private javax.swing.JButton runButton;
    private javax.swing.JButton runOneButton;
    private javax.swing.JSeparator separator;
    private javax.swing.JButton stepButton;
    private javax.swing.JCheckBox visualizeAgendaButton;
    private javax.swing.JCheckBox visualizeFactsButton;
    private javax.swing.JLabel visualizeLabel;
    private javax.swing.JCheckBox visualizePunteggiButton;
    // End of variables declaration//GEN-END:variables

    /**
     * Metodo per ottenere un'istanza del pannello di controllo
     *
     * @return il pannello di controllo racchiuso in un JPanel
     */
    public JPanel getControlPanel() {
        return controlPanel;
    }

    @Override
    public void update(Observable o, Object o1) {
        try {
            if (agendaMonitor.isVisible()) {
                agendaMonitor.setText(model.getAgenda());
            } else {
                visualizeAgendaButton.setSelected(false);
            }
            if (factsMonitor.isVisible()) {
                factsMonitor.setText(model.getFactList());
            } else {
                visualizeFactsButton.setSelected(false);
            }
        } catch (Exception ex) {
            //System.out.println("[ERRORE] " + ex.toString());
            DebugFrame.appendText("[ERRORE] " + ex.toString());
        }
    }

    /**
     * Estrae il nome di un file (con l'estensione) da un initialPath.
     *
     * @param initialPath un initialPath ad un file
     * @return una stringa contenente solo il nome del file
     */
    static private String filename(String path) {
        int i = path.lastIndexOf(File.separator);
        return path.substring(i + 1, path.length());
    }

    private class ClpFileFilter extends FileFilter {

        @Override
        public boolean accept(File f) {
            if (f.isDirectory()) {
                return true;
            }
            String ext = null;
            String s = f.getName();
            int i = s.lastIndexOf('.');

            if (i > 0 && i < s.length() - 1) {
                ext = s.substring(i + 1).toLowerCase();
            }
            if (ext.equalsIgnoreCase("clp")) {
                return true;
            }
            return false;
        }

        @Override
        public String getDescription() {
            return "Clips files";
        }
    }
}
