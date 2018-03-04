CREATE OR REPLACE PACKAGE BODY PK_ERRO IS
   --
   /*
   * STANDARD SOFTWARE SOLUTIONS LTDA.
   * Edson Luis Gonçalez
   * edson.goncalez@gmail.com
   * Junho/2013
   */
   --
   --
   -- Retorna a última mensagem de erro conforme o nível passado como parâmetro.
   --
   FUNCTION GET_LAST_MSG(EN_LEVEL IN NUMBER) RETURN VARCHAR2 IS
   BEGIN
      IF EN_LEVEL = PK_ERRO.LEVEL_L THEN
         RETURN PK_ERRO.LAST_MSG_L;
      ELSIF EN_LEVEL = PK_ERRO.LEVEL_M THEN
         RETURN PK_ERRO.LAST_MSG_M;
      ELSIF EN_LEVEL = PK_ERRO.LEVEL_H THEN
         RETURN PK_ERRO.LAST_MSG_H;
      END IF;
   
      RETURN 'Ultima mensagem nao foi identificada. Entre em contato com o Suporte Tecnico!';
   END GET_LAST_MSG;

   --
   -- Retorna a última mensagem de erro (o nível será o padrão que foi lançado)
   --
   FUNCTION GET_LAST_MSG RETURN VARCHAR2 IS
   BEGIN
      RETURN PK_ERRO.LAST_MSG;
   END GET_LAST_MSG;

   --
   -- Retorna a linha onde o erro ocorreu.
   --
   FUNCTION GET_LINHA_BACKTRACE RETURN NUMBER IS
      V_M  VARCHAR2(4000) := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      V_N1 VARCHAR2(10);
   BEGIN
      V_M  := REPLACE(V_M, CHR(10), NULL);
      V_M  := REPLACE(V_M, CHR(13), NULL);
      V_N1 := TRIM(SUBSTR(V_M, INSTR(V_M, ' ', -1), LENGTH(V_M)));
   
      IF V_N1 IS NOT NULL AND
         LENGTH(V_N1) > 0 THEN
         RETURN TO_NUMBER(V_N1);
      ELSE
         RETURN 0;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         RETURN 0;
   END GET_LINHA_BACKTRACE;

   --
   -- Faz a substituição das macro variáveis
   --
   FUNCTION MACRO_SUB(EV_MSG   IN VARCHAR2,
                      EV_PARAM IN PK_UTIL.PARAM_LIST) RETURN VARCHAR2 IS
      V_MSG VARCHAR2(32767);
   BEGIN
      V_MSG := EV_MSG;
   
      IF EV_PARAM IS NOT NULL AND
         EV_PARAM.COUNT > 0 THEN
         FOR I IN EV_PARAM.FIRST .. EV_PARAM.LAST
         LOOP
            V_MSG := REPLACE(V_MSG, '%' || I, NVL(EV_PARAM(I), '<NULL>'));
         END LOOP;
      END IF;
   
      RETURN V_MSG;
   END;

   --
   -- Inicializa as variáveis
   --

   FUNCTION INIT(EV_PROCESSO IN PK_LOG.T_PROCESSO) RETURN PK_LOG.T_PROCESSO IS
   BEGIN
      IF PARAM_VALUE.EXISTS(EV_PROCESSO) THEN
         PARAM_VALUE.DELETE(EV_PROCESSO);
      END IF;
   
      IF VAR_VALUE.EXISTS(EV_PROCESSO) THEN
         VAR_VALUE.DELETE(EV_PROCESSO);
      END IF;
   
      LAST_SQLCODE                := NULL;
      LAST_MSG_L                  := NULL;
      LAST_MSG_M                  := NULL;
      LAST_MSG_H                  := NULL;
      LAST_FORMAT_CALL_STACK      := NULL;
      LAST_FORMAT_ERROR_BACKTRACE := NULL;
      RETURN LOWER(EV_PROCESSO);
   END INIT;

   --
   -- Registra os parâmetros da procedure/function.
   -- Utilizados no nível de mensagem "H" (high)
   --
   PROCEDURE REG_PARAM(EV_PROCESSO    IN PK_LOG.T_PROCESSO,
                       EV_PARAM_NAME  IN VARCHAR2,
                       EV_PARAM_VALUE IN VARCHAR2,
                       EB_CAN_BE_NULL IN BOOLEAN DEFAULT TRUE) IS
   BEGIN
      -- Verifica se processo foi informado
      IF EV_PROCESSO IS NULL THEN
         RAISE_APPLICATION_ERROR(-20001, '(pk_erro.reg_param): Parâmetro "ev_processo" está vazio (NULL) !');
      END IF;
   
      -- Verifica se parâmetro foi informado
      IF EV_PARAM_NAME IS NULL THEN
         RAISE_APPLICATION_ERROR(-20001, '(pk_erro.reg_param): Parâmetro "ev_param_name" está vazio (NULL) !');
      END IF;
   
      IF NOT EB_CAN_BE_NULL AND
         EB_CAN_BE_NULL IS NULL THEN
         RAISE_APPLICATION_ERROR(-20001,
                                 'Parâmetro "' || EV_PARAM_NAME || '" está vazio (NULL) dentro do processo "' || EV_PROCESSO ||
                                 '" !');
      END IF;
   
      -- Verifica se o processo foi informado
      PARAM_VALUE(EV_PROCESSO)(EV_PARAM_NAME) := EV_PARAM_VALUE;
      --
   END REG_PARAM;

   --
   -- Registra os valores dos parâmetros da procedure/function.
   -- Utilizados no nível de mensagem "H" (high)
   --
   PROCEDURE REG_VAR(EV_PROCESSO  IN PK_LOG.T_PROCESSO,
                     EV_VAR_NAME  IN VARCHAR2,
                     EV_VAR_VALUE IN VARCHAR2) IS
   BEGIN
      -- Verifica se processo foi informado
      IF EV_PROCESSO IS NULL THEN
         RAISE_APPLICATION_ERROR(-20001, '(pk_erro.reg_var): Parâmetro "ev_processo" está vazio (NULL) !');
      END IF;
   
      -- Verifica se parâmetro foi informado
      IF EV_VAR_NAME IS NULL THEN
         RAISE_APPLICATION_ERROR(-20001, '(pk_erro.reg_var): Parâmetro "ev_var_name" está vazio (NULL) !');
      END IF;
   
      -- Verifica se o processo foi informado
      VAR_VALUE(EV_PROCESSO)(EV_VAR_NAME) := EV_VAR_VALUE;
      --
   END REG_VAR;

   --
   -- Formata e recupera os nomes dos parâmetros.
   -- Utilizados no nível de mensagem "H" (high)
   --
   FUNCTION GET_PARAMS_FMT(EV_PROCESSO IN VARCHAR2) RETURN VARCHAR2 IS
      V_RETURN VARCHAR2(32767);
      V_INDICE VARCHAR2(32767);
   BEGIN
      IF PARAM_VALUE.COUNT > 0 AND
         PARAM_VALUE.EXISTS(EV_PROCESSO) THEN
         V_INDICE := PARAM_VALUE(EV_PROCESSO).FIRST;
      
         LOOP
            IF V_RETURN IS NOT NULL THEN
               V_RETURN := V_RETURN || ' / ';
            END IF;
         
            V_RETURN := V_RETURN || V_INDICE || '=' || NVL(PARAM_VALUE(EV_PROCESSO) (V_INDICE), '<NULL>');
            V_INDICE := PARAM_VALUE(EV_PROCESSO).NEXT(V_INDICE);
            EXIT WHEN V_INDICE IS NULL;
         END LOOP;
      END IF;
   
      RETURN 'Params( ' || NVL(V_RETURN, '<NULL>') || ' )';
   END GET_PARAMS_FMT;

   --
   -- Formata e recupera os valores dos parâmetros.
   -- Utilizados no nível de mensagem "H" (high)
   --
   FUNCTION GET_VARS_FMT(EV_PROCESSO IN VARCHAR2) RETURN VARCHAR2 IS
      V_RETURN VARCHAR2(32767);
   BEGIN
      IF VAR_VALUE.COUNT > 0 AND
         VAR_VALUE.EXISTS(EV_PROCESSO) THEN
         FOR I IN VAR_VALUE(EV_PROCESSO).FIRST .. VAR_VALUE(EV_PROCESSO).LAST
         LOOP
            IF V_RETURN IS NOT NULL THEN
               V_RETURN := V_RETURN || ' / ';
            END IF;
         
            V_RETURN := V_RETURN || I || '=' || NVL(VAR_VALUE(EV_PROCESSO) (I), '<NULL>');
         END LOOP;
      END IF;
   
      RETURN 'Vars( ' || NVL(V_RETURN, '<NULL>') || ' )';
   END GET_VARS_FMT;

   --
   -- Processa o tratamento ou lançamento da exception
   --
   PROCEDURE ERRO(EV_PROCESSO   IN PK_LOG.T_PROCESSO,
                  EN_LINHA      IN NUMBER,
                  EV_FASE       IN PK_ERRO.T_FASE,
                  EV_CD_ERRO    IN PK_ERRO.T_CD_ERRO DEFAULT NULL,
                  ET_VAR_ERRO   IN PK_UTIL.PARAM_LIST DEFAULT NULL,
                  EB_RAISE      IN BOOLEAN DEFAULT TRUE,
                  EB_LOG        IN BOOLEAN DEFAULT FALSE,
                  EB_LOG_EMAIL  IN BOOLEAN DEFAULT FALSE,
                  EV_LOG_CHAVE  IN PK_LOG.T_CHAVE DEFAULT NULL,
                  EN_LEVEL      IN NUMBER DEFAULT NULL,
                  EB_SKIP_EQUAL IN BOOLEAN DEFAULT TRUE) IS
      --
      CURSOR C_TP_ERRO(EV_CD_ERRO IN PK_ERRO.T_CD_ERRO) IS
         SELECT *
           FROM TIPO_ERRO
          WHERE CD = EV_CD_ERRO;
   
      R_C_TP_ERRO   C_TP_ERRO%ROWTYPE;
      VV_MSG        VARCHAR2(2048);
      VV_CD_ERRO    PK_ERRO.T_CD_ERRO;
      VT_VAR_ERRO   PK_UTIL.PARAM_LIST;
      VV_MENSAGEM_L TIPO_ERRO.MENSAGEM%TYPE;
      VV_MENSAGEM_M TIPO_ERRO.MENSAGEM%TYPE;
      VV_MENSAGEM_H TIPO_ERRO.MENSAGEM%TYPE;
      VV_LEVEL      TIPO_ERRO.DM_LEVEL%TYPE;
      VV_GERA_LOG   TIPO_ERRO.GERA_LOG%TYPE;
      VV_GERA_EMAIL TIPO_ERRO.GERA_EMAIL%TYPE;
   BEGIN
      -- Inicio
      VV_CD_ERRO    := EV_CD_ERRO;
      VT_VAR_ERRO   := ET_VAR_ERRO;
      VV_GERA_LOG   := 'N';
      VV_GERA_EMAIL := 'N';
   
      -- Verifica se erro não foi informado.
      IF EV_CD_ERRO IS NULL THEN
         IF VT_VAR_ERRO IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20001,
                                    '(pk_erro.erro): Variáveis macro não devem ser informadas quando código do erro for omitido !');
         END IF;
      
         VV_CD_ERRO  := SQLCODE;
         VT_VAR_ERRO := PK_UTIL.PARAM_LIST(PK_UTIL.REMOVE_QUEBRA(SQLERRM));
      END IF;
   
      OPEN C_TP_ERRO(VV_CD_ERRO);
   
      FETCH C_TP_ERRO
         INTO R_C_TP_ERRO;
   
      IF C_TP_ERRO%NOTFOUND THEN
         CLOSE C_TP_ERRO;
      
         OPEN C_TP_ERRO('GENERIC');
      
         FETCH C_TP_ERRO
            INTO R_C_TP_ERRO;
      
         IF C_TP_ERRO%NOTFOUND THEN
            CLOSE C_TP_ERRO;
         
            RAISE_APPLICATION_ERROR(-20001, '(pk_erro.erro): Tipo de erro não encontrado !');
         END IF;
      END IF;
   
      CLOSE C_TP_ERRO;
   
      -- Verifica se vai gerar o log do erro
      IF EB_LOG OR
         UPPER(NVL(R_C_TP_ERRO.GERA_LOG, 'N')) = 'S' THEN
         VV_GERA_LOG := 'S';
      END IF;
   
      -- Verifica se vai enviar e-mail do log do erro
      IF EB_LOG_EMAIL OR
         UPPER(NVL(R_C_TP_ERRO.GERA_EMAIL, 'N')) = 'S' THEN
         VV_GERA_EMAIL := 'S';
      END IF;
   
      -- Para que essa rotina funcione é extremamente necessário que seja feita
      -- a inicialização correta das variáveis no início de cada procedure/function.
      -- Se isso não for feito, a rotina abaixo poderá interpretar uma situação
      -- que não corresponde à correta, pegando o erro de algum processo anterior.
      IF EB_SKIP_EQUAL AND
         R_C_TP_ERRO.SQLCODEX = NVL(PK_ERRO.LAST_SQLCODE, -9999999999) THEN
         RETURN;
      END IF;
   
      -- Trata variáveis dentro da mensagem
      R_C_TP_ERRO.MENSAGEM := TRIM(R_C_TP_ERRO.MENSAGEM);
   
      -- Low
      VV_MENSAGEM_L := PK_ERRO.MACRO_SUB(R_C_TP_ERRO.MENSAGEM, VT_VAR_ERRO);
   
      -- Mid
      VV_MENSAGEM_M := VV_MENSAGEM_L;
   
      -- Trata variável mensagem de erro
      IF INSTR(R_C_TP_ERRO.PATTERN, '%msg_erro%') > 0 THEN
         VV_MENSAGEM_M := REPLACE(R_C_TP_ERRO.PATTERN, '%msg_erro%', VV_MENSAGEM_L);
      ELSIF INSTR(R_C_TP_ERRO.PATTERN, '%MSG_ERRO%') > 0 THEN
         VV_MENSAGEM_M := REPLACE(R_C_TP_ERRO.PATTERN, '%MSG_ERRO%', UPPER(VV_MENSAGEM_L));
      ELSE
         RAISE_APPLICATION_ERROR(-20001, 'Variável %msg_erro% nao informada para o erro ' || R_C_TP_ERRO.CD || '. Verifique!');
      END IF;
   
      -- Trata variável linha que ocorreu o erro
      VV_MENSAGEM_M := REPLACE(VV_MENSAGEM_M, '%linha%', EN_LINHA);
      VV_MENSAGEM_M := REPLACE(VV_MENSAGEM_M, '%LINHA%', EN_LINHA);
   
      -- Trata variável processo que ocorreu o erro
      VV_MENSAGEM_M := REPLACE(VV_MENSAGEM_M, '%processo%', LOWER(EV_PROCESSO));
      VV_MENSAGEM_M := REPLACE(VV_MENSAGEM_M, '%PROCESSO%', UPPER(EV_PROCESSO));
   
      -- Trata variável fase que ocorreu o erro
      VV_MENSAGEM_M := REPLACE(VV_MENSAGEM_M, '%fase%', LOWER(EV_FASE));
      VV_MENSAGEM_M := REPLACE(VV_MENSAGEM_M, '%FASE%', UPPER(EV_FASE));
   
      -- Trata variável código do erro
      VV_MENSAGEM_M := REPLACE(VV_MENSAGEM_M, '%cd_erro%', LOWER(R_C_TP_ERRO.CD));
      VV_MENSAGEM_M := REPLACE(VV_MENSAGEM_M, '%CD_ERRO%', UPPER(R_C_TP_ERRO.CD));
   
      -- High
      VV_MENSAGEM_H := VV_MENSAGEM_M || ' {' || GET_PARAMS_FMT(EV_PROCESSO) || ' | ' || GET_VARS_FMT(EV_PROCESSO) || ' }';
   
      -- Seta última mensagem (permite recuperar para exibir novamente o último erro.
      -- A vantagem disso é poder pesquisar a mensagem completa, mesmo que tenha dado somente a mensagem simples.
      PK_ERRO.LAST_MSG_L := VV_MENSAGEM_L;
      PK_ERRO.LAST_MSG_M := VV_MENSAGEM_M;
      PK_ERRO.LAST_MSG_H := VV_MENSAGEM_H;
   
      VV_LEVEL := NVL(EN_LEVEL, R_C_TP_ERRO.DM_LEVEL);
   
      IF VV_LEVEL = PK_ERRO.LEVEL_H THEN
         VV_MSG := VV_MENSAGEM_H;
      ELSIF VV_LEVEL = PK_ERRO.LEVEL_M THEN
         VV_MSG := VV_MENSAGEM_M;
      ELSIF VV_LEVEL = PK_ERRO.LEVEL_L THEN
         VV_MSG := VV_MENSAGEM_L;
      ELSE
         RAISE_APPLICATION_ERROR(-20001, '(pk_erro.erro) -> Nível não identificado');
      END IF;
   
      PK_ERRO.LAST_FORMAT_CALL_STACK      := DBMS_UTILITY.FORMAT_CALL_STACK;
      PK_ERRO.LAST_FORMAT_ERROR_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
   
      PK_ERRO.LAST_SQLCODE := R_C_TP_ERRO.SQLCODEX;
      PK_ERRO.LAST_MSG     := VV_MSG;
   
      -- Tratamento para geração do LOG caso tenha optado
      IF VV_GERA_LOG = 'S' OR
         VV_GERA_EMAIL = 'S' THEN
         PK_LOG.L(EV_PROCESSO => EV_PROCESSO,
                  EV_MSG => VV_MSG,
                  EB_ENVIA_EMAIL => PK_UTIL.VARCHAR2_TO_BOOL(VV_GERA_EMAIL, 'S', 'N'),
                  EV_CHAVE => EV_LOG_CHAVE);
      END IF;
   
      IF EB_RAISE THEN
         RAISE_APPLICATION_ERROR(PK_ERRO.LAST_SQLCODE, VV_MSG);
      END IF;
      --
   END ERRO;

   --
   -- Procedure utilizada para lançar uma exception.
   --
   PROCEDURE GERA_EXC(EV_PROCESSO   IN PK_LOG.T_PROCESSO,
                      EN_LINHA      IN NUMBER,
                      EV_FASE       IN PK_ERRO.T_FASE,
                      EV_CD_ERRO    IN PK_ERRO.T_CD_ERRO DEFAULT NULL,
                      ET_VAR_ERRO   IN PK_UTIL.PARAM_LIST DEFAULT NULL,
                      EB_RAISE      IN BOOLEAN DEFAULT TRUE,
                      EB_LOG        IN BOOLEAN DEFAULT FALSE,
                      EB_LOG_EMAIL  IN BOOLEAN DEFAULT FALSE,
                      EV_LOG_CHAVE  IN PK_LOG.T_CHAVE DEFAULT NULL,
                      EN_LEVEL      IN NUMBER DEFAULT NULL,
                      EB_SKIP_EQUAL IN BOOLEAN DEFAULT TRUE) IS
   BEGIN
      ERRO(EV_PROCESSO => EV_PROCESSO,
           EN_LINHA => EN_LINHA,
           EV_FASE => EV_FASE,
           EV_CD_ERRO => EV_CD_ERRO,
           ET_VAR_ERRO => ET_VAR_ERRO,
           EB_RAISE => EB_RAISE,
           EB_LOG => EB_LOG,
           EB_LOG_EMAIL => EB_LOG_EMAIL,
           EV_LOG_CHAVE => EV_LOG_CHAVE,
           EN_LEVEL => EN_LEVEL,
           EB_SKIP_EQUAL => EB_SKIP_EQUAL);
   END GERA_EXC;

   --
   -- Procedure utilizada para tratar uma exception ocorrida.
   --
   PROCEDURE TRATA_EXC(EV_PROCESSO   IN PK_LOG.T_PROCESSO,
                       EV_FASE       IN PK_ERRO.T_FASE,
                       EV_CD_ERRO    IN PK_ERRO.T_CD_ERRO DEFAULT NULL,
                       ET_VAR_ERRO   IN PK_UTIL.PARAM_LIST DEFAULT NULL,
                       EB_RAISE      IN BOOLEAN DEFAULT TRUE,
                       EB_LOG        IN BOOLEAN DEFAULT FALSE,
                       EB_LOG_EMAIL  IN BOOLEAN DEFAULT FALSE,
                       EV_LOG_CHAVE  IN PK_LOG.T_CHAVE DEFAULT NULL,
                       EN_LEVEL      IN NUMBER DEFAULT NULL,
                       EB_SKIP_EQUAL IN BOOLEAN DEFAULT TRUE) IS
   BEGIN
      ERRO(EV_PROCESSO => EV_PROCESSO,
           EN_LINHA => GET_LINHA_BACKTRACE,
           EV_FASE => EV_FASE,
           EV_CD_ERRO => EV_CD_ERRO,
           ET_VAR_ERRO => ET_VAR_ERRO,
           EB_RAISE => EB_RAISE,
           EB_LOG => EB_LOG,
           EB_LOG_EMAIL => EB_LOG_EMAIL,
           EV_LOG_CHAVE => EV_LOG_CHAVE,
           EN_LEVEL => EN_LEVEL,
           EB_SKIP_EQUAL => EB_SKIP_EQUAL);
   END TRATA_EXC;
   --
END PK_ERRO;
/
