package xclipsjni;

import javax.swing.text.DefaultCaret;

/**Questa classe implementa una finestrella di piccole dimensioni contenente una TextArea nella quale si può inserire del testo.
 * È usata all'interno del pannello di controllo per le finestre di Agenda e Fatti,
 * ma alla necessità può essere usata anche per altro.
 *
 * @author Piovesan Luca, Verdoja Francesco
 * Edited by: @author  Violanti Luca, Varesano Marco, Busso Marco, Cotrino Roberto
 */
public class PropertyMonitor extends javax.swing.JFrame {

	/**Crea un nuovo monitor senza titolo
	 * 
	 */
	public PropertyMonitor() {
		initComponents();
	}

	/** Crea un nuovo monitor con il titolo indicato
	 * 
	 * @param title il titolo che si vuole dare al monitor
	 */
	public PropertyMonitor(String title) {
		initComponents();
		setTitle(title);
	}

	/** Questo metodo è chiamato dal costruttore e inizializza il form
	 * WARNING: NON modificare assolutamente questo metodo.
	 */
	@SuppressWarnings("unchecked")
   // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
   private void initComponents() {

      scrollPane = new javax.swing.JScrollPane();
      textArea = new javax.swing.JTextArea();

      setTitle("Property Monitor");
      setMinimumSize(new java.awt.Dimension(200, 200));

      textArea.setColumns(20);
      textArea.setEditable(false);
      textArea.setRows(5);
      textArea.setTabSize(3);
      scrollPane.setViewportView(textArea);

      javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
      getContentPane().setLayout(layout);
      layout.setHorizontalGroup(
         layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
         .addComponent(scrollPane, javax.swing.GroupLayout.DEFAULT_SIZE, 325, Short.MAX_VALUE)
      );
      layout.setVerticalGroup(
         layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
         .addComponent(scrollPane, javax.swing.GroupLayout.DEFAULT_SIZE, 325, Short.MAX_VALUE)
      );

      pack();
   }// </editor-fold>//GEN-END:initComponents

	/**Metodo per ottenere il testo contenuto nel monitor
	 * 
	 * @return il testo all'interno del monitor
	 */
	String getText() {
		return textArea.getText();
	}

	/**Metodo per impostare un testo nel monitor. Sovrascrive il testo attuale.
	 * Per aggiungere del testo vedere il metodo appendText(String).
	 * 
	 * @param text il testo da impostare nel monitor
	 */
	void setText(String text) {
		textArea.setText(text);
	}

	/**Metodo per aggiungere del testo al monitor.
	 * Per sostituire l'intero testo del monitor usare il metodo setText(String).
	 * 
	 * @param text il testo da appendere al fondo del testo del monitor
	 */
	void appendText(String text) {
		textArea.append(text);
	}
        
        void setAutoScroll() {
            DefaultCaret caret = (DefaultCaret)this.textArea.getCaret();
            caret.setUpdatePolicy(DefaultCaret.ALWAYS_UPDATE);
        }
   // Variables declaration - do not modify//GEN-BEGIN:variables
   private javax.swing.JScrollPane scrollPane;
   private javax.swing.JTextArea textArea;
   // End of variables declaration//GEN-END:variables
}
