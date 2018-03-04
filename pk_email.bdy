CREATE OR REPLACE PACKAGE BODY PK_EMAIL IS
   --
   /*
   * STANDARD SOFTWARE SOLUTIONS LTDA.
   * Edson Luis Gonçalez
   * edson.goncalez@gmail.com
   * Junho/2013
   */
   --
   FUNCTION FN_RECUP_EMAILS(P_RECIPIENTS IN VARCHAR2) RETURN DBMS_UTILITY.UNCL_ARRAY IS
      V_RET DBMS_UTILITY.UNCL_ARRAY;
      V_TAB DBMS_UTILITY.UNCL_ARRAY;
      I     BINARY_INTEGER;
   BEGIN
      DBMS_UTILITY.COMMA_TO_TABLE(P_RECIPIENTS, I, V_TAB);
   
      FOR J IN V_TAB.FIRST .. V_TAB.LAST
      LOOP
         IF LENGTH(LTRIM(RTRIM(V_TAB(J)))) > 0 THEN
            V_RET(NVL(V_RET.LAST, 0) + 1) := LTRIM(RTRIM(V_TAB(J)));
         END IF;
      END LOOP;
   
      RETURN V_RET;
   END;

   --
   FUNCTION FN_SEND(P_REMET               IN OUT VARCHAR2,
                    P_DEST                IN OUT VARCHAR2,
                    P_SUBJECT             IN VARCHAR2,
                    P_BODY                IN VARCHAR2,
                    P_NUM_MAX_TENT        IN OUT NUMBER,
                    P_INTERV_TENT_MINUTOS IN OUT NUMBER) RETURN VARCHAR2 IS
      --
      V_FROM                 VARCHAR2(4000); -- := 'sender@empresa.com.br';
      V_DS_MAIL_DESTINATARIO VARCHAR2(255);
      V_RECIPIENTS           DBMS_UTILITY.UNCL_ARRAY;
      V_SUBJECT              VARCHAR2(4000); -- := 'Subject teste';
      V_MAIL_HOST            VARCHAR2(4000); -- := '200.245.4.194';
      V_NUM_MAX_TENT         NUMBER;
      V_INTERV_TENT_MINUTOS  NUMBER;
      V_MAIL_CONN            UTL_SMTP.CONNECTION;
      V_INSTANCE             VARCHAR2(4000);
      --
      V_TYPE1MSG   VARCHAR2(512);
      V_TYPE2MSG   UTL_SMTP.REPLY;
      V_TYPE3MSG   VARCHAR2(512);
      V_TYPE3REPLY UTL_SMTP.REPLY;
      --
      V_MAILPORT VARCHAR2(5);
      V_USER     VARCHAR2(64);
      V_PASSWORD VARCHAR2(64);
      V_DOMAIN   VARCHAR2(64);
      V_HOSTNAME VARCHAR2(64);
      --
      V_REPLY   UTL_SMTP.REPLY;
      V_REPLIES UTL_SMTP.REPLIES;
      --
   BEGIN
      BEGIN
         --
         SELECT P.DS_MAIL_REMENTENTE,
                P.DS_MAIL_DESTINATARIO,
                P.DS_SERVIDOR_SMTP,
                P.EMAIL_NUM_MAX_TENT,
                P.EMAIL_INTERV_TENT_MINUTOS,
                P.DS_MAIL_PORT,
                P.DS_MAIL_DOMAIN,
                P.DS_MAIL_USERNAME,
                P.DS_MAIL_PASSWORD,
                P.DS_MAIL_SENDER_HOSTNAME
           INTO V_FROM,
                V_DS_MAIL_DESTINATARIO,
                V_MAIL_HOST,
                V_NUM_MAX_TENT,
                V_INTERV_TENT_MINUTOS,
                V_MAILPORT,
                V_DOMAIN,
                V_USER,
                V_PASSWORD,
                V_HOSTNAME
           FROM PARAMETRO P
          WHERE DS_SERVIDOR_SMTP IS NOT NULL
            AND ROWNUM = 1;
         --
         IF P_REMET IS NULL THEN
            IF V_FROM IS NOT NULL THEN
               P_REMET := V_FROM;
            ELSE
               RAISE_APPLICATION_ERROR(-20001, 'Remetente não informado.');
            END IF;
         END IF;
         --
         IF P_DEST IS NULL THEN
            IF V_DS_MAIL_DESTINATARIO IS NOT NULL THEN
               P_DEST := V_DS_MAIL_DESTINATARIO;
            ELSE
               RAISE_APPLICATION_ERROR(-20001, 'Destinatário não informado.');
            END IF;
         END IF;
         --
         IF P_INTERV_TENT_MINUTOS IS NULL THEN
            IF V_INTERV_TENT_MINUTOS IS NOT NULL THEN
               P_INTERV_TENT_MINUTOS := V_INTERV_TENT_MINUTOS;
            ELSE
               RAISE_APPLICATION_ERROR(-20001, 'Intervalo de reenvio não informado.');
            END IF;
         END IF;
         --
         IF P_NUM_MAX_TENT IS NULL THEN
            IF V_NUM_MAX_TENT IS NOT NULL THEN
               P_NUM_MAX_TENT := V_NUM_MAX_TENT;
            ELSE
               RAISE_APPLICATION_ERROR(-20001, 'Número máximo de tentativas não informado.');
            END IF;
         END IF;
         --
         V_SUBJECT := P_SUBJECT;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'No data found T_PARAMETRO.');
         WHEN OTHERS THEN
            IF SQLCODE <> -20001 THEN
               RAISE_APPLICATION_ERROR(-20001, 'Erro ao recupearr T_PARAMETRO: ' || SQLERRM);
            END IF;
         
            RAISE;
      END;
   
      SELECT INSTANCE_NAME
        INTO V_INSTANCE
        FROM V$INSTANCE;
   
      V_SUBJECT := '[' || UPPER(USER) || '] ' || V_SUBJECT;
   
      --
      -- Open CONN
      V_MAIL_CONN := UTL_SMTP.OPEN_CONNECTION(V_MAIL_HOST, V_MAILPORT);
      --
      -- Send HELLO
      V_REPLIES := UTL_SMTP.EHLO(V_MAIL_CONN, V_HOSTNAME);
      --
      -- Send AUTH
      V_REPLY := UTL_SMTP.COMMAND(V_MAIL_CONN, 'AUTH NTLM');
      --
      -- Generate type1 NTLM Response
      V_TYPE1MSG := PK_NTLM_RESPONSES.GENERATETYPE1MSG(V_DOMAIN, V_HOSTNAME);
      --
      V_TYPE2MSG := UTL_SMTP.COMMAND(V_MAIL_CONN, V_TYPE1MSG);
      --
      -- Generate and send type3 NTLM Response
      V_TYPE3MSG := PK_NTLM_RESPONSES.GENERATETYPE3MSG(V_TYPE2MSG.TEXT, V_USER, V_PASSWORD, V_DOMAIN, V_HOSTNAME);
      --
      V_TYPE3REPLY := UTL_SMTP.COMMAND(V_MAIL_CONN, V_TYPE3MSG);
      --
      -- Set mail from
      V_REPLY := UTL_SMTP.MAIL(V_MAIL_CONN, V_FROM);
      --
      -- Set mail receipt
      V_RECIPIENTS := FN_RECUP_EMAILS(P_DEST);
      FOR K IN V_RECIPIENTS.FIRST .. V_RECIPIENTS.LAST
      LOOP
         V_REPLY := UTL_SMTP.RCPT(V_MAIL_CONN, V_RECIPIENTS(K));
      END LOOP;
      --
      -- Set mail data
      UTL_SMTP.DATA(V_MAIL_CONN,
                    'Date: ' || TO_CHAR(SYSDATE, 'Dy, DD Mon YYYY hh24:mi:ss') || CRLF || 'From: ' || V_FROM || CRLF ||
                    'Subject: ' || V_SUBJECT || CRLF || 'To: ' || P_DEST || CRLF || CRLF || P_BODY || CRLF);
      --
      -- Disconnect
      V_REPLY := UTL_SMTP.QUIT(V_MAIL_CONN);
      --
      RETURN '[OK]';
      --
   EXCEPTION
      WHEN OTHERS THEN
         RETURN '[ERRO] ' || SQLERRM;
   END;

   --
   PROCEDURE AGENDA_ENVIO(P_SUBJ    IN VARCHAR2,
                          P_BODY    IN VARCHAR2,
                          P_SEQ_LOG IN NUMBER,
                          P_DEST    IN VARCHAR2 DEFAULT NULL) IS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      --
      INSERT INTO EMAIL
         (SEQ,
          PRIORIDADE,
          SUBJ_M,
          BODY_M,
          DEST,
          DT_ADDROW,
          ID_ENVIADO,
          SEQ_LOG)
      VALUES
         (EMAIL_SEQ.NEXTVAL,
          0,
          P_SUBJ,
          P_BODY,
          P_DEST,
          SYSDATE,
          'N',
          P_SEQ_LOG);
   
      COMMIT;
   END;

   --
   PROCEDURE PROCESSA_ENVIO_AGENDADO IS
      CURSOR C1 IS
         SELECT E.ROWID,
                E.*
           FROM EMAIL E
          WHERE NVL(E.ID_ENVIADO, 'N') = 'N'
            AND (E.DT_ULT_TENT IS NULL OR E.DT_ULT_TENT + ((1 / 1440) * NVL(INTERV_TENT, 1)) < SYSDATE)
          ORDER BY NVL(PRIORIDADE, 0),
                   SEQ;
   
      V_DEST                VARCHAR2(4000);
      V_REMET               VARCHAR2(4000);
      V_RETORNO             VARCHAR2(4000);
      V_NUM_TENT            NUMBER;
      V_NUM_MAX_TENT        NUMBER;
      V_INTERV_TENT_MINUTOS NUMBER;
   
      V_ID_ENVIADO VARCHAR2(01);
   
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      -- Recupera os emails que ainda não foram  enviados
      FOR REC1 IN C1
      LOOP
         BEGIN
            -- Recupera parametros de tentativas e intervalos.
            -- Se não for informado no momento do agendamento, programa vai atribuir o que
            -- está na tabela de parâmetros, dentro da função que envia o email.
            V_NUM_MAX_TENT        := REC1.NUM_MAX_TENT;
            V_INTERV_TENT_MINUTOS := REC1.INTERV_TENT;
         
            -- Recupera o destinatário
            V_DEST := REC1.DEST;
         
            -- Recupera o remetente
            V_REMET := REC1.REMET;
         
            -- Envia o email
            V_RETORNO := FN_SEND(P_REMET => V_REMET,
                                 P_DEST => V_DEST,
                                 P_SUBJECT => REC1.SUBJ_M,
                                 P_BODY => REC1.BODY_M,
                                 P_NUM_MAX_TENT => V_NUM_MAX_TENT,
                                 P_INTERV_TENT_MINUTOS => V_INTERV_TENT_MINUTOS);
            -- Incrementa 1 ao número de tentativas
            V_NUM_TENT := NVL(REC1.NUM_TENT, 0) + 1;
         
            V_ID_ENVIADO := 'N';
         
            IF V_RETORNO = '[OK]' THEN
               V_ID_ENVIADO := 'S'; -- enviado OK
            ELSE
               IF V_NUM_TENT >= V_NUM_MAX_TENT THEN
                  V_ID_ENVIADO := 'X'; -- excedeu limite tentativas
               END IF;
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               IF SQLCODE <> -20001 THEN
                  V_RETORNO := '[ERRO_EMAIL]: ' || SQLERRM;
               ELSE
                  V_RETORNO := SQLERRM;
               END IF;
         END;
      
         -- Atualiza informações
         UPDATE EMAIL
            SET DEST         = V_DEST,
                REMET        = V_REMET,
                DT_ULT_TENT  = SYSDATE,
                NUM_TENT     = V_NUM_TENT,
                NUM_MAX_TENT = V_NUM_MAX_TENT,
                INTERV_TENT  = V_INTERV_TENT_MINUTOS,
                ID_ENVIADO   = V_ID_ENVIADO,
                MSG_ULT_TENT = V_RETORNO,
                DT_ENVIADO   = DECODE(NVL(V_ID_ENVIADO, 'N'), 'S', SYSDATE, NULL)
          WHERE ROWID = REC1.ROWID;
      
         -- Utilizando autonomous_transaction
         COMMIT;
      END LOOP;
      --
   END;
   --
END PK_EMAIL;
/
