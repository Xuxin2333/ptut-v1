
-------------------procédure créer Projet-----------------



CREATE OR REPLACE PROCEDURE CreerProjet
(
    vNom Projet.nom%TYPE,
    vDescription Projet.descriptionP%TYPE,
    vDateDebut Projet.dateDebut%TYPE,
    vDateFinEstimee Projet.dateFinEstimee%TYPE,
    vIdNumClient Projet.idNumCli%TYPE
)
IS

	erreur_IdNumClient EXCEPTION;
    PRAGMA EXCEPTION_INIT (erreur_IdNumClient, -2291);
	n NUMBER;
    erreur_date EXCEPTION;
    PRAGMA EXCEPTION_INIT (erreur_date, -2290);
    

BEGIN

	SELECT count(*) INTO n
	FROM Client
	WHERE idNumCli=vIdNumClient;
	
	IF (n=0) THEN
		RAISE erreur_IdNumClient;
	END IF;

    IF vDateDebut > vDateFinEstimee THEN
        raise erreur_date;
    END IF;

    -- Insertion nouveau projet 
    INSERT INTO Projet (idProjet, nom, descriptionP, dateDebut, dateFinEstimee, estActif, idNumCli) 
	VALUES (sequence_Projet.NEXTVAL, vNom,vDescription, vDateDebut, vDateFinEstimee,  1 , vIdNumClient);
	DBMS_OUTPUT.PUT_LINE('Projet '||vNom || ' ajouté.');
	-- Valider (fin de transaction)
	COMMIT;

EXCEPTION

    WHEN erreur_date THEN 
        ROLLBACK;
        RAISE_APPLICATION_ERROR (-20001, 'date de fin plus tot que date début');
	WHEN erreur_IdNumClient THEN
		ROLLBACK;
        RAISE_APPLICATION_ERROR (-20002, 'ID Client introuvable');
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
    vIdNumClient Projet.idNumCli%TYPE;

	erreur_ID EXCEPTION;
    PRAGMA EXCEPTION_INIT (erreur_ID, -2292);
	n NUMBER;
    

BEGIN

	SELECT count(*) INTO n
	FROM Projet
	WHERE idProjet=vId;
	
	IF (n=0) THEN
		RAISE erreur_ID;
	END IF;

    select nom, descriptionP, dateDebut, dateFinEstimee, dateFinReelle, estActif, idNumCli  into vNom,vDescription ,vDateDebut ,vDateFinEstimee ,vDateFinReelle ,vActif, vIdNumClient
    from Projet
    where Projet.idProjet = vId;

	DBMS_OUTPUT.PUT_LINE('nom :'||vNom);
    DBMS_OUTPUT.PUT_LINE('Projet commandé par le client ID :'||vIdNumClient);
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

EXCEPTION
	
	WHEN erreur_ID THEN
		ROLLBACK;
        RAISE_APPLICATION_ERROR (-20001, 'ID inconnu');
	WHEN OTHERS THEN
		ROLLBACK;
		DBMS_OUTPUT.PUT_LINE (SQLERRM);
		RAISE_APPLICATION_ERROR (-20000, 'ERREUR IMPREVUE !');

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
    vDateFinReelle Projet.dateFinReelle%TYPE,
    vIdNumClient Projet.idNumCli%TYPE
)
IS
	erreur_ID EXCEPTION;
    PRAGMA EXCEPTION_INIT (erreur_ID, -2292);
	n NUMBER;
    erreur_IdNumClient EXCEPTION;
    PRAGMA EXCEPTION_INIT (erreur_IdNumClient, -2291);
    m number;
    
    erreur_date EXCEPTION;
    PRAGMA EXCEPTION_INIT (erreur_date, -2290);

    texte varchar(10);

BEGIN

    --erreur date de fin estimmée invalide 
    IF vDateDebut > vDateFinEstimee THEN
        texte := 'estimée';
        raise erreur_date;
    END IF;

    --erreur date de fin reelle invalide
    IF vDateDebut > vDateFinReelle THEN
        texte := 'réelle';
        raise erreur_date;
    END IF;

    --erreur id Client inconnu
    SELECT count(*) INTO m
	FROM Client
	WHERE idNumCli=vId;
	
	IF (m=0) THEN
		RAISE erreur_IdNumClient;
	END IF;

    --erreur id projet invalide
	SELECT count(*) INTO n
	FROM Projet
	WHERE idProjet=vId;
	
	IF (n=0) THEN
		RAISE erreur_ID;
	END IF;
    -- modification du projet 

    UPDATE Projet 
    SET nom = vNom,
     descriptionP = vDescription, 
     dateDebut = vDateDebut, 
     dateFinEstimee = vDateFinEstimee,
     dateFinReelle = vDateFinReelle,
     idNumCli = vIdNumClient
	where idProjet = vId;

	DBMS_OUTPUT.PUT_LINE('Projet '||vNom || ' modifié.');

	-- Valider (fin de transaction)

	COMMIT;

EXCEPTION
	
    WHEN erreur_date THEN 
        ROLLBACK;
        RAISE_APPLICATION_ERROR (-20001, 'date de fin' ||texte|| 'plus tot que date début');
    WHEN erreur_IdNumClient THEN
		ROLLBACK;
        RAISE_APPLICATION_ERROR (-20002, 'ID Client introuvable');
	WHEN erreur_ID THEN
		ROLLBACK;
        RAISE_APPLICATION_ERROR (-20003, 'ID inconnu');
	WHEN OTHERS THEN
		ROLLBACK;
		DBMS_OUTPUT.PUT_LINE (SQLERRM);
		RAISE_APPLICATION_ERROR (-20000, 'ERREUR IMPREVUE !');

END;
/

------------------------Procédure desactiverProjet--------------------------------

CREATE OR REPLACE PROCEDURE desactiverProjet( vID Projet.idProjet%TYPE)
AS

	erreur_ID EXCEPTION;
    PRAGMA EXCEPTION_INIT (erreur_ID, -2292);
	n NUMBER;

BEGIN

	SELECT count(*) INTO n
	FROM Projet
	WHERE idProjet=vID;
	
	IF (n=0) THEN
		RAISE erreur_ID;
	END IF;

	UPDATE Projet
	SET estActif=0 
	WHERE idProjet=vID;
	DBMS_OUTPUT.PUT_LINE('Projet '  || vID || 'est désormais inactif');
	COMMIT;
	
EXCEPTION
	
	WHEN erreur_ID THEN
		ROLLBACK;
        RAISE_APPLICATION_ERROR (-20050, 'ID inconnu');
	WHEN OTHERS THEN
		ROLLBACK;
		DBMS_OUTPUT.PUT_LINE (SQLERRM);
		RAISE_APPLICATION_ERROR (-20000, 'ERREUR IMPREVUE !');
		
END;
/




------------------------droit pour les procedures(NE MARCHE PAS)--------------------------------

--grant execute on CreerProjet TO Chef de projet;

--grant execute on AfficherProjet TO (select login from Employe where idRole = 1);
