package model.orm;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import model.data.Projet;
import model.orm.exception.DataAccessException;
import model.orm.exception.DatabaseConnexionException;
import model.orm.exception.Order;
import model.orm.exception.RowNotFoundOrTooManyRowsException;
import model.orm.exception.Table;

public class AccessProjet {
	public static final int LOGIN_TROUVE = 1;
	public static final int LOGIN_TROUVE_INACTIF = 2;
	public static final int LOGIN_INEXISTANT_OU_PLUSIEURS = 0;
	
	public AccessProjet() {
	}
	
	
	
	public ArrayList<Projet> getProjets(String nom) throws DataAccessException, DatabaseConnexionException, RowNotFoundOrTooManyRowsException {
        // Initialisation
        ArrayList<Projet> alProjet = new ArrayList<>();

        try {
            // Connexion a la base de données
            Connection con = LogToDatabase.getConnexion();
            
            nom = "%"+nom.toUpperCase()+"%";

            // Requete
            String query = "Select e.* "
            		+ " FROM Projet e "
            		+ " WHERE (upper(e.nom) like ?)"
            		+ " ORDER BY e.nom";

            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, nom);
            pst.setString(2, nom);

            System.err.println(query);
            
            // Exécution de la requete
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                // On crée l'employe

            	Projet pro = new Projet(rs.getInt("id"), rs.getString("nom"), rs.getString("description"), rs.getDate("dateDebut"), rs.getDate("dateFinEstimmee"), rs.getDate("dateFinReelle"), rs.getInt("estActif"));
                // puis on recupere aussi ses competences et on les ajoute
                // On ajoute l'employe a l'arrayList
                alProjet.add(pro) ;
            }

            // on ferme la requete
            rs.close();
            pst.close();
            return alProjet;

        } catch (SQLException e) {
        	throw new DataAccessException(Table.Projet, Order.SELECT, "Erreur accés", e);
        }
    }
	
	
	public void insertProjet(Projet pfProjet) throws RowNotFoundOrTooManyRowsException, DataAccessException, DatabaseConnexionException {
        try {
            Connection con = LogToDatabase.getConnexion();

            String query = "INSERT INTO PROJET VALUES ("
                    + "seq_id_employe.NEXTVAL"
                    + ", " + "?"
                    + ", " + "?"
                    + ", " + "?"
                    + ", " + "?"
                    + ", " + "?"
                    +")";

            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, pfProjet.getNom());
            pst.setString(2, pfProjet.getDescription());
            pst.setDate(3, pfProjet.getDateDebut());
            pst.setDate(4, pfProjet.getDateFinEstimee());
            pst.setDate (5, pfProjet.getDateFinReelle());
            pst.setInt(6, pfProjet.getEstActif());

            System.err.println(query);

            int result = pst.executeUpdate();
            pst.close();

            if (result != 1) {
                con.rollback();
                throw new RowNotFoundOrTooManyRowsException(Table.Projet, Order.INSERT, "Insert anormal (insert de moins ou plus d'une ligne)", null, result);
            }
            con.commit();

        } catch (SQLException e) {
        	throw new DataAccessException(Table.Projet, Order.INSERT, "Erreur accés", e);
        }

    }
	
	public void updateProjet(Projet pfProjet) throws DataAccessException, DatabaseConnexionException, RowNotFoundOrTooManyRowsException{
        try {
            Connection con = LogToDatabase.getConnexion();

            String query = "UPDATE EMPLOYE SET "
                    + "NOM = " + "?" + " , "
                    + "DESCRIPTION = " + "?" + " , "
                    + "DATEDEBUT = " + "?" + " , "
                    + "DATEFINESTIMEE = " + "?"  + " , "
                    + "DATEFINREELLE = " + "?"  + " , "
                    + "ESTACTIF = "  + "?" + " , "
                    + " " + "WHERE IDEMPLOYE = ? ";

            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, pfProjet.getNom());
            pst.setString(2, pfProjet.getDescription()) ;
            pst.setDate(3, pfProjet.getDateDebut());
            pst.setDate(4, pfProjet.getDateFinEstimee());
            pst.setDate(5, pfProjet.getDateFinReelle());
            pst.setInt (6, pfProjet.getEstActif());

            pst.setInt (7, pfProjet.getID());

            System.err.println(query);

            int result = pst.executeUpdate();
            pst.close();

            if (result != 1) {
                con.rollback();
                throw new  RowNotFoundOrTooManyRowsException(Table.Projet, Order.UPDATE, "Update anormal (update de moins ou plus d'une ligne)", null, result);
            }
            con.commit();

        } catch (SQLException e) {
        	throw new DataAccessException(Table.Projet, Order.UPDATE, "Erreur accés", e);
        }


    }

}
