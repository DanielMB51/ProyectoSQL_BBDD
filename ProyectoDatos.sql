/*Tablas*/
/*Mi base de datos va a ser de un Equipo de futbol*/

DROP TABLE copa;
DROP TABLE equipo;
DROP TABLE jugador;
DROP TABLE club;
DROP TABLE presidente;

/*En la tabla PRESIDENTE pondremos su nombre, su fecha de nacimiento, sus acciones y sus años de experiencia como empresario*/
/*El atributo EXPERIENCIA por defecto sera 0*/
CREATE TABLE PRESIDENTE(
    NOMBRE_PRESINDENTE VARCHAR2(20) CONSTRAINT PRE_NOM_PK PRIMARY KEY,
    FECHANAC DATE CONSTRAINT PRE_FEC_NN NOT NULL,
    ACCIONES NUMBER(2) CONSTRAINT PRE_ACC_NN NOT NULL,
    EXPERIENCIA NUMBER(3) DEFAULT 0
);

/*En la tabla CLUB sera completada con su nombre, su presidente, el pais de de donde pertenece y fecha de creacion*/
CREATE TABLE CLUB(
    NOMBRE_CLUB VARCHAR2(30) CONSTRAINT CLU_NOM_PK PRIMARY KEY,
    PRESI VARCHAR2(20) CONSTRAINT PRE_CLUB_FK REFERENCES PRESIDENTE,
    PAISORIGEN_CLUB VARCHAR2(20) CONSTRAINT ESC_PAI_NN NOT NULL,
    CREACION DATE
);

/*En la tabla JUGADOR sera rellenada con su nombre, su numero(que comprueba si su número esta entre 1 y 24), su pais de origen y su
fecha de nacimiento*/
CREATE TABLE JUGADOR(
    NOMBRE_JUGADOR VARCHAR2(30) CONSTRAINT JUG_NOM_PK PRIMARY KEY,
    NUMERO_JUGADOR NUMBER(8) CONSTRAINT JUG_NUM_NN NOT NULL,
    PAISORIGEN_JUGADOR VARCHAR2(20) CONSTRAINT JUG_PAI_NN NOT NULL,
    FECHANAC DATE CONSTRAINT JUG_FEC_NN NOT NULL,
    EQUIPO_JUGADOR VARCHAR2(30) CONSTRAINT CLU_JUG_FK REFERENCES CLUB,
    POSICION VARCHAR2(3) CONSTRAINT JUG_POS_NN NOT NULL,
    CONSTRAINT JUG_NUM_CK CHECK (NUMERO_JUGADOR BETWEEN 1 AND 25)
);

/*En la tabla EQUIPO sera completada con el once, el equipo(referencia a la tabla CLUB), la division*/

CREATE TABLE EQUIPO(
    NOMBRE_EQUIPO VARCHAR(30) CONSTRAINT  EQU_NEQ_PK  PRIMARY KEY,
    ONCE VARCHAR2(20) CONSTRAINT EQU_ONC_NN NOT NULL,
    CLUB_EQUIPO VARCHAR2(30) CONSTRAINT CLU_EQU_FK REFERENCES CLUB,
    DIVISION CHAR(3) CONSTRAINT EQU_DIV_NN NOT NULL
);

/*En la tabla COPA pondremos su nombre, el club y los cuatro equipos*/
/*Los equipos han de ser diferentes*/
CREATE TABLE COPA(
    NOMBRE_COPA VARCHAR2(20) CONSTRAINT COP_NOM_PK PRIMARY KEY,
    EQUIPO1 VARCHAR2(30) CONSTRAINT COP_EQU_FK1 REFERENCES EQUIPO,
    EQUIPO2 VARCHAR2(30) CONSTRAINT COP_EQU_FK2 REFERENCES EQUIPO,
    EQUIPO3 VARCHAR2(30) CONSTRAINT COP_EQU_FK3 REFERENCES EQUIPO,
    EQUIPO4 VARCHAR2(30) CONSTRAINT COP_EQU_FK4 REFERENCES EQUIPO,
    CONSTRAINT COP_CLU_CK CHECK (EQUIPO1!=EQUIPO2 AND EQUIPO1!=EQUIPO3 AND EQUIPO2!=EQUIPO3 AND EQUIPO1!=EQUIPO4 AND EQUIPO2!=EQUIPO4 AND EQUIPO3!=EQUIPO4)
);


----------------------------DATOS PRESIDENTES----------------------------
INSERT INTO Presidente VALUES ('Florentino Perez', '08/03/1947', 51, 15);
INSERT INTO Presidente VALUES ('Joan Laporte', '29/06/1962', 51, 9);
INSERT INTO Presidente VALUES ('Enrique Cerezo', '28/05/1948', 51, 20);
INSERT INTO Presidente VALUES ('Jose Castro Carmona', '20/07/1958', 51, 7);
INSERT INTO Presidente VALUES ('Ángel Haro', '05/07/1974', 51, 5);
INSERT INTO Presidente VALUES ('Andrea Agnelli', '06/12/1975', 51, 11);
INSERT INTO Presidente VALUES ('Josep Maria Bartomeu', '06/02/1963', 0, 4);


-------------------------------DATOS CLUB--------------------------------
INSERT INTO club VALUES ('Real Madrid C.F.', 'Florentino Perez', 'España', '06/03/1902');
INSERT INTO club VALUES ('F.C. Barcelona', 'Joan Laporte', 'España', '29/11/1899');
INSERT INTO club VALUES ('Club Atletico de Madrid', 'Enrique Cerezo', 'España', '26/04/1903');
INSERT INTO club VALUES ('Sevilla F.C.', 'Jose Castro Carmona', 'España', '25/01/1890');
INSERT INTO club VALUES ('Real Betis Balompie', 'Jose Castro Carmona', 'España', '12/09/1907');
INSERT INTO club VALUES ('Juventus de Turin', 'Andrea Agnelli', 'Italia', '1/11/1897');
               
-----------------------------DATOS JUGADORES-----------------------------

--Real Madrid C.F.--
INSERT INTO jugador VALUES ('Thibaut Courtois', 1, 'Belgica', '11/06/1992', 'Real Madrid C.F.', 'POR');
INSERT INTO jugador VALUES ('Ferland Mendy', 23, 'Francia', '08/06/1995', 'Real Madrid C.F.', 'LI');
INSERT INTO jugador VALUES ('Sergio Ramos', 4, 'España', '05/02/1985', 'Real Madrid C.F.', 'DFC');
INSERT INTO jugador VALUES ('Nacho Fernández', 6, 'España', '18/01/1980', 'Real Madrid C.F.', 'DFC');
INSERT INTO jugador VALUES ('Raphaël Varane', 5, 'Francia', '25/04/1993', 'Real Madrid C.F.', 'DFC');
INSERT INTO jugador VALUES ('Dani Carvajal', 2, 'España', '11/01/1992', 'Real Madrid C.F.', 'LD');
INSERT INTO jugador VALUES ('Carlos Casemiro', 14, 'Brasil', '23/02/1992', 'Real Madrid C.F.', 'MCD');
INSERT INTO jugador VALUES ('Toni Kross', 8, 'Alemania', '23/02/1992', 'Real Madrid C.F.', 'MC');
INSERT INTO jugador VALUES ('Luka Modric', 10, 'Alemania', '09/11/1985', 'Real Madrid C.F.', 'MC');
INSERT INTO jugador VALUES ('Francisco Alarcón', 22, 'España', '21/04/1992', 'Real Madrid C.F.', 'MCO');
INSERT INTO jugador VALUES ('Vinícius Júnior', 20, 'Brasil', '12/06/2000', 'Real Madrid C.F.', 'EI');
INSERT INTO jugador VALUES ('Eden Hazard', 7, 'Belgica', '07/01/1991', 'Real Madrid C.F.', 'EI');
INSERT INTO jugador VALUES ('Karim Benzema', 9, 'Francia', '19/12/1987', 'Real Madrid C.F.', 'DC');
INSERT INTO jugador VALUES ('Marco Asensio', 11, 'España', '21/01/1996', 'Real Madrid C.F.', 'ED');
INSERT INTO jugador VALUES ('Rodrygo Goes', 25, 'Brasil', '09/01/2001', 'Real Madrid C.F.', 'ED');

--F.C. Barcelona--
INSERT INTO jugador VALUES ('Marc-André ter Stegen', 1, 'Alemania', '30/04/1992', 'F.C. Barcelona', 'POR');
INSERT INTO jugador VALUES ('Jordi Alba', 18, 'España', '21/03/1989', 'F.C. Barcelona', 'LI');
INSERT INTO jugador VALUES ('Gerard Piqué', 3, 'España', '13/08/2008', 'F.C. Barcelona', 'DFC');
INSERT INTO jugador VALUES ('Clément Lenglet', 15, 'Francia', '17/06/1995', 'F.C. Barcelona', 'DFC');
INSERT INTO jugador VALUES ('Ronald Araujo', 4, 'Uruguay', '07/03/1999', 'F.C. Barcelona', 'DFC');
INSERT INTO jugador VALUES ('Sergiño Dest', 2, 'EEUU', '03/11/2000', 'F.C. Barcelona', 'LD');
INSERT INTO jugador VALUES ('Sergio Busquets', 5, 'España', '16/07/1988', 'F.C. Barcelona', 'MCD');
INSERT INTO jugador VALUES ('Frenkie de Jong', 21, 'Holanda', '12/05/1997', 'F.C. Barcelona', 'MC');
INSERT INTO jugador VALUES ('Pedri', 16, 'España', '25/11/2002', 'F.C. Barcelona', 'MC');
INSERT INTO jugador VALUES ('Philippe Coutinho', '14', 'Brasil', '12/06/1992', 'F.C. Barcelona', 'MCO');
INSERT INTO jugador VALUES ('Antoine Griezmann', 7, 'Francia', '21/03/1991', 'F.C. Barcelona', 'EI');
INSERT INTO jugador VALUES ('Anssumane Fati', 22, 'España', '31/10/2002', 'F.C. Barcelona', 'EI');
INSERT INTO jugador VALUES ('Martin Braithwaite', 9, 'Dinamarca', '05/06/1991', 'F.C. Barcelona', 'DC');
INSERT INTO jugador VALUES ('Lionel Messi', 10, 'Argentina', '24/06/1987', 'F.C. Barcelona', 'ED');
INSERT INTO jugador VALUES ('Ousmane Dembélé', 11, 'Francia', '15/05/1997', 'F.C. Barcelona', 'ED');

--Club Atletico de Madrid--
INSERT INTO jugador VALUES ('Jan Oblak', 13, 'Eslovenia', '07/01/1993', 'Club Atletico de Madrid', 'POR');
INSERT INTO jugador VALUES ('Renan Lodi', 12, 'Brasil', '08/04/1998', 'Club Atletico de Madrid', 'LI');
INSERT INTO jugador VALUES ('Mario Hermoso', 22, 'España', '18/06/1995', 'Club Atletico de Madrid', 'DFC');
INSERT INTO jugador VALUES ('Stefan Savic', 15, 'Montenegro', '08/01/1991', 'Club Atletico de Madrid', 'DFC');
INSERT INTO jugador VALUES ('José María Gimenez', 2, 'Uruguay', '20/01/1995', 'Club Atletico de Madrid', 'DFC');
INSERT INTO jugador VALUES ('Kieran Trippier', 23, 'Inglaterra', '19/09/1990', 'Club Atletico de Madrid', 'LD');
INSERT INTO jugador VALUES ('Geoffrey Kondogbia', 4, 'Francia', '15/02/1993', 'Club Atletico de Madrid', 'MCD');
INSERT INTO jugador VALUES ('Jorge Resurreción', 6, 'España', '08/01/1992', 'Club Atletico de Madrid', 'MC');
INSERT INTO jugador VALUES ('Saúl Ñiguez', 8, 'España', '21/11/1994', 'Club Atletico de Madrid', 'MC');
INSERT INTO jugador VALUES ('Marcos Llorente', '14', 'España', '30/01/1995', 'Club Atletico de Madrid', 'MC');
INSERT INTO jugador VALUES ('Yannick Carrasco', 10, 'Bélgica', '04/09/1993', 'Club Atletico de Madrid', 'EI');
INSERT INTO jugador VALUES ('Ángel Correa', 10, 'Argentina', '09/03/1995', 'Club Atletico de Madrid', 'DC');
INSERT INTO jugador VALUES ('Luis Suarez', 9, 'Uruguay', '24/01/1987', 'Club Atletico de Madrid', 'DC');
INSERT INTO jugador VALUES ('Joao Felix', 7, 'Portugal', '10/11/1999', 'Club Atletico de Madrid', 'DC');
INSERT INTO jugador VALUES ('Moussa Dembélé', 19, 'Francia', '12/07/1996', 'Club Atletico de Madrid', 'DC');

--Sevilla F.C.--
INSERT INTO jugador VALUES ('Yassine Bounou', 13, 'Marruecos', '05/04/1991', 'Sevilla F.C.', 'POR');
INSERT INTO jugador VALUES ('Jesús Navas', 12, 'España', '21/11/1985', 'Sevilla F.C.', 'LI');
INSERT INTO jugador VALUES ('Diego Carlos', 20, 'Brasil', '15/03/1993', 'Sevilla F.C.', 'DFC');
INSERT INTO jugador VALUES ('Jules Koundé', 12, 'Francia', '12/11/1998', 'Sevilla F.C.', 'DFC');
INSERT INTO jugador VALUES ('Sergi Gómez', 3, 'España', '28/03/1992', 'Sevilla F.C.', 'DFC');
INSERT INTO jugador VALUES ('Marcos Acuña', 19, 'Argentina', '28/10/1991', 'Sevilla F.C.', 'LD');
INSERT INTO jugador VALUES ('Franco Vázquez', 22, 'Argentina', '22/02/1989', 'Sevilla F.C.', 'MCD');
INSERT INTO jugador VALUES ('Ivan Rakitic', 6, 'Croacia', '10/03/1988', 'Sevilla F.C.', 'MC');
INSERT INTO jugador VALUES ('Joan Jordán', 8, 'España', '06/07/1994', 'Sevilla F.C.', 'MC');
INSERT INTO jugador VALUES ('Lucas Ocampos', '14', 'Argentina', '11/07/1994', 'Sevilla F.C.', 'MCO');
INSERT INTO jugador VALUES ('Munir El Haddadi', 11, 'España', '01/09/1995', 'Sevilla F.C.', 'EI');
INSERT INTO jugador VALUES ('Jesús Joaquín', 10, 'España', '19/11/1993', 'Sevilla F.C.', 'EI');
INSERT INTO jugador VALUES ('Luuk de Jong', 9, 'Holanda', '07/08/1990', 'Sevilla F.C.', 'DC');
INSERT INTO jugador VALUES ('Youssef En-Nesyri', 15, 'Marruecos', '01/06/1997', 'Sevilla F.C.', 'DC');
INSERT INTO jugador VALUES ('Papu Gómez', 24, 'Argentina', '15/02/1988', 'Sevilla F.C.', 'ED');


--Juventus de Turín--
INSERT INTO jugador VALUES ('Cristiano Ronaldo', 7, 'Portugal', '05/02/1985', 'Juventus de Turin', 'DC');

------------------------------DATOS EQUIPOS------------------------------

INSERT INTO equipo VALUES ('Real Madrid C.F.', '4-3-3', 'Real Madrid C.F.', 1);
INSERT INTO equipo VALUES ('Real Madrid Castilla', '4-3-3', 'Real Madrid C.F.', 1);
INSERT INTO equipo VALUES ('F.C. Barcelona', '4-3-3', 'F.C. Barcelona', 1);
INSERT INTO equipo VALUES ('Sevilla F.C.', '4-4-2', 'Sevilla F.C.', 1);
INSERT INTO equipo VALUES ('Sevilla Atletico', '4-4-2', 'Sevilla F.C.', 1);
INSERT INTO equipo VALUES ('Club Atletico de Madrid', '5-3-2', 'Club Atletico de Madrid', 1);

-------------------------------DATOS COPAS-------------------------------
INSERT INTO copa VALUES ('Copa del Rey', 'Real Madrid C.F.', 'F.C. Barcelona', 'Real Madrid Castilla', 'Club Atletico de Madrid');
INSERT INTO copa VALUES ('SuperCopa de España', 'Real Madrid C.F.', 'F.C. Barcelona', 'Sevilla F.C.', 'Club Atletico de Madrid');

