CREATE OR REPLACE PACKAGE BODY PK_LOG IS
   --
   /*
   * STANDARD SOFTWARE SOLUTIONS LTDA.
   * Edson Luis Gonçalez
   * edson.goncalez@gmail.com
   * Junho/2013
   */
   --
   PROCEDURE ENVIA_EMAIL_PENDENTE IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      V_MSG   VARCHAR2(4000);
      V_LINHA VARCHAR2(4000);
   BEGIN
      FOR REC1 IN (SELECT ROWID,
                          T.*
                     FROM LOG_GENERICO T
                    WHERE NVL(T.ID_ENVIA_EMAIL, 'N') = 'S'
                      AND NVL(T.ID_ENVIA_EMAIL_ENVIADO, ' ') = 'N')
      LOOP
         --
         V_MSG   := 'Alerta WMS: ' || REC1.PROGRAMA || ' - ' || REC1.PROCESSO || ' (' || REC1.CHAVE || ')';
         V_LINHA := RPAD('=', LENGTH(V_MSG), '=');
         PK_EMAIL.AGENDA_ENVIO(P_SUBJ => V_MSG,
                               P_BODY => V_MSG || PK_EMAIL.CRLF || V_LINHA || PK_EMAIL.CRLF || REC1.MSG,
                               P_SEQ_LOG => REC1.SEQ);
      
         --
         UPDATE LOG_GENERICO
            SET ID_ENVIA_EMAIL_ENVIADO = 'S'
          WHERE ROWID = REC1.ROWID;
      
         --
         COMMIT;
         --
      END LOOP;
   END;

   PROCEDURE T(EV_MSG IN VARCHAR2) IS
   BEGIN
      L(EV_PROCESSO => NULL, EV_MSG => EV_MSG, EB_TEMPORARY => TRUE);
   END;

   PROCEDURE CLT IS
   BEGIN
      DELETE LOG_TEMPORARY;
   
      PK_LOG.SEQ_TEMPORARY := NULL;
   END CLT;

   FUNCTION GET_HASH_VALUE(EV_VL IN VARCHAR2) RETURN NUMBER IS
      V_HASH1 NUMBER;
   BEGIN
      SELECT ORA_HASH(EV_VL)
        INTO V_HASH1
        FROM DUAL;
   
      RETURN V_HASH1;
   END;

   PROCEDURE LOG_(EV_PROCESSO       IN PK_LOG.T_PROCESSO,
                  EV_MSG            IN VARCHAR2,
                  EV_USUARIO        IN VARCHAR2,
                  EV_PROGRAMA       IN VARCHAR2,
                  EV_CHAVE          IN VARCHAR2,
                  EV_ID_ENVIA_EMAIL IN VARCHAR2,
                  EB_TEMPORARY      IN BOOLEAN) IS
      --
      V_CHAVE        VARCHAR2(1000);
      V_SEQ          NUMBER;
      V_MSG_ANTERIOR VARCHAR2(4000);
      --
   BEGIN
      --
      IF NOT EB_TEMPORARY THEN
         SELECT LOGGENERICO_SEQ.NEXTVAL
           INTO V_SEQ
           FROM DUAL;
      ELSE
         PK_UTIL.ADD_NUM(PK_LOG.SEQ_TEMPORARY, 1);
         V_SEQ := PK_LOG.SEQ_TEMPORARY;
      END IF;
   
      --
      IF EV_CHAVE IS NULL THEN
         V_CHAVE              := 'INTERNAL:' || TO_CHAR(V_SEQ, '000000000000000');
         PK_LOG.CHAVE_INTERNA := V_CHAVE;
      ELSE
         V_CHAVE := EV_CHAVE;
      END IF;
   
      IF NOT EB_TEMPORARY THEN
         -- Se não for log temporário (em memória)
         BEGIN
            INSERT INTO LOG_GENERICO
               (SEQ,
                DT_ADDROW,
                PROCESSO,
                MSG,
                USUARIO,
                PROGRAMA,
                DT_LAST_MSG,
                CHAVE,
                CONTADOR,
                ID_ENVIA_EMAIL,
                OSUSER,
                MACHINE,
                CLIENT_INFO,
                PROGRAM,
                TERMINAL,
                AUDSID)
            VALUES
               (V_SEQ,
                SYSDATE,
                UPPER(EV_PROCESSO),
                EV_MSG,
                UPPER(NVL(EV_USUARIO, 'osuser:' || PK_SESSAO.GET_USUARIO_SO)),
                UPPER(NVL(EV_PROGRAMA, 'program:' || PK_SESSAO.GET_PROGRAMA)),
                SYSDATE,
                V_CHAVE,
                1,
                EV_ID_ENVIA_EMAIL,
                PK_SESSAO.GET_USUARIO_SO,
                PK_SESSAO.GET_MAQUINA,
                PK_SESSAO.GET_CLIENT_INFO,
                PK_SESSAO.GET_PROGRAMA,
                PK_SESSAO.GET_TERMINAL,
                PK_SESSAO.GET_AUDSID);
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
               BEGIN
                  V_MSG_ANTERIOR := NULL;
               
                  SELECT MSG
                    INTO V_MSG_ANTERIOR
                    FROM LOG_GENERICO
                   WHERE NVL(EV_MSG, ' ') <> NVL(MSG, ' ')
                     AND UPPER(NVL(CHAVE, ' ')) = UPPER(NVL(EV_CHAVE, ' '))
                     AND UPPER(NVL(PROCESSO, ' ')) = UPPER(NVL(EV_PROCESSO, ' '))
                     AND UPPER(NVL(PROGRAMA, ' ')) = UPPER(NVL(EV_PROGRAMA, ' '));
               EXCEPTION
                  WHEN OTHERS THEN
                     V_MSG_ANTERIOR := NULL;
               END;
            
               UPDATE LOG_GENERICO
                  SET MSG          = EV_MSG,
                      MSG_ANTERIOR = NVL(V_MSG_ANTERIOR, MSG_ANTERIOR),
                      DT_LAST_MSG  = SYSDATE,
                      CONTADOR     = CONTADOR + 1
                WHERE CHAVE = EV_CHAVE;
         END;
      ELSE
         -- Log temporário (em memória)
         BEGIN
            INSERT INTO LOG_TEMPORARY
               (SEQ,
                DT_ADDROW,
                PROCESSO,
                MSG,
                USUARIO,
                PROGRAMA,
                DT_LAST_MSG,
                CHAVE,
                CONTADOR,
                ID_ENVIA_EMAIL,
                OSUSER,
                MACHINE,
                CLIENT_INFO,
                PROGRAM,
                TERMINAL,
                AUDSID)
            VALUES
               (PK_LOG.SEQ_TEMPORARY,
                SYSDATE,
                UPPER(EV_PROCESSO),
                EV_MSG,
                UPPER(NVL(EV_USUARIO, 'osuser:' || PK_SESSAO.GET_USUARIO_SO)),
                UPPER(NVL(EV_PROGRAMA, 'program:' || PK_SESSAO.GET_PROGRAMA)),
                SYSDATE,
                V_CHAVE,
                1,
                EV_ID_ENVIA_EMAIL,
                PK_SESSAO.GET_USUARIO_SO,
                PK_SESSAO.GET_MAQUINA,
                PK_SESSAO.GET_CLIENT_INFO,
                PK_SESSAO.GET_PROGRAMA,
                PK_SESSAO.GET_TERMINAL,
                PK_SESSAO.GET_AUDSID);
         END;
      END IF;
      --
   END;

   PROCEDURE LOG_AUT(EV_PROCESSO       IN PK_LOG.T_PROCESSO,
                     EV_MSG            IN VARCHAR2,
                     EV_USUARIO        IN VARCHAR2,
                     EV_PROGRAMA       IN VARCHAR2,
                     EV_CHAVE          IN VARCHAR2,
                     EV_ID_ENVIA_EMAIL IN VARCHAR2) IS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      LOG_(EV_PROCESSO => EV_PROCESSO,
           EV_MSG => EV_MSG,
           EV_USUARIO => EV_USUARIO,
           EV_PROGRAMA => EV_PROGRAMA,
           EV_CHAVE => EV_CHAVE,
           EV_ID_ENVIA_EMAIL => EV_ID_ENVIA_EMAIL,
           EB_TEMPORARY => FALSE);
      COMMIT;
   END LOG_AUT;

   PROCEDURE L(EV_PROCESSO    IN PK_LOG.T_PROCESSO,
               EV_MSG         IN VARCHAR2,
               EV_CHAVE       IN VARCHAR2,
               EB_COMMIT      IN BOOLEAN,
               EB_ENVIA_EMAIL IN BOOLEAN DEFAULT FALSE,
               EB_TEMPORARY   IN BOOLEAN DEFAULT FALSE) IS
      --
      V_CHAVE       VARCHAR2(1000);
      V_ENVIA_EMAIL VARCHAR2(01) := 'N';
      --
   BEGIN
      --
      V_CHAVE := EV_CHAVE;
   
      --
      IF EB_ENVIA_EMAIL THEN
         V_ENVIA_EMAIL := 'S';
      END IF;
   
      --
      IF EB_COMMIT AND
         NOT EB_TEMPORARY THEN
         LOG_AUT(EV_MSG => EV_MSG,
                 EV_PROCESSO => EV_PROCESSO,
                 EV_USUARIO => PK_SESSAO.GET_USUARIO,
                 EV_PROGRAMA => PK_SESSAO.GET_APLICACAO,
                 EV_CHAVE => V_CHAVE,
                 EV_ID_ENVIA_EMAIL => V_ENVIA_EMAIL);
      ELSE
         LOG_(EV_MSG => EV_MSG,
              EV_PROCESSO => EV_PROCESSO,
              EV_USUARIO => PK_SESSAO.GET_USUARIO,
              EV_PROGRAMA => PK_SESSAO.GET_APLICACAO,
              EV_CHAVE => V_CHAVE,
              EV_ID_ENVIA_EMAIL => V_ENVIA_EMAIL,
              EB_TEMPORARY => EB_TEMPORARY);
      END IF;
      --
   END;
   --
END PK_LOG;
/
