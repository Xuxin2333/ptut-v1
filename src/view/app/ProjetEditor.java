package view.app;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.Window;
import java.sql.Date;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;

import model.data.Employe;
import model.data.Projet;
import model.data.Role;
import model.orm.exception.DataAccessException;
import model.orm.exception.DatabaseConnexionException;
import view.app.EmployeEditor.ModeEdition;

@SuppressWarnings("serial")
public class ProjetEditor extends JDialog{
	
	public enum ModeEdition {
		CREATION, MODIFICATION, VISUALISATION
		// pas de suppression car fonctionnellement impossible
	};
	
	private ModeEdition modeActuel;
	
    // Panels
    private JPanel contentPane;
    private JPanel champsPanel ;
    private JPanel boutonsPanel ;

    // Label titre
    private JLabel titreLabel ;

    // Police d'écriture
    private Font titreFont = new Font("Arial", Font.BOLD, 22) ;
    private Font normalFont = new Font("Arial", Font.PLAIN, 16) ;

    // Boutons
    private JButton enregistrerBouton ;
    private JButton annulerBouton ;

    // Dimension
    private Dimension dimensionBouton = new Dimension(140,35) ;
    private Dimension dimensionLabel = new Dimension(200,40) ;
    private Dimension dimensionText = new Dimension(135,25) ;
    
    // Zones de texte titres des saisies
    private JLabel idLabel ;
    private JLabel nomLabel ;
    private JLabel descriptionLabel ;
    private JLabel dateDebutLabel ;
    private JLabel dateFinEstimeeLabel;
    private JLabel dateFinReelleLabel ;
    
 // Zones de saisie
    private JTextField idText ;
    private JTextField nomText ;
    private JTextField descriptionText ;
    private JCheckBox estActifTB;
    
    
 // Employe qui utilise l'application
 	private Employe employueUtilisateur;
 	
 // Projet modifié ou visualisé
 	private Projet projetEdite;
 	
 	// projet resultat
 	private Projet projetResult;
 	
 	public static Projet showProjetEditor(Window owner, Employe employeUtilisateur, Projet projetEdite, ProjetEditor.ModeEdition mode) {
 		
 		if (mode == ProjetEditor.ModeEdition.CREATION) {
			projetEdite = new Projet();
		} else {
			projetEdite = new Projet(projetEdite);
		}
 		
 		ProjetEditor dial = new ProjetEditor(projetEdite, employeUtilisateur, owner, mode);
        dial.projetResult = null;
		dial.setModal(true);
		dial.setVisible(true);
		// le programme appelant est bloqué jusqu'au masquage de la JDialog.
		dial.dispose();
		return dial.projetResult;
 	}
 	
 	private ProjetEditor(Projet pfProjetEdite, Employe pfEmployeUtilisateur, Window owner, ProjetEditor.ModeEdition pfMode) {
 		super(owner);
        this.employueUtilisateur = pfEmployeUtilisateur ;
        this.projetEdite = pfProjetEdite;
        this.projetResult = null;
        this.modeActuel = pfMode;
        
        setTitle("Gestion d'un Projet");
        setSize(400, 620) ;
        setDefaultCloseOperation(JDialog.DO_NOTHING_ON_CLOSE);
        
        
     // Border
        Border blackline = BorderFactory.createLineBorder(Color.black);
        TitledBorder title = BorderFactory.createTitledBorder(
                blackline, "Veuillez remplir tous les champs possibles",
                TitledBorder.CENTER,TitledBorder.DEFAULT_POSITION,
                new Font("Arial", Font.ITALIC, 15) );

        Border raisedbevel = BorderFactory.createRaisedBevelBorder();
        Border loweredbevel = BorderFactory.createLoweredBevelBorder();
        Border compound = BorderFactory.createCompoundBorder(
                raisedbevel, loweredbevel);
        
     // Toute la fenetre
        contentPane = new JPanel(new BorderLayout()) ;
        setContentPane(contentPane);
        
        
     // Titre label
        titreLabel = new JLabel("tempo");
        titreLabel.setHorizontalAlignment(0);
        titreLabel.setPreferredSize(new Dimension(400, 80));
        titreLabel.setFont(titreFont);
        titreLabel.setBorder(compound);

        contentPane.add(titreLabel, BorderLayout.NORTH);

        // Champs Panel
        champsPanel = new JPanel(new FlowLayout()) ;
        contentPane.add(champsPanel,  BorderLayout.CENTER);
        champsPanel.setBorder(title);

        // Boutons Panel
        boutonsPanel = new JPanel(new FlowLayout());
        boutonsPanel.setPreferredSize(new Dimension(150,50));
        contentPane.add(boutonsPanel, BorderLayout.SOUTH);

        // Boutons
        enregistrerBouton = new JButton("Enregister");
        enregistrerBouton.setBackground(new Color(104, 177, 255)) ;
        enregistrerBouton.setPreferredSize(dimensionBouton);
        enregistrerBouton.addActionListener(e -> actionOK());

        boutonsPanel.add(enregistrerBouton);

        annulerBouton = new JButton("Annuler");
        annulerBouton.setBackground(new Color(104, 177, 255)) ;
        annulerBouton.setPreferredSize(dimensionBouton);
        annulerBouton.addActionListener(e -> actionAnnuler());
        annulerBouton.setActionCommand("quitter");

        boutonsPanel.add(annulerBouton,BorderLayout.SOUTH);
        
 	}
 	
 	public static Projet showProjetEditor(Projet pfProjetEdite, Employe pfEmployeUtilisateur, Window owner, ProjetEditor.ModeEdition pfMode) {
		
		if (pfMode == ProjetEditor.ModeEdition.CREATION) {
			pfProjetEdite = new Projet();
		} else {
			pfProjetEdite = new Projet(pfProjetEdite);
		}
		
		ProjetEditor dial = new ProjetEditor(pfProjetEdite, pfEmployeUtilisateur, owner, pfMode);
        dial.projetResult = null;
		dial.setModal(true);
		dial.setVisible(true);
		// le programme appelant est bloqué jusqu'au masquage de la JDialog.
		dial.dispose();
		return dial.projetResult;
	}
 	
 	
 	private void actionOK() {
 		if (verifChamps()){
        	if (modeActuel == ProjetEditor.ModeEdition.CREATION) {
        
        		
        	}
            this.projetResult = generateProjet() ;
            this.setVisible(false);
        }else{
            JOptionPane.showMessageDialog(this, "Veuillez saisir tous les champs", "Erreur", JOptionPane.ERROR_MESSAGE);
        }
 	}
 	
 	private Projet generateProjet(){
        // On génére le role de l'employe
        int roleId ;
        

        int estActifE;
        estActifE = (estActifTB.isSelected() ? Employe.EST_ACTIF : Employe.EST_INACTIF);
        // On récupere tous les elements pour créer l'employé
        Projet emp ;
        
        if (modeActuel == ProjetEditor.ModeEdition.CREATION){
        	//TODO adaper le costructeur de projet
            emp = new Projet( -1 , nomText.getText().trim() , descriptionText.getText().trim(), new Date(0,0,0), new Date(0,0,0), new Date(0,0,0), 0) ;
        }else {
            emp = new Projet( Integer.parseInt(idText.getText()) , nomText.getText() , descriptionText.getText() , new Date(0,0,0), new Date(0,0,0), new Date(0,0,0), 0) ;
        }
		
        return emp ;
    }
 	
 	
 	private boolean verifChamps() {
        if (nomText.getText().trim().isEmpty() || descriptionText.getText().trim().isEmpty()) {
            return false;
        }
        return true;
    }
 	
 	
 	private void actionAnnuler() {
    	this.projetResult = null;
        this.setVisible(false);

    }

}
