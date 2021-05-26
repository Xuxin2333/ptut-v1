--------------------création table Projet-------------

create table Projet(

    idProjet number(3),
    nom varchar(100),
    description varchar(1000);
    dateDebut date, 
    dateFinEstimee date,
    dateFinReelle date,  
    estActif number(1) DEFAULT 1; --par défaut actif

    CONSTRAINT PK_idClient PRIMARY KEY (idClient),
    CONSTRAINT CHK_estActif CHECK (estActif IN (0,1)),
    CONSTRAINT UC_idClient UNIQUE (idProjet),
    CONSTRAINT CHK_dateDebut_fin CHECK (dateDebut < dateFinEstimee and dateDebut < dateFinReelle)
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
    vNom Projet.nom%TYPE,
    vDateDebut Projet.dateDebut%TYPE,
    vDateFinEstimee Projet.dateFinEstimee%TYPE,
    vIdClientCommande Projet.idClientCommande%TYPE
)
IS



BEGIN
    -- Insertion nouveau projet 
    INSERT INTO Projet (idProjet, nom, dateDebut, dateFinEstimee, estActif, idClientCommande) 
	VALUES (sequence_Projet.NEXTVAL, vNom, vDateDebut, vDateFinEstimee, 1 , vIdClientCommande);
	DBMS_OUTPUT.PUT_LINE('Projet '||vNom || ' ajouté.');
	-- Valider (fin de transaction)
	COMMIT;

EXCEPTION

	WHEN OTHERS THEN
		ROLLBACK;
		DBMS_OUTPUT.PUT_LINE (SQLERRM);
		RAISE_APPLICATION_ERROR (-20010, 'ERREUR IMPREVUE !');

END;
/

------------------------DROIT POUR LA PROCEDURE--------------------------------

grant execute on CreerProjet TO (select nom from Employe where idRole = 1);
