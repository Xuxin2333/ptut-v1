package model.data;

import java.sql.Date;

public class Projet {
	public static final int ID_PROJET_INEXISTANT = -1000;
	
	public static final int EST_ACTIF = 1;
	public static final int EST_INACTIF = 0;
	
	private int id;
	private String nom;
	private String description;
	private Date dateDebut;
	private Date dateFinEstimee;
	private Date dateFinReelle;
	private int estActif ;

	public Projet(){
	    this(Employe.ID_EMPLOYE_INEXISTANT, null, null, null,null, null, EST_INACTIF);
	}
	
	public Projet(int idP, String nomP, String descriptionP, Date dateDebutP, Date dateFinEstimeeP, Date dateFinReelleP, int estActifP) {
		this.id = idP;
		this.nom = nomP;
		this.description = descriptionP;
		this.dateDebut = dateDebutP;
		this.dateFinEstimee = dateFinEstimeeP;
		this.dateFinReelle = dateFinReelleP;
		this.estActif = estActifP;
	}
	
	public Projet(Projet p) {
		this.id = p.id;
		this.nom = p.nom;
		this.description = p.description;
		this.dateDebut = p.dateDebut;
		this.dateFinEstimee = p.dateFinEstimee;
		this.dateFinReelle = p.dateFinReelle;
		this.estActif = p.estActif;
	}
	
	public void recopierProjet(Projet p) {
		this.id = p.id;
		this.nom = p.nom;
		this.description = p.description;
		this.dateDebut = p.dateDebut;
		this.dateFinEstimee = p.dateFinEstimee;
		this.dateFinReelle = p.dateFinReelle;
		this.estActif = p.estActif;
	}
	
	/*
	 * Getteurs
	 */
	
	public int getID() {
		return this.id;
	}
	
	public String getNom() {
		return this.nom;
	}
	
	public String getDescription() {
		return this.description;
	}
	 
	public Date getDateDebut() {
		return this.dateDebut;
	}
	
	public Date getDateFinEstimee() {
		return this.dateFinEstimee;
	}
	
	public Date getDateFinReelle() {
		return this.dateFinReelle;
	}
	
	public int getEstActif() {
		return this.estActif;
	}
	
	@Override
    public String toString() {
    	String libelleActif = (estActif == Employe.EST_ACTIF ? "Actif" : "Inactif") ;
        return "[" +
                "id=" + id + "]" +
                "  " + nom + 
                "  " + description + 
                "  " + dateDebut +
                "  " + dateFinEstimee +
                "  " + dateFinReelle +
                "  " + libelleActif;
    }
}
