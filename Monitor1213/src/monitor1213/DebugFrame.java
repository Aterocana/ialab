package monitor1213;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.Toolkit;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JRootPane;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;

/**
 * @author Violanti Luca, Varesano Marco, Busso Marco, Cotrino Roberto
 * 
 * Inspired by:
 * @author Minetti Alberto
 */

public class DebugFrame extends JFrame {

        private static final long serialVersionUID = -4026165797297769412L;
        private static DebugFrame df;
        private JPanel jContentPane = null;
        private JTextArea jTextArea = null;
        private JScrollPane jScrollPane = null;

        private DebugFrame() {
                initialize();
        }        
        private void initialize() {
                this.setDefaultCloseOperation(DO_NOTHING_ON_CLOSE);
                this.setSize(600, 200);
                Dimension dim = Toolkit.getDefaultToolkit().getScreenSize();
                this.setLocation(dim.width - this.getWidth(), dim.height - this.getHeight() - 40);
                this.setContentPane(getJContentPane());
                this.setTitle("Debug Frame");
                this.setUndecorated(true);
                this.getRootPane().setWindowDecorationStyle(JRootPane.ERROR_DIALOG);
                this.addWindowListener(new WindowAdapter() {
                        @Override
                        public void windowClosing(WindowEvent arg0) {
                                //System.exit(32);
                        }
                });
                this.repaint();
                //this.setVisible(true);
                this.setVisible(false);
        }

        private JPanel getJContentPane() {
                if (jContentPane == null) {
                        jContentPane = new JPanel();
                        jContentPane.setLayout(new BorderLayout());
                        jContentPane.add(getJScrollPane(), BorderLayout.CENTER); // Generated
                }
                return jContentPane;
        }
                
        private JTextArea getjTextArea() {
                if (jTextArea == null) {
                        jTextArea = new JTextArea();
                        jTextArea.setAutoscrolls(false);
                }
                return jTextArea;
        }

        public static DebugFrame getDebugFrame() {
            if (df == null) df = new DebugFrame();
            return df;
        }


        public static void appendText(String s) {
             getDebugFrame().getjTextArea().append(s + "\n");             
        }

        private JScrollPane getJScrollPane() {
                if (jScrollPane == null) {
                        jScrollPane = new JScrollPane();
                        jScrollPane.setViewportView(getjTextArea()); // Generated

                }
                return jScrollPane;
        }

}

