--------------------création table client-------------

create table Client(

    idClient number(5),
    nom varchar(30),
    prenom varchar(30),
    idProjetCommandé number(3),

    CONSTRAINT PK_idClient PRIMARY KEY (idClient),
    CONSTRAINT FK_idProjet_Projet FOREIGN KEY (idProjetCommandé) REFERENCES Projet(idProjet),
    CONSTRAINT UC_idClient UNIQUE (idClient)
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
    vIdProjetCommandé Client.idProjetCommandé%TYPE
)
IS 

    erreur_idProjetAssocie exception
    ----------traiter erreur idClient--------------
    PRAGMA EXCEPTION_INIT()

BEGIN

    INSERT INTO Client (idClient, nom, prenom, idProjetCommandé) 
	VALUES (sequence_Client.NEXTVAL, vNom, vPrenom, vIdProjetCommandé);
	DBMS_OUTPUT.PUT_LINE('Client '||vNom || ||vPrenom|| ' ajouté.');
	-- Valider (fin de transaction)
	COMMIT;

EXCEPTION

    WHEN erreur_idProjetAssocie THEN
		ROLLBACK;
		RAISE_APPLICATION_ERROR (-20010,'ID projet introuvable');
	WHEN OTHERS THEN
		ROLLBACK;
		DBMS_OUTPUT.PUT_LINE (SQLERRM);
		RAISE_APPLICATION_ERROR (-20010, 'ERREUR IMPREVUE !');

END;
/

------------------------DROIT POUR LA PROCEDURE--------------------------------
grant execute on CreerClient TO (select nom from Employe where idRole = 1);
