package com.v2.airtel;

import java.awt.Color;
import java.awt.Container;
import java.awt.FlowLayout;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.IOException;

import javax.swing.JEditorPane;
import javax.swing.JFileChooser;
import javax.swing.JFormattedTextField;
import javax.swing.JFrame;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JPasswordField;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.JTextPane;
import javax.swing.border.TitledBorder;
import javax.swing.text.MaskFormatter;
import javax.swing.text.SimpleAttributeSet;
import javax.swing.text.StyleConstants;
import javax.swing.text.StyledDocument;


import org.apache.commons.io.FileUtils;

public class TextComponentSampler extends JFrame {

  public static String word = "portmeiron";

  public static String markup = "Questions are <font size=\"+1\" color=\"blue\">a burden</font> to others,\n"
      + "answers <font size=\"+2\" color=\"red\">a prison</font> for oneself.";

  String tableText = "";
  
  JEditorPane ta2 ;
  
  JScrollPane scroll2;
  
  String fileToBeCompiled = "";
  
  //error
  JEditorPane ep1;
  
  //output;
  JEditorPane ep2;
  
  private void init() throws IOException{
	  tableText = FileUtils.readFileToString(new File("table.html"));
	  
  }
  
  public TextComponentSampler() throws IOException {
    super("TextComponentSampler");
    init();
    JTextField tf = new JTextField(word, 12);
    JPasswordField pf = new JPasswordField(word, 12);

    MaskFormatter formatter = null;
    try {
      formatter = new MaskFormatter("UUUUU");
    } catch (java.text.ParseException ex) {
    }
    JFormattedTextField ftf = new JFormattedTextField(formatter);
    ftf.setColumns(12);
    ftf.setValue(word);

    JTextArea ta1 = new JTextArea(markup);
    JScrollPane scroll1 = new JScrollPane(ta1);

    ta2 = new JEditorPane("text/html", tableText);
    //ta2.setLineWrap(true);
    //ta2.setWrapStyleWord(true);
    scroll2 = new JScrollPane(ta2);

    JTextPane tp = new JTextPane();
    tp.setText(markup);
    // Create an AttributeSet with which to change color and font.
    SimpleAttributeSet attrs = new SimpleAttributeSet();
    StyleConstants.setForeground(attrs, Color.blue);
    StyleConstants.setFontFamily(attrs, "Serif");
    // Apply the AttributeSet to a few blocks of text.
    StyledDocument sdoc = tp.getStyledDocument();
    sdoc.setCharacterAttributes(14, 29, attrs, false);
    sdoc.setCharacterAttributes(51, 7, attrs, false);
    sdoc.setCharacterAttributes(78, 28, attrs, false);
    sdoc.setCharacterAttributes(114, 7, attrs, false);
    JScrollPane scroll3 = new JScrollPane(tp);

    ep1 = new JEditorPane("text/plain", markup);
    JScrollPane scroll4 = new JScrollPane(ep1);

    ep2 = new JEditorPane("text/html", markup);
    JScrollPane scroll5 = new JScrollPane(ep2);

    // Done creating text components; now lay them out and make them pretty.
    JPanel panel_tf = new JPanel();
    JPanel panel_pf = new JPanel();
    JPanel panel_ftf = new JPanel();
    panel_tf.add(tf);
    panel_pf.add(pf);
    panel_ftf.add(ftf);

    panel_tf.setBorder(new TitledBorder("JTextField"));
    panel_pf.setBorder(new TitledBorder("JPasswordField"));
    panel_ftf.setBorder(new TitledBorder("JFormattedTextField"));
    scroll1.setBorder(new TitledBorder("JTextArea (line wrap off)"));
    scroll2.setBorder(new TitledBorder("New File"));
    scroll3.setBorder(new TitledBorder("JTextPane"));
    scroll4.setBorder(new TitledBorder("Compiler Error Area"));
    scroll5.setBorder(new TitledBorder("Compiler Output Area"));

    JPanel pan = new JPanel(new FlowLayout(FlowLayout.LEFT));
    pan.add(panel_tf);
    pan.add(panel_pf);
    pan.add(panel_ftf);

    Container contentPane = getContentPane();
   // contentPane.setLayout(new GridLayout(2, 1, 8, 8));
    GridBagLayout gridBagLayout = new GridBagLayout();
    contentPane.setLayout(gridBagLayout);
    GridBagConstraints gBC = new GridBagConstraints();
    gBC.gridx = 0;
    gBC.gridy = 0;
    gBC.weightx = 1.0;
    gBC.weighty = 1.0;
    gBC.fill = GridBagConstraints.BOTH;
    contentPane.add(scroll2, gBC);
    
    
   
    gBC.gridx = 0;
    gBC.gridy = 2;
    gBC.weightx = 1.0;
    gBC.weighty = 0.5;
    gBC.fill = GridBagConstraints.BOTH;
   
    
    JPanel panel = new JPanel(new GridLayout(1, 2));
    
    panel.add(scroll5);
    panel.add(scroll4);
    contentPane.add(panel, gBC);
   
    setMenuBar();
  }
  
  private void setMenuBar(){
	  JMenuBar menuBar = new JMenuBar();
	  
		super.setJMenuBar(menuBar);
		
		JMenu mnFile = new JMenu("File");
		menuBar.add(mnFile);
		
		JMenuItem mntmNew = new JMenuItem("New");
		mntmNew.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				// TODO Auto-generated method stub
				ta2.setText("");
			}
		});
		mnFile.add(mntmNew);
		
		JMenuItem mntmOpen = new JMenuItem("Open");
		mnFile.add(mntmOpen);
		mntmOpen.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				// TODO Auto-generated method stub
				JFileChooser fileChooser = new JFileChooser();
				fileChooser.setCurrentDirectory(new File(System.getProperty("user.home")));
				int result = fileChooser.showOpenDialog(new JPanel());
				if (result == JFileChooser.APPROVE_OPTION) {
				    File selectedFile = fileChooser.getSelectedFile();
				    System.out.println(selectedFile.getName());
				    if(!selectedFile.getName().endsWith("asm")){
				    	JOptionPane.showMessageDialog(null,"Please select .asm file only");
				    }else{
				    	try {
							String data = FileUtils.readFileToString(selectedFile);
							ta2.setContentType("text/plain");
							scroll2.setBorder(new TitledBorder(selectedFile.getName()));
							//ta2.setName(selectedFile.getName());
							ta2.setText(data);
							File writeTmpFile = new File("temp"+File.separator+selectedFile.getName());
							FileUtils.write(writeTmpFile, data);
							fileToBeCompiled = selectedFile.getName();
						} catch (IOException e1) {
							// TODO Auto-generated catch block
							JOptionPane.showMessageDialog(null,"Problem opening the file");
						}
				    }
				}
			}
		});
		
		JMenuItem mntmClose = new JMenuItem("Close");
		mnFile.add(mntmClose);
		
		JMenuItem mntmCloseAll = new JMenuItem("Close All");
		mnFile.add(mntmCloseAll);
		
		JMenuItem mntmExit = new JMenuItem("Exit");
		mnFile.add(mntmExit);
		
		JMenu mnTools = new JMenu("Tools");
		menuBar.add(mnTools);
		
		JMenuItem mntmConfigureComnpiler = new JMenuItem("Configure Comnpiler");
		mnTools.add(mntmConfigureComnpiler);
		
		JMenuItem mntmCompile = new JMenuItem("Compile");
		mnTools.add(mntmCompile);
		mntmCompile.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				// TODO Auto-generated method stub
				if(fileToBeCompiled == null || fileToBeCompiled == "" ){
					JOptionPane.showMessageDialog(null,"Nothing to compile");
				}else{
					//File readTmpFile = new File("temp"+File.pathSeparator+fileToBeCompiled);
					String fileName = "temp"+File.separator+fileToBeCompiled;
					String output[] = RunProgram.runFile(fileName);
						if(output.length > 0){
							if(output[0].startsWith("Error")){
								ep1.setText(output[0].substring("Error ".length(), output[0].length()));
							}
							else{
								String op = "";
								for(String out : output){
									op += out +"\n";
								}
								ep2.setText(op);
							}
						}
				}
				
			}
		});
		
		JMenu mnHelp = new JMenu("Help");
		menuBar.add(mnHelp);
		
		JMenuItem mntmAboutUs = new JMenuItem("About Us");
		mnHelp.add(mntmAboutUs);
  }

  public static void main(String args[]) throws IOException {
    JFrame frame = new TextComponentSampler();
    frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    frame.setSize(600, 450);
    frame.setVisible(true);
  }
}