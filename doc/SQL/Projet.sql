--------------------création table Projet-------------

create table Projet(

    idProjet number(3),
    intitule varchar(100),
    dateDebut date, 
    dateFinEstimee date, 
    estActif number(1) DEFAULT 1; --par défaut actif
    idClientCommande number (5); 

    CONSTRAINT PK_idClient PRIMARY KEY (idClient),
    CONSTRAINT FK_idClientCommande_idClient FOREIGN KEY (idClientCommande) REFERENCES Client(idClient),
    CONSTRAINT CHK_estActif CHECK (estActif IN (0,1)),
    CONSTRAINT UC_idClient UNIQUE (idProjet)
);

-----------------séquence pour id Projet----------------

create SEQUENCE sequence_Projet
    MINVALUE 1
    MAXVALUE 999
    START WITH 1
    INCREMENT BY value
    CACHE value;

-------------------procédure créer Projet-----------------



CREATE OR REPLACE PROCEDURE CreerProjet
(
    vIntitule Projet.intitule%TYPE,
    vDateDebut Projet.dateDebut%TYPE,
    vDateFinEstimee Projet.dateFinEstimee%TYPE,
    vIdClientCommande Projet.idClientCommande%TYPE
)
IS
    erreur_idClient exception
    ----------traiter erreur idClient--------------
    PRAGMA EXCEPTION_INIT()

BEGIN
    -- Insertion nouveau projet 
    INSERT INTO Projet (idProjet, intitule, dateDebut, dateFinEstimee, estActif, idClientCommande) 
	VALUES (sequence_Projet.NEXTVAL, vNom, vDateDebut, vDateFinEstimee, 1 , vIdClientCommande);
	DBMS_OUTPUT.PUT_LINE('Client '||vNom || ||vPrenom|| ' ajouté.');
	-- Valider (fin de transaction)
	COMMIT;

EXCEPTION

     WHEN erreur_idClient THEN
		ROLLBACK;
		RAISE_APPLICATION_ERROR (-20010,'ID Client introuvable');
	WHEN OTHERS THEN
		ROLLBACK;
		DBMS_OUTPUT.PUT_LINE (SQLERRM);
		RAISE_APPLICATION_ERROR (-20010, 'ERREUR IMPREVUE !');

END;
/

------------------------DROIT POUR LA PROCEDURE--------------------------------

grant execute on CreerProjet TO (select nom from Employe where idRole = 1);
