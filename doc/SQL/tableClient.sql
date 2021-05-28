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
