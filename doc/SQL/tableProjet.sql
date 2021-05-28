------------------création table Projet-------------


drop TABLE Projet;

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

-----------------séquence pour id Projet----------------
drop sequence sequence_Projet;

create SEQUENCE sequence_Projet
    MINVALUE 1
    MAXVALUE 999
    START WITH 1
    increment by 1;
