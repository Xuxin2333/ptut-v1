package model.data;


/**
 * Classe Client, qui décrit un client du projet
 */

public class Client {
	
    public static final int ID_CLIENT_INEXISTANT = -1000;
	
	public static final int EST_ACTIF = 1;
	public static final int EST_INACTIF = 0;
	
	private int idClient;
    private String nom;
    private String prenom;
    private String entreprise;
    private String email;
    private String telephone;
    private int estActif;
    
    /**
     * Constructeur par default
     */
    public Client(){
        this(Client.ID_CLIENT_INEXISTANT, null, null, null,null, null,Client.EST_INACTIF);
    }
    
    
    /**
     * Constructeur avec parametre
     * @param idC id du client
     * @param nomC nom du client
     * @param prenomC prénom du client
     * @param entrepriseC l'entreprise du client
     * @param emailC email du client
     * @param telephoneC telephone du client
     * @param estActifC actif (1) ou pas (0) 
     *
     */
    public Client(int idC, String nomC,String prenomC,String entrepriseC,String emailC,String telephoneC,int estActifC){
    	this.idClient = idC;
    	this.nom = nomC;
    	this.prenom = prenomC;
    	this.entreprise=entrepriseC;
    	this.email=emailC;
    	this.telephone=telephoneC;
    	this.estActif = estActifC;
    }
    
    /*GETTER SETTER*/

    public int getId() {
        return this.idClient;
    }

    public String getNom() {
        return this.nom;
    }

    public String getPrenom() {
        return this.prenom;
    }
    
    public String getEntreprise() {
    	return this.entreprise;
    }
    
    public String getEmail() {
    	return this.email;
    }
    
    public String getTelephone() {
    	return this.telephone;
    }
    
    
    public int getEstActif() {
		return this.estActif;
	}
    
    
    
}

