package view.app;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.Window;
import java.util.ArrayList;

import javax.swing.BorderFactory;
import javax.swing.DefaultListModel;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextField;
import javax.swing.SwingConstants;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;

import model.data.Employe;
import model.data.Projet;
import model.orm.AccessProjet;
import model.orm.exception.DataAccessException;
import model.orm.exception.DatabaseConnexionException;
import model.orm.exception.RowNotFoundOrTooManyRowsException;

public class GestionProjet extends JDialog{
	private Employe employeUtilisateur;
	private AccessProjet ap = new AccessProjet() ;
	
	private DefaultListModel<Projet> model = new DefaultListModel<Projet>();
	
	 private JButton createButton;
	 private JButton voirButton;
	 private JButton modifierButton;
	 private JButton rechercherButton;
	 private JButton retourButton;
	 private JList<Projet> selectionProjet;
	 private JScrollPane scroll;
	 private JTextField researchBar;
	
	public GestionProjet(Window owner, Employe employeU) {
		super(owner);
    	this.employeUtilisateur = employeU;
    	
    	setModal(true);
    	
    	setTitle("Gestion des projets");
        setResizable(true);
        setSize(600,450); 
        setDefaultCloseOperation(JDialog.DO_NOTHING_ON_CLOSE);
        
        JPanel contentPane = new JPanel(new BorderLayout());
        JPanel contentHead = new JPanel(new BorderLayout());
        JPanel contentButtons = new JPanel(new FlowLayout());
        JPanel contentList = new JPanel();
        
        createButton = new JButton("Créer");
        createButton.addActionListener(e -> actionCreer());
        createButton.setBackground(new Color(104, 177, 255)) ;

        voirButton = new JButton("Voir");
        voirButton.addActionListener(e -> actionVoir());
        voirButton.setBackground(new Color(104, 177, 255)) ;
        
        modifierButton = new JButton("Modifier");
        modifierButton.addActionListener(e -> actionModifier());
        modifierButton.setBackground(new Color(104, 177, 255)) ;

        retourButton = new JButton("Retour");
        retourButton.addActionListener(e -> actionRetour());
        retourButton.setBackground(new Color(104, 177, 255)) ;
        
        createButton.setPreferredSize(new Dimension(200,40));
        voirButton.setPreferredSize(new Dimension(200,40));
        modifierButton.setPreferredSize(new Dimension(200,40));
        retourButton.setPreferredSize(new Dimension(200,40));
        
        contentButtons.add(createButton);
        contentButtons.add(voirButton);
        contentButtons.add(modifierButton);
        JLabel espace = new JLabel();
        espace.setPreferredSize(new Dimension(200,20));
        contentButtons.add(espace);
        contentButtons.add(retourButton);
        espace = new JLabel();
        espace.setPreferredSize(new Dimension(200,20));
        contentButtons.add(espace);
        contentButtons.setPreferredSize(new Dimension(250,300));
        contentButtons.setBorder(BorderFactory.createEmptyBorder(30,0,0,0));

        model = new DefaultListModel<>();

        selectionProjet = new JList<>(model);
        selectionProjet.addListSelectionListener(new ListSelectionListener() {
            public void valueChanged(ListSelectionEvent arg0) {
        		verifierEtatComposants();
            }
        });
        scroll = new JScrollPane(selectionProjet);
        scroll.setPreferredSize(new Dimension(270, 270)); 
        scroll.setBorder(BorderFactory.createEmptyBorder(30,0,0,0));
        contentList.add(scroll);
        scroll.setBorder(BorderFactory.createTitledBorder("Liste des employés"));
        contentList.setBorder(BorderFactory.createEmptyBorder(25,30,0,0));

        JLabel titre = new JLabel("Gestion des employés");
        titre.setFont(new Font("Arial",Font.BOLD,22));
        titre.setHorizontalAlignment(SwingConstants.CENTER);
        titre.setBorder(BorderFactory.createEmptyBorder(20,0,20,0));

        rechercherButton = new JButton("Rechercher");
        
        rechercherButton.addActionListener(e -> actionRechercheProjets());


        researchBar = new JTextField("");
        researchBar.getFont().deriveFont(Font.ITALIC);
        researchBar.setForeground(Color.gray);
        researchBar.setPreferredSize(new Dimension(400,24));
        researchBar.addActionListener(e -> actionResearchBar());

        contentHead.add(titre, BorderLayout.NORTH);
        contentHead.add(rechercherButton, BorderLayout.WEST);
        contentHead.add(researchBar, BorderLayout.EAST);
        contentHead.setBorder(BorderFactory.createEmptyBorder(0,35,0,25));

        contentPane.add(contentHead, BorderLayout.NORTH);
        contentPane.add(contentButtons, BorderLayout.EAST);
        contentPane.add(contentList, BorderLayout.WEST);

        add(contentPane);

        this.setLocationRelativeTo(this.getParent());
        
        
        actionRechercheProjets();
        verifierEtatComposants();
        
	}
	
	private void actionRechercheProjets() {
		
		String debutNom = this.researchBar.getText();
		
		ArrayList<Projet> listePro = new ArrayList<>();

		try {
			listePro = ap.getProjets(debutNom);
		} catch (DatabaseConnexionException e) {
			new ExceptionDialog(this, e);
			dispose();
		} catch (DataAccessException e) {
			new ExceptionDialog(this, e);
		} catch (RowNotFoundOrTooManyRowsException e) {
			new ExceptionDialog(this, e);
		}
		
        model.clear() ;
        for (Projet projet : listePro) {
            model.addElement(projet);
        }
	
        if (model.size() > 0) {
        	selectionProjet.ensureIndexIsVisible(0);
        }
        selectionProjet.setSelectedIndex(-1);
		verifierEtatComposants();
		
    }
	
	private void verifierEtatComposants(){
        if (selectionProjet.getSelectedIndex()<0) {
        	voirButton.setEnabled(false);
            modifierButton.setEnabled(false);
        } else {
        	voirButton.setEnabled(true);
            modifierButton.setEnabled(true);
        }
    }
	
	private void actionResearchBar() {
        this.actionRechercheProjets();
	}
	
	private void actionVoir() {
		
		Projet projetEdite = model.get(selectionProjet.getSelectedIndex());
		ProjetEditor.showProjetEditor(this, 
				employeUtilisateur, projetEdite, 
				ProjetEditor.ModeEdition.VISUALISATION);
		
	}
	
	
	private void actionModifier() {
		
		Projet projetEdite = model.get(selectionProjet.getSelectedIndex());
		Projet result ;
		result = ProjetEditor.showProjetEditor(this, 
				employeUtilisateur, projetEdite, 
				ProjetEditor.ModeEdition.MODIFICATION);
		
		if (result != null) { // modif validée
			try {
				ap.updateProjet(result);
			} catch (RowNotFoundOrTooManyRowsException e) {
				new ExceptionDialog(this, e);
			} catch (DataAccessException e) {
				new ExceptionDialog(this, e);
			} catch (DatabaseConnexionException e) {
				new ExceptionDialog(this, e);
				this.dispose();;
			}
			
			actionRechercheProjets ();
		}
		
	}
	
	private void actionCreer() {
		
		Projet result ;
		result = ProjetEditor.showProjetEditor(this, 
				employeUtilisateur, 
				null, 
				ProjetEditor.ModeEdition.CREATION);
		
		if (result != null) { // saisie validée
			try {
				ap.insertProjet(result);
			} catch (RowNotFoundOrTooManyRowsException e) {
				new ExceptionDialog(this, e);
			} catch (DataAccessException e) {
				new ExceptionDialog(this, e);
			} catch (DatabaseConnexionException e) {
				new ExceptionDialog(this, e);
				this.dispose();;
			}
			
			actionRechercheProjets ();
		}
		
	}
	
	private void actionRetour() {
        this.setVisible(false);
	}

}
