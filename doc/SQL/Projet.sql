--------------------création table Projet-------------


drop TABLE Projet;

create table Projet(

    idProjet number(3),
    nom varchar(100),
    descriptionP varchar(1000),
    dateDebut date, 
    dateFinEstimee date,
    dateFinReelle date,  
    estActif number(1) DEFAULT 1, --par défaut actif

    CONSTRAINT PK_idClient PRIMARY KEY (idProjet),
    CONSTRAINT CHK_estActif_projet CHECK (estActif IN (1,2)),
    CONSTRAINT CHK_dateDebut_fin CHECK (dateDebut < dateFinEstimee and dateDebut < dateFinReelle)
);

-----------------séquence pour id Projet----------------
drop sequence sequence_Projet;

create SEQUENCE sequence_Projet
    MINVALUE 1
    MAXVALUE 999
    START WITH 1
    increment by 1;

-------------------procédure créer Projet-----------------



CREATE OR REPLACE PROCEDURE CreerProjet
(
    vNom Projet.nom%TYPE,
    vDescription Projet.descriptionP%TYPE,
    vDateDebut Projet.dateDebut%TYPE,
    vDateFinEstimee Projet.dateFinEstimee%TYPE
)
IS



BEGIN
    -- Insertion nouveau projet 
    INSERT INTO Projet (idProjet, nom, descriptionP, dateDebut, dateFinEstimee, estActif) 
	VALUES (sequence_Projet.NEXTVAL, vNom,vDescription, vDateDebut, vDateFinEstimee,  1 );
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

----------------------- procedure afficher projet----------------

CREATE OR REPLACE PROCEDURE AfficherProjet
(
    vId Projet.idProjet%TYPE
)
IS
    vNom Projet.nom%TYPE;
    vDescription Projet.descriptionP%TYPE;
    vDateDebut Projet.dateDebut%TYPE;
    vDateFinEstimee Projet.dateFinEstimee%TYPE;
    vDateFinReelle Projet.dateFinReelle%TYPE;
    vActif Projet.estActif%TYPE;

BEGIN

    select nom, descriptionP, dateDebut, dateFinEstimee, dateFinReelle, estActif  into vNom,vDescription ,vDateDebut ,vDateFinEstimee ,vDateFinReelle ,vActif
    from Projet
    where Projet.idProjet = vId;

	DBMS_OUTPUT.PUT_LINE('nom :'||vNom);
    DBMS_OUTPUT.PUT_LINE('Date de début de projet :'||vDateDebut);
    DBMS_OUTPUT.PUT_LINE(vDescription);
    IF vActif = 1 THEN
    DBMS_OUTPUT.PUT_LINE('Le project est en cours');
    DBMS_OUTPUT.PUT_LINE('Date de fin estimée :'||vDateFinEstimee);
    ELSE
    DBMS_OUTPUT.PUT_LINE('Le project est fini');
    DBMS_OUTPUT.PUT_LINE('Date de fin :'||vDateFinReelle);
    END IF;
	-- Valider (fin de transaction)
	COMMIT;
END;
/




--------------------------Procedure modifier champs projet----------------------

CREATE OR REPLACE PROCEDURE modifierProjet
(
    vId Projet.idProjet%TYPE,
    vNom Projet.nom%TYPE,
    vDescription Projet.descriptionP%TYPE,
    vDateDebut Projet.dateDebut%TYPE,
    vDateFinEstimee Projet.dateFinEstimee%TYPE,
    vDateFinReelle Projet.dateFinReelle%TYPE
)
IS

BEGIN

    -- modification du projet 

    UPDATE Projet 
    SET nom = vNom,
     descriptionP = vDescription, 
     dateDebut = vDateDebut, 
     dateFinEstimee = vDateFinEstimee,
     dateFinReelle = vDateFinReelle
	where idProjet = vId;

	DBMS_OUTPUT.PUT_LINE('Projet '||vNom || ' modifié.');

	-- Valider (fin de transaction)

	COMMIT;
END;
/

------------------------droit pour les procedures(NE MARCHE PAS)--------------------------------
grant execute on CreerProjet TO (select login from Employe where idRole = 1);

grant execute on AfficherProjet TO (select login from Employe where idRole = 1);
