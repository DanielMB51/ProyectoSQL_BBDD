SET SERVEROUTPUT ON;
DROP TABLE auditoria;
DROP SEQUENCE secuencia_auditoria;

--REQUISITO 1. Auditoría.
        -- Tabla
            CREATE TABLE auditoria(
                id_auditoria NUMBER(3) CONSTRAINT AUD_IDA_PK PRIMARY KEY,
                nombre_tabla VARCHAR2(50),
                suceso VARCHAR2(50),
                usuario VARCHAR2(50),
                fecha DATE
            );
        -- Secuencia
            CREATE SEQUENCE secuencia_auditoria START WITH 1 maxvalue 999 INCREMENT BY 1; 
        
        -- Procedimiento
            CREATE OR REPLACE PROCEDURE registrar_auditoria (nomb_tabla VARCHAR2, suc VARCHAR2, usua VARCHAR2, fech VARCHAR2) IS    
                BEGIN
                    INSERT INTO auditoria (id_auditoria, nombre_tabla, suceso, usuario, fecha)
                    VALUES (secuencia_auditoria.nextval, nomb_tabla , suc, usua, fech);
            END;
            /    
        -- Disparador PRESIDENTE
            CREATE OR REPLACE TRIGGER control_presidente
                AFTER INSERT OR UPDATE OR DELETE ON PRESIDENTE
                FOR EACH ROW
                DECLARE
                    v_suceso VARCHAR2(50);
                BEGIN
                    IF INSERTING THEN
                        v_suceso := 'Inserción';
                    ELSIF DELETING THEN
                        v_suceso := 'Borrado';
                    ELSIF UPDATING THEN
                        v_suceso := 'Actualización';
                    END IF;
                    registrar_auditoria('Presidente', v_suceso, USER, SYSDATE);
            END;
            /
            
        -- Disparador CLUB
            CREATE OR REPLACE TRIGGER control_club
                AFTER INSERT OR UPDATE OR DELETE ON CLUB
                FOR EACH ROW
                DECLARE
                    v_suceso VARCHAR2(50);
                BEGIN
                    IF INSERTING THEN
                        v_suceso := 'Inserción';
                    ELSIF DELETING THEN
                        v_suceso := 'Borrado';
                    ELSIF UPDATING THEN
                        v_suceso := 'Actualización';
                    END IF;
                    registrar_auditoria('Club', v_suceso, USER, SYSDATE);
            END;
            /
        -- Disparador CLUB
            CREATE OR REPLACE TRIGGER control_jugador
                AFTER INSERT OR UPDATE OR DELETE ON JUGADOR
                FOR EACH ROW
                DECLARE
                    v_suceso VARCHAR2(50);
                BEGIN
                    IF INSERTING THEN
                        v_suceso := 'Inserción';
                    ELSIF DELETING THEN
                        v_suceso := 'Borrado';
                    ELSIF UPDATING THEN
                        v_suceso := 'Actualización';
                    END IF;
                    registrar_auditoria('Jugador', v_suceso, USER, SYSDATE);
            END;
            /
        -- Disparador CLUB
            CREATE OR REPLACE TRIGGER control_equipo
                AFTER INSERT OR UPDATE OR DELETE ON EQUIPO
                FOR EACH ROW
                DECLARE
                    v_suceso VARCHAR2(50);
                BEGIN
                    IF INSERTING THEN
                        v_suceso := 'Inserción';
                    ELSIF DELETING THEN
                        v_suceso := 'Borrado';
                    ELSIF UPDATING THEN
                        v_suceso := 'Actualización';
                    END IF;
                    registrar_auditoria('Equipo', v_suceso, USER, SYSDATE);
            END;
            /
        -- Disparador COPA
            CREATE OR REPLACE TRIGGER control_copa
                AFTER INSERT OR UPDATE OR DELETE ON COPA
                FOR EACH ROW
                DECLARE
                    v_suceso VARCHAR2(50);
                BEGIN
                    IF INSERTING THEN
                        v_suceso := 'Inserción';
                    ELSIF DELETING THEN
                        v_suceso := 'Borrado';
                    ELSIF UPDATING THEN
                        v_suceso := 'Actualización';
                    END IF;
                    registrar_auditoria('COPA', v_suceso, USER, SYSDATE);
            END;
            /
            
            
            
--REQUISITO 2. Consultar jugador.
        -- Función para saber si existe jugador
            CREATE OR REPLACE FUNCTION existe_jugador(nombre VARCHAR2)
            RETURN BOOLEAN IS
                v_nombre VARCHAR2(30);
            BEGIN
                SELECT nombre_jugador INTO v_nombre FROM jugador WHERE nombre_jugador=nombre;
                -- Si encuentra un njugador con mismo nombre, devulver TRUE
                RETURN TRUE;
        -- Si no encuentra un njugador con mismo nombre, devulver FALSE
            EXCEPTION WHEN no_data_found THEN
                RETURN FALSE;
            END;
            /
            

        -- Procedimiento para mostrar por pantalla la información detallada de un pedido, junto al número de líneas, subpagos y pago total
            CREATE OR REPLACE PROCEDURE consultar_jugadores(nombrejugdor VARCHAR2) IS
                -- Utilizo un cursor para obtener los datos que voy a mostrar por pantallas referentes al código del pedido seleccionado
                CURSOR c_cursor IS SELECT j.nombre_jugador, j.paisorigen_jugador, j.fechanac, j.posicion, j.equipo_jugador, j.numero_jugador,c.nombre_club, c.paisorigen_club
                                     FROM jugador j, club c
                                        WHERE j.nombre_jugador=nombrejugdor AND j.equipo_jugador=c.nombre_club;
                
                v_detalle_jugador c_cursor%ROWTYPE;
            BEGIN
                OPEN c_cursor;
                -- El primer FETCH me permite recuperar los datos de la primera fila y así mostrar la primera línea del pedido
                FETCH c_cursor INTO v_detalle_jugador;  
                        DBMS_OUTPUT.PUT_LINE ('****************************************************');
                        DBMS_OUTPUT.PUT_LINE ('Nombre del club: ' || v_detalle_jugador.nombre_club);
                        DBMS_OUTPUT.PUT_LINE ('País del club: ' || v_detalle_jugador.paisorigen_club);
                        DBMS_OUTPUT.PUT_LINE ('');
                -- El bucle lo utilizo para mostrar todas las líneas que tiene el pedido que voy a mostrar y el FETCH del final para recuperar los datos de la siguiente línea
                LOOP  
                    EXIT WHEN c_cursor%NOTFOUND;
                        DBMS_OUTPUT.PUT_LINE ('----------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE ('Nombre del jugador: ' || v_detalle_jugador.nombre_jugador);
                        DBMS_OUTPUT.PUT_LINE ('País del jugador: ' || v_detalle_jugador.paisorigen_jugador);
                        DBMS_OUTPUT.PUT_LINE ('Fecha de nacimiento del jugador: ' || v_detalle_jugador.fechanac);
                        DBMS_OUTPUT.PUT_LINE ('Posición del jugador: ' || v_detalle_jugador.posicion);
                        DBMS_OUTPUT.PUT_LINE ('Equipo  del jugador: ' || v_detalle_jugador.equipo_jugador);
                    FETCH c_cursor INTO v_detalle_jugador;
                    END LOOP;
                CLOSE c_cursor;
            END;
            /

        -- Bloque anónimo para ejecutar la aplicación para visualizar de forma detallada un jugador.
            DECLARE 
                v_nombre VARCHAR(30);
            BEGIN
                v_nombre:='Cristiano Ronaldo';
                IF existe_jugador(v_nombre) = FALSE THEN
                    DBMS_OUTPUT.PUT_LINE('Jugador no encontrado');
                    RETURN;
                END IF;
                consultar_jugadores(v_nombre);   
                EXCEPTION WHEN VALUE_ERROR THEN
                   DBMS_OUTPUT.PUT_LINE('Error');
            END;
            /


--REQUISITO 3. Crear Jugador.

        -- Función para ver si el número de la camiseta ya esta escogido
            CREATE OR REPLACE FUNCTION existe_jugador_mismo_numero(n_equipo VARCHAR2, n_numero_jugador NUMBER)
            RETURN BOOLEAN IS
                v_numero VARCHAR2(30);
            BEGIN
                SELECT numero_jugador INTO v_numero FROM jugador WHERE n_equipo=equipo_jugador AND n_numero_jugador=numero_jugador;
                -- Si se ha encontrado un jugador con el mismo número, en ese mismo equipo, se devuelve TRUE.
                RETURN TRUE;
            -- Si no se ha encontrado un jugador con el mismo número, en ese mismo equipo, se devuelve FALSE.
            EXCEPTION WHEN no_data_found THEN
                RETURN FALSE;
            END;
            /
        -- Función para ver si existe el equipo que le vamos a pasar
            CREATE OR REPLACE FUNCTION existe_equipo(n_equipo VARCHAR2)
            RETURN BOOLEAN IS
                v_nombreclub VARCHAR2(30);
            BEGIN
                SELECT nombre_equipo INTO v_nombreclub FROM equipo WHERE n_equipo=nombre_equipo;
                -- Si se ha encontrado un equipo con el mismo nombre que le hemos pasado, devuelve TRUE.
                RETURN TRUE;
            -- Si no se ha encontrado un equipo con el mismo nombre que le hemos pasado, devuelve FALSE.
            EXCEPTION WHEN no_data_found THEN
                RETURN FALSE;
            END;
            /
            
        -- Prodecimiento para crear un nuevo jugador
            CREATE OR REPLACE PROCEDURE crear_nuevo_jugador(v_nombre_jugador VARCHAR,
                                                            v_paisorigen_jugador VARCHAR,
                                                            v_fechanac DATE,
                                                            v_posicion VARCHAR,
                                                            v_numero_jugador NUMBER,
                                                            v_equipo_jugador VARCHAR)

            AS
            numero_creado NUMBER;
            BEGIN
                -- Esto comprueba si el jugador tiene el mismo nombre que otro jugador
                IF existe_jugador(v_nombre_jugador) = TRUE THEN
                    DBMS_OUTPUT.PUT_LINE('Existe un jugador con ese nombre.');
                    RETURN;
                END IF;
                IF existe_equipo(v_equipo_jugador) = FALSE THEN
                    DBMS_OUTPUT.PUT_LINE('No existe equipo con este nombre.');
                    RETURN;
                END IF;
                IF estado_jugador(v_equipo_jugador, v_nombre_jugador) = TRUE THEN
                    DBMS_OUTPUT.PUT_LINE('Este jugador ya pertenece a este club');
                    RETURN;
                END IF;
                -- Esto comprueba si el jugador tiene el mismo número que un compañero
                IF existe_jugador_mismo_numero(v_equipo_jugador, v_numero_jugador) = TRUE THEN
                numero_creado:=1;
                    -- Este bucle va hacer que el numero se genere automaticamente si el numero que hemos insertado ya esta en uso
                    LOOP
                        -- Comprueba si no existe, y si no existe se sale del bucle
                        IF existe_jugador_mismo_numero(v_equipo_jugador, numero_creado) = FALSE THEN
                            EXIT;
                        END IF;
                        numero_creado:=numero_creado+1;
                    END LOOP;
                    /*Inserta el nuevo jugador con el número creado por la aplicación*/
                    INSERT INTO jugador VALUES(v_nombre_jugador, numero_creado, v_paisorigen_jugador, v_fechanac, v_equipo_jugador, v_posicion);
                    DBMS_OUTPUT.PUT_LINE('Jugador creado con exito');
                    RETURN;
                END IF;

                /*Inserta el nuevo jugador con el numero que le pasamos*/
                INSERT INTO jugador VALUES(v_nombre_jugador, v_numero_jugador, v_paisorigen_jugador, v_fechanac, v_equipo_jugador, v_posicion);
                DBMS_OUTPUT.PUT_LINE('Jugador creado con exito');
                EXCEPTION
                    /*En caso de que no exista el cÃ³digo de empleado o del cliente especificados, devuelve error y se detiene la ejecuciÃ³n*/
                    WHEN NO_DATA_FOUND THEN
                        DBMS_OUTPUT.PUT_LINE('El jugador no se puede crear');
                    WHEN OTHERS THEN
                        DBMS_OUTPUT.PUT_LINE('El jugador no se puede crear');
            END;
            /
            
        -- Bloque anonimo
            DECLARE 
                v_nombre_jugador VARCHAR(30);
                v_paisorigen_jugador VARCHAR(20); 
                v_fechanac DATE; 
                v_posicion VARCHAR(3);
                v_numero_jugador NUMBER;
                v_equipo_jugador VARCHAR(30);
            BEGIN
                v_nombre_jugador:='Daniel Muñoz';
                v_paisorigen_jugador:='España'; 
                v_fechanac:='14/10/2002'; 
                v_posicion:='DFC';
                v_numero_jugador:=15;
                v_equipo_jugador:='Real Madrid C.F.';
                    
                crear_nuevo_jugador(v_nombre_jugador, v_paisorigen_jugador, v_fechanac,
                                    v_posicion, v_numero_jugador, v_equipo_jugador);
            END;
            /


--REQUISITO 3. Crear COPA.
        
        -- Funcion para saber si exite alguna copa
            CREATE OR REPLACE FUNCTION existe_torneo(n_torneo VARCHAR2)
                RETURN BOOLEAN IS
                    v_nombretorneo VARCHAR2(20);
                BEGIN
                    SELECT nombre_copa INTO v_nombretorneo FROM copa WHERE nombre_copa=n_torneo;
                    -- Si se ha encontrado una copa con el mismo nombre, se devuelve TRUE.
                    RETURN TRUE;
                -- Si no se ha encontrado una copa con el mismo nombre, se devuelve FALSE.
                EXCEPTION WHEN no_data_found THEN
                    RETURN FALSE;
            END;
            /

        -- Procedimiento para crear la copa
            CREATE OR REPLACE PROCEDURE crear_nuevo_torneo(v_nombre_torneo VARCHAR2,
                                                           v_equipo1 VARCHAR2, v_equipo2 VARCHAR2,
                                                           v_equipo3 VARCHAR2, v_equipo4 VARCHAR2)
            AS
                BEGIN
                    -- Esto comprueba si existen los equipos            
                    IF (existe_equipo(v_equipo1)) = FALSE THEN
                        DBMS_OUTPUT.PUT_LINE('No existe equipo con este nombre.');
                        RETURN;
                    ELSIF existe_equipo(v_equipo2) = FALSE THEN
                        DBMS_OUTPUT.PUT_LINE('No existe equipo con este nombre.');
                        RETURN;
                    ELSIF existe_equipo(v_equipo3) = FALSE THEN
                        DBMS_OUTPUT.PUT_LINE('No existe equipo con este nombre.');
                        RETURN;
                    ELSIF existe_equipo(v_equipo4) = FALSE THEN
                        DBMS_OUTPUT.PUT_LINE('No existe equipo con este nombre.');
                        RETURN;
                    END IF;
                    -- Esto comprueba si existe el torneo
                    IF existe_torneo(v_nombre_torneo) = TRUE THEN
                        DBMS_OUTPUT.PUT_LINE('Ya existe torneo con este nombre');
                        RETURN;
                    END IF;
                    INSERT INTO copa VALUES (v_nombre_torneo, v_equipo1, v_equipo2, v_equipo3, v_equipo4);
                    DBMS_OUTPUT.PUT_LINE('Torneo creado con exito');
            END;
            /

        -- Bloque anonimo
            DECLARE 
                v_nombre_copa VARCHAR(20);
                v_equipo1 VARCHAR(30); 
                v_equipo2 VARCHAR(30);
                v_equipo3 VARCHAR(30);
                v_equipo4 VARCHAR(30);
                
            BEGIN
                v_nombre_copa:='Audi Cup';
                v_equipo1:='Real Madrid C.F.';
                v_equipo2:='Real Madrid Castilla';
                v_equipo3:='F.C. Barcelona';
                v_equipo4:='Club Atletico de Madrid';

                crear_nuevo_torneo(v_nombre_copa, v_equipo1, v_equipo2, v_equipo3, v_equipo4);
            END;
            /


--REQUISITO 4. Mostrar plantilla por club--
        -- Procedimiento para buscar jugadores de cada equipo
            CREATE OR REPLACE PROCEDURE mostrar_plantilla_equipo (nombre VARCHAR2)
            IS
                CURSOR defensa IS
                    SELECT DISTINCT j.nombre_jugador, j.paisorigen_jugador, j.fechanac, j.posicion FROM jugador j, club c WHERE j.equipo_jugador = nombre AND j.posicion IN ('LI', 'DFC', 'LD') ;
                    v_nombre_jugador VARCHAR2(30);
                    v_paisorigen_jugador VARCHAR2(20);
                    v_fechanac DATE;
                    v_posicion VARCHAR2(3);
                CURSOR portero IS
                    SELECT DISTINCT j.nombre_jugador, j.paisorigen_jugador, j.fechanac, j.posicion FROM jugador j, club c WHERE j.equipo_jugador = nombre AND j.posicion IN ('POR') ;
                CURSOR mediocampo IS
                    SELECT DISTINCT j.nombre_jugador, j.paisorigen_jugador, j.fechanac, j.posicion FROM jugador j, club c WHERE j.equipo_jugador = nombre AND j.posicion IN ('MI', 'MC', 'MCO', 'MD', 'MCD') ;
                CURSOR delantera IS
                    SELECT DISTINCT j.nombre_jugador, j.paisorigen_jugador, j.fechanac, j.posicion FROM jugador j, club c WHERE j.equipo_jugador = nombre AND j.posicion IN ('EI', 'SC', 'DC', 'ED') ;
            BEGIN
                OPEN portero;
                        DBMS_OUTPUT.PUT_LINE('--------------------------Portero--------------------------');
                        LOOP
                         FETCH portero INTO v_nombre_jugador, v_paisorigen_jugador, v_fechanac, v_posicion;
                         EXIT WHEN portero%NOTFOUND;
                         DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_nombre_jugador ||' || Nacionalidad: '|| v_paisorigen_jugador  ||'|| Fecha Nacimiento: '||  v_fechanac  ||' || Posición: '||  v_posicion);
                        END LOOP;
                CLOSE portero;
                OPEN defensa;
                        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('---------------------------Defensa---------------------------');
                        LOOP
                         FETCH defensa INTO v_nombre_jugador, v_paisorigen_jugador, v_fechanac, v_posicion;
                         EXIT WHEN defensa%NOTFOUND;
                         DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_nombre_jugador ||' || Nacionalidad: '|| v_paisorigen_jugador  ||'|| Fecha Nacimiento: '||  v_fechanac  ||' || Posición: '||  v_posicion);
                        END LOOP;
                CLOSE defensa;
                
                OPEN mediocampo;
                        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('--------------------------Mediocampo--------------------------');
                        LOOP
                         FETCH mediocampo INTO v_nombre_jugador, v_paisorigen_jugador, v_fechanac, v_posicion;
                         EXIT WHEN mediocampo%NOTFOUND;
                         DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_nombre_jugador ||' || Nacionalidad: '|| v_paisorigen_jugador  ||'|| Fecha Nacimiento: '||  v_fechanac  ||' || Posición: '||  v_posicion);
                        END LOOP;
                CLOSE mediocampo;
                
                OPEN delantera;
                        DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('--------------------------Delantera--------------------------');
                        LOOP
                         FETCH delantera INTO v_nombre_jugador, v_paisorigen_jugador, v_fechanac, v_posicion;
                         EXIT WHEN delantera%NOTFOUND;
                         DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_nombre_jugador ||' || Nacionalidad: '|| v_paisorigen_jugador  ||'|| Fecha Nacimiento: '||  v_fechanac  ||' || Posición: '||  v_posicion);
                        END LOOP;
                        DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------');
                CLOSE delantera;
                EXCEPTION WHEN no_data_found THEN
                    DBMS_OUTPUT.PUT_LINE('Nada encontrado');
            END;
            /
            
        -- Bloque anonimo
            DECLARE 
                v_equipo_jugador VARCHAR(30);
            BEGIN
                v_equipo_jugador:='Real Madrid C.F.';
                IF existe_equipo(v_equipo_jugador) = FALSE THEN
                    DBMS_OUTPUT.PUT_LINE('No existe equipo con este nombre.');
                    RETURN;
                END IF;
                mostrar_plantilla_equipo(v_equipo_jugador);
            END;
            /
            
--REQUISITO 5. Cambiar Equipo de Jugador.
        
        
        -- Funcion para saber si en que equipo esta
            CREATE OR REPLACE FUNCTION estado_jugador(n_equipo VARCHAR2, n_jugador VARCHAR2)
                RETURN BOOLEAN IS
                    v_nombre VARCHAR2(30);
                BEGIN
                    SELECT nombre_jugador INTO v_nombre FROM jugador WHERE n_equipo=equipo_jugador AND n_jugador=nombre_jugador;
                    -- Si se ha encontrado una copa con el mismo nombre, se devuelve TRUE.
                    RETURN TRUE;
                -- Si no se ha encontrado una copa con el mismo nombre, se devuelve FALSE.
                EXCEPTION WHEN no_data_found THEN
                    RETURN FALSE;
            END;
            /

        -- Procedimiento para hacer el traspaso del jugador
            CREATE OR REPLACE PROCEDURE traspaso_jugador(v_nombre_jugador VARCHAR, v_equipo_jugador VARCHAR)
            AS

            v_numerojugador_nuevo NUMBER;
            numero_creado NUMBER;
            
            BEGIN
                SELECT numero_jugador INTO v_numerojugador_nuevo FROM jugador
                WHERE nombre_jugador=v_nombre_jugador;
                
                -- Esto comprueba si el jugador tiene el mismo nombre que otro jugador
                IF existe_jugador(v_nombre_jugador) = FALSE THEN
                    DBMS_OUTPUT.PUT_LINE('No existe un jugador con ese nombre.');
                    RETURN;
                END IF;
                IF (existe_equipo(v_equipo_jugador)) = FALSE THEN
                        DBMS_OUTPUT.PUT_LINE('No existe equipo con este nombre.');
                        RETURN;
                END IF;
                -- Esto comprueba si esta en el mismo club
                IF estado_jugador(v_equipo_jugador, v_nombre_jugador) = TRUE THEN
                    DBMS_OUTPUT.PUT_LINE('Este jugador ya pertenece a este club');
                    RETURN;
                END IF;
                -- Comprueba si el jugador tiene el mismo número que sus compañeros
                IF existe_jugador_mismo_numero(v_equipo_jugador, v_numerojugador_nuevo) = TRUE THEN
                numero_creado:=1;
                    -- Este bucle va hacer que el numero se genere automaticamente si el numero que hemos insertado ya esta en uso
                    LOOP
                        -- Comprueba si no existe, y si no existe se sale del bucle
                        IF existe_jugador_mismo_numero(v_equipo_jugador, numero_creado) = FALSE THEN
                            EXIT;
                        END IF;
                        numero_creado:=numero_creado+1;
                    END LOOP;
                    /*Hacemos el traspaso de equipo con su nuevo número, ya que se encontro un compañero con ese mismo número*/
                    UPDATE jugador
                    SET numero_jugador = numero_creado, equipo_jugador = v_equipo_jugador WHERE v_nombre_jugador=nombre_jugador;
                    DBMS_OUTPUT.PUT_LINE('Jugador traspasado con exito');
                    RETURN;
                END IF;

                /*Hacemos el traspaso de equipo con su número original, ya que no se encontro un compañero con ese mismo número*/
                UPDATE jugador
                SET numero_jugador = v_numerojugador_nuevo, equipo_jugador = v_equipo_jugador WHERE v_nombre_jugador=nombre_jugador;
                DBMS_OUTPUT.PUT_LINE('Jugador traspasado con exito');
                EXCEPTION WHEN no_data_found THEN
                    DBMS_OUTPUT.PUT_LINE('Jugador traspasado sin exito');
            END;
            /


        -- Bloque anonimo
            DECLARE 
                v_nombre_jugador VARCHAR(30);
                v_equipo_jugador VARCHAR(30);
                
            BEGIN
                v_nombre_jugador:='Sergio Ramos';
                v_equipo_jugador:='F.C. Barcelona';
                traspaso_jugador(v_nombre_jugador, v_equipo_jugador);
            END;
            /
            
--REQUISITO 6. Limitar el tiempo para insertar copas.
        
        -- Disparador
            CREATE OR REPLACE TRIGGER limitarhora
                BEFORE INSERT ON copa
                BEGIN
                    IF (TO_CHAR(SYSDATE,'HH24') IN ('3','4','5','6','7','8')) THEN
                        RAISE_APPLICATION_ERROR (-20001,'No se puede permite añadir torneos entra las 3:00 y las 8:00');
                END IF;
            END;
            /
            
        
                

--REQUISITO 7. Borrar cualquier cosa de la base de datos
        
        -- Bloque anonimo para borrar el jugador
            DECLARE
                /*Creo las variable para decirle el nombre a borrar*/
                v_nombre_jugador VARCHAR2(30);
            BEGIN
                /*Se solicita el nombre del jugador a borrar y se guarda el nombre en una variable*/
                v_nombre_jugador:='Daniel Muñoz';
                -- Esto es para borrar el jugador
                 borrar_jugador(v_nombre_jugador);
            END;
            /
            
            
        -- Procedimiento para borrar jugador
            CREATE OR REPLACE PROCEDURE borrar_jugador(v_nombre_jugador VARCHAR)
            AS

            BEGIN
                -- Esto comprueba si el jugador existe
                IF existe_jugador(v_nombre_jugador) = FALSE THEN
                    DBMS_OUTPUT.PUT_LINE('No existe un jugador con ese nombre.');
                    RETURN;
                END IF;
                /*Borra todos los datos del jugador*/
                DELETE jugador WHERE nombre_jugador=v_nombre_jugador;
                DBMS_OUTPUT.PUT_LINE('Jugador borrado con exito');
                EXCEPTION
                    /*En caso de que no exista el cÃ³digo de empleado o del cliente especificados, devuelve error y se detiene la ejecuciÃ³n*/
                    WHEN NO_DATA_FOUND THEN
                        RAISE_APPLICATION_ERROR(-20001,'El nombre del jugador no existe');
                    /*En caso de que se introduzcan caracteres en lugar de nÃºmeros cuando se requiere, devuelve error y se detiene la ejecuciÃ³n*/
                    WHEN INVALID_NUMBER THEN
                        RAISE_APPLICATION_ERROR(-20001,'Ha introducido un valor numerico');
                    /*En caso de registrar cualquier otra excepciÃ³n, devuelve error y termina la ejecuciÃ³n (habitualmente, dejar como nulo algÃºn campo que requiera un valor)*/
                    WHEN OTHERS THEN
                        RAISE_APPLICATION_ERROR(-20001,'No se pueden dejar valores nulos en ciertos campos');
            END;
            /
            
        -- Bloque anonimo para borrar el equipo
            DECLARE
                    /*Creo las variable para decirle el equipo a borrar*/
                    v_nombre_equipo VARCHAR2(30);
            BEGIN
                /*Se solicita el nombre del equipo a borrar y se guarda el nombre en una variable*/
                v_nombre_equipo:='Real Madrid Castilla';
                    -- Esto es para borrar el equipo
                     borrar_equipo(v_nombre_equipo);
            END;
            / 
        -- Procedimiento para borrar equipo
            CREATE OR REPLACE PROCEDURE borrar_equipo(v_nombre_equipo VARCHAR)
            AS

            BEGIN


                /*Borra todos los datos del jugador*/
                DELETE jugador WHERE equipo_jugador IN (SELECT e.club_equipo FROM equipo e, club c WHERE e.nombre_equipo=v_nombre_equipo GROUP BY e.club_equipo);
                /*Borrar donde aparezca en las copas*/
                DELETE copa WHERE v_nombre_equipo IN( equipo1, equipo2, equipo3, equipo4);
                /*Borra todos los datos del equipo*/
                DELETE equipo WHERE nombre_equipo=v_nombre_equipo;
                /*Borra todas los datos del presidente*/
                DELETE presidente WHERE NOMBRE_PRESINDENTE IN (SELECT c.presi FROM equipo e, club c, presidente p WHERE e.nombre_equipo=v_nombre_equipo AND e.club_equipo=c.nombre_club AND c.presi=p.NOMBRE_PRESINDENTE GROUP BY c.presi);
                /*Borra todas los datos del club*/
                DELETE club WHERE nombre_club IN (SELECT e.club_equipo FROM equipo e, club c WHERE e.nombre_equipo=v_nombre_equipo GROUP BY e.club_equipo);
                DBMS_OUTPUT.PUT_LINE('Equipo borrado con exito');
            END;
            /