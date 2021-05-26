--------------------création table client-------------

create table Client(

    idNumCli number(5),
    nom varchar(30),
    prenom varchar(30),
    entreprise varchar(30);
    email varchar(50);
    telephone number(10);
    estActif number(1); -- 1 est actif, 0 ne l'est pas 

    CONSTRAINT PK_idNumCli PRIMARY KEY (idNumCli),
    CONSTRAINT UC_idNumCli UNIQUE (idNumCli)
    CONSTRAINT CHK_estActif CHECK (estActif IN (0,1)),
);

-----------------séquence pour id client----------------

create SEQUENCE sequence_Client
    MINVALUE 1
    MAXVALUE 99999
    START WITH 1
    INCREMENT BY value
    CACHE value;

-------------------procédure créer client-----------------

CREATE OR REPLACE PROCEDURE CreerClient
(
    vNom Client.Nom%TYPE,
    vPrenom Client.prenom%TYPE,
    vEntreprise Client.entreprise%TYPE,
    vEmail Client.email%TYPE,
    vTelephone Client.telephone%TYPE
)
IS 


BEGIN

    INSERT INTO Client (idNumCli, nom, prenom, entreprise, email, telephone, estActif) 
	VALUES (sequence_Client.NEXTVAL, vNom, vPrenom, vEntreprise, vEmail, vTelephone, 1);
	DBMS_OUTPUT.PUT_LINE('Client '||vNom || ||vPrenom|| ' ajouté.');
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
grant execute on CreerClient TO (select nom from Employe where idRole = 1);
