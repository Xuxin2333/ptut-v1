--------------------création table client-------------


drop TABLE Projet;

drop TABLE Client;

create table Client(

    idNumCli number(5),
    nom varchar(30),
    prenom varchar(30),
    entreprise varchar(30),
    email varchar(50),
    telephone varchar(14),
    estActif number(1), -- 1 est actif, 0 ne l'est pas 

    CONSTRAINT PK_idNumCli PRIMARY KEY (idNumCli),
    CONSTRAINT CHK_estActif CHECK (estActif IN (0,1))
);


create table Projet(

    idProjet number(3),
    nom varchar(100),
    descriptionP varchar(1000),
    dateDebut date, 
    dateFinEstimee date,
    dateFinReelle date,  
    estActif number(1) DEFAULT 1, --par défaut actif

    idNumCli number (5),

    CONSTRAINT PK_idClient PRIMARY KEY (idProjet),
    CONSTRAINT FK_idNumCLi FOREIGN KEY (idNumCli) references Client(idNumCli),
    CONSTRAINT CHK_estActif_projet CHECK (estActif IN (1,2)),
    CONSTRAINT CHK_dateDebut_fin CHECK (dateDebut < dateFinEstimee and dateDebut < dateFinReelle)
);



-----------------séquence pour id client----------------

drop Sequence sequence_Client;

create SEQUENCE sequence_Client
    MINVALUE 1
    MAXVALUE 99999
    START WITH 1
    increment by 1;


-------------------procédure créer client-----------------

CREATE OR REPLACE PROCEDURE CreerClient
(
    vNom Client.nom%TYPE,
    vPrenom Client.prenom%TYPE,
    vEntreprise Client.entreprise%TYPE,
    vEmail Client.email%TYPE,
    vTelephone Client.telephone%TYPE
)
IS 


BEGIN

    INSERT INTO Client (idNumCli, nom, prenom, entreprise, email, telephone, estActif) 
	VALUES (sequence_Client.NEXTVAL, vNom, vPrenom, vEntreprise, vEmail, vTelephone, 1);
	DBMS_OUTPUT.PUT_LINE('Client '||vNom || ' + ' ||vPrenom|| ' ajouté.');
	-- Valider (fin de transaction)
	COMMIT;

EXCEPTION

	WHEN OTHERS THEN
		ROLLBACK;
		DBMS_OUTPUT.PUT_LINE (SQLERRM);
		RAISE_APPLICATION_ERROR (-20010, 'ERREUR IMPREVUE !');

END;
/

------------------------Procedure AfficherClient-----------------------------

CREATE OR REPLACE PROCEDURE AfficherClient
(
    vId Client.idNumCli%TYPE
)
as
    vNom Client.nom%TYPE;
    vPrenom Client.prenom%TYPE;
    vEntreprise Client.entreprise%TYPE;
    vEmail Client.email%TYPE;
    vTelephone Client.telephone%TYPE;
    vActif Client.estActif%TYPE;

    erreur_ID EXCEPTION;
    PRAGMA EXCEPTION_INIT (erreur_ID, -2292);
    n NUMBER;

BEGIN

    SELECT count(*) INTO n
	FROM Client
	WHERE idNumCli=vID;
	
	IF (n=0) THEN
		RAISE erreur_ID;
	END IF;

    select nom, prenom, entreprise, email, telephone, estActif  into vNom,vPrenom ,vEntreprise ,vEmail ,vTelephone ,vActif
    from Client
    where Client.idNumCli = vId;

	DBMS_OUTPUT.PUT_LINE('nom :'||vNom);
    DBMS_OUTPUT.PUT_LINE('prenom :'||vPrenom);
    DBMS_OUTPUT.PUT_LINE('Entreprise du client :'||vEntreprise);
    DBMS_OUTPUT.PUT_LINE('Email du client :'||vEmail);
    DBMS_OUTPUT.PUT_LINE('numéro du client :'||vTelephone);
    IF vActif = 1 THEN
    DBMS_OUTPUT.PUT_LINE('Le project est en cours');
    ELSE
    DBMS_OUTPUT.PUT_LINE('Le project est fini');
    END IF;
	-- Valider (fin de transaction)
	COMMIT;

EXCEPTION
	
	WHEN erreur_ID THEN
		ROLLBACK;
		RAISE_APPLICATION_ERROR (-2292, 'ID inconnu');
	WHEN OTHERS THEN
		ROLLBACK;
		DBMS_OUTPUT.PUT_LINE (SQLERRM);
		RAISE_APPLICATION_ERROR (-20000, 'ERREUR IMPREVUE !');

END;
/


------------------------Procedure modifierProjet-----------------------------


CREATE OR REPLACE PROCEDURE modifierClient
(
    vId Client.idNumCli%TYPE,
    vNom Client.nom%TYPE,
    vPrenom Client.prenom%TYPE,
    vEntreprise Client.entreprise%TYPE,
    vEmail Client.email%TYPE,
    vTelephone Client.telephone%TYPE
)
as
    
    erreur_ID EXCEPTION;
    PRAGMA EXCEPTION_INIT (erreur_ID, -2292);
    n NUMBER;

BEGIN

    -- modifier les champs du clients
    SELECT count(*) INTO n
	FROM Client
	WHERE idNumCli=vID;
	
	IF (n=0) THEN
		RAISE erreur_ID;
	END IF;

    UPDATE Client
    SET nom = vNom,
        prenom = vPrenom,
        entreprise = vEntreprise,
        email = vEmail,
        telephone = vTelephone 
    where idNumCli = vId;

	DBMS_OUTPUT.PUT_LINE('Client '||vNom || ' + ' ||vPrenom|| ' modifié.');
    
	-- Valider (fin de transaction)

	COMMIT;

EXCEPTION
	
	WHEN erreur_ID THEN
		ROLLBACK;
		RAISE_APPLICATION_ERROR (-2292, 'ID inconnu');
	WHEN OTHERS THEN
		ROLLBACK;
		DBMS_OUTPUT.PUT_LINE (SQLERRM);
		RAISE_APPLICATION_ERROR (-20000, 'ERREUR IMPREVUE !');

END;
/



------------------------Procédure desactiverClient--------------------------------

CREATE OR REPLACE PROCEDURE desactiverClient( vId Client.idNumCli%TYPE)
AS

erreur_ID EXCEPTION;
PRAGMA EXCEPTION_INIT (erreur_ID, -2292);
n NUMBER;

BEGIN

	SELECT count(*) INTO n
	FROM Client
	WHERE idNumCli=vId;
	
	IF (n=0) THEN
		RAISE erreur_ID;
	END IF;

	UPDATE Client
	SET estActif=0 
	WHERE idNumCli=vId;
	DBMS_OUTPUT.PUT_LINE('Client '  || vId || 'est désormais inactif');
	COMMIT;
	
EXCEPTION
	
	WHEN erreur_ID THEN
		ROLLBACK;
        RAISE_APPLICATION_ERROR (-2292, 'ID inconnu');
	WHEN OTHERS THEN
		ROLLBACK;
		DBMS_OUTPUT.PUT_LINE (SQLERRM);
		RAISE_APPLICATION_ERROR (-20000, 'ERREUR IMPREVUE !');
		
END;
/




------------------------droit pour les procedures(NE MARCHE PAS)--------------------------------

--grant execute on CreerClient TO (select idEmploye from Employe where idRole = 1);

--grant execute on AfficherClient TO (select idEmploye from Employe where idRole = 1);
