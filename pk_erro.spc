CREATE OR REPLACE PACKAGE PK_ERRO IS
   --
   /*
   * STANDARD SOFTWARE SOLUTIONS LTDA.
   * Edson Luis Gonçalez
   * edson.goncalez@gmail.com
   * Junho/2013
   */
   --
   --
   -- =================
   -- Tipos e Sub Tipos
   -- =================
   --
   SUBTYPE T_FASE IS VARCHAR2(100);

   SUBTYPE T_CD_ERRO IS TIPO_ERRO.CD%TYPE;

   --
   -- ==========
   -- Constantes
   -- ==========
   --
   -- Codigo de Erro
   CD_ERRO_ROWCOUNT_0        CONSTANT T_CD_ERRO := 'ROWCOUNT_0';
   CD_ERRO_UPDATE_0          CONSTANT T_CD_ERRO := 'UPDATE_0';
   CD_ERRO_DUP_VAL_ON_INDEX  CONSTANT T_CD_ERRO := 'DUP_VAL_ON_INDEX';
   CD_ERRO_LOCK              CONSTANT T_CD_ERRO := 'LOCK';
   CD_ERRO_FILIAL_NULL       CONSTANT T_CD_ERRO := 'FILIAL_NULL';
   CD_ERRO_FUNC_NULL         CONSTANT T_CD_ERRO := 'FUNCIONARIO_NULL';
   CD_ERRO_APL_NULL          CONSTANT T_CD_ERRO := 'APLICACAO_NULL';
   CD_ERRO_VL_MIN_EXCED      CONSTANT T_CD_ERRO := 'VALOR_MIN_EXCEDIDO';
   CD_ERRO_VL_MAX_EXCED      CONSTANT T_CD_ERRO := 'VALOR_MAX_EXCEDIDO';
   CD_ERRO_VL_INVALIDO       CONSTANT T_CD_ERRO := 'VALOR_INVALIDO';
   CD_ERRO_APPLICATION_ERROR CONSTANT T_CD_ERRO := 'APPLICATION_ERROR';

   --
   -- Nível Mensagem
   LEVEL_L CONSTANT NUMBER := 1; -- Low
   LEVEL_M CONSTANT NUMBER := 2; -- Mid
   LEVEL_H CONSTANT NUMBER := 3; -- High
   --
   -- Fases do processo
   VC_F_CK_ERRO_GLOBAL      CONSTANT T_FASE := 'CHECK_ERRO_GLOBAL';
   VC_F_EXCEPTION_GERAL     CONSTANT T_FASE := 'EXCEPTION_GERAL';
   VC_F_EXCEPTION_PRINCIPAL CONSTANT T_FASE := 'EXCEPTION_PRINCIPAL';
   --
   -- =================
   -- Variáveis Globais
   -- =================
   --
   LAST_SQLCODE                NUMBER;
   PARAM_VALUE                 PK_ARRAY.T_TAB_CHAR_CHAR2;
   VAR_VALUE                   PK_ARRAY.T_TAB_CHAR_CHAR2;
   LAST_MSG_L                  TIPO_ERRO.MENSAGEM%TYPE;
   LAST_MSG_M                  TIPO_ERRO.MENSAGEM%TYPE;
   LAST_MSG_H                  TIPO_ERRO.MENSAGEM%TYPE;
   LAST_MSG                    TIPO_ERRO.MENSAGEM%TYPE;
   LAST_FORMAT_CALL_STACK      VARCHAR2(32767);
   LAST_FORMAT_ERROR_BACKTRACE VARCHAR2(32767);

   FUNCTION INIT(EV_PROCESSO IN PK_LOG.T_PROCESSO) RETURN PK_LOG.T_PROCESSO;

   FUNCTION GET_LAST_MSG(EN_LEVEL IN NUMBER) RETURN VARCHAR2;

   FUNCTION GET_LAST_MSG RETURN VARCHAR2;

   PROCEDURE REG_PARAM(EV_PROCESSO    IN PK_LOG.T_PROCESSO,
                       EV_PARAM_NAME  IN VARCHAR2,
                       EV_PARAM_VALUE IN VARCHAR2,
                       EB_CAN_BE_NULL IN BOOLEAN DEFAULT TRUE);

   PROCEDURE REG_VAR(EV_PROCESSO  IN PK_LOG.T_PROCESSO,
                     EV_VAR_NAME  IN VARCHAR2,
                     EV_VAR_VALUE VARCHAR2);

   FUNCTION MACRO_SUB(EV_MSG   IN VARCHAR2,
                      EV_PARAM IN PK_UTIL.PARAM_LIST) RETURN VARCHAR2;

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
                      EB_SKIP_EQUAL IN BOOLEAN DEFAULT TRUE);

   PROCEDURE TRATA_EXC(EV_PROCESSO   IN PK_LOG.T_PROCESSO,
                       EV_FASE       IN PK_ERRO.T_FASE,
                       EV_CD_ERRO    IN PK_ERRO.T_CD_ERRO DEFAULT NULL,
                       ET_VAR_ERRO   IN PK_UTIL.PARAM_LIST DEFAULT NULL,
                       EB_RAISE      IN BOOLEAN DEFAULT TRUE,
                       EB_LOG        IN BOOLEAN DEFAULT FALSE,
                       EB_LOG_EMAIL  IN BOOLEAN DEFAULT FALSE,
                       EV_LOG_CHAVE  IN PK_LOG.T_CHAVE DEFAULT NULL,
                       EN_LEVEL      IN NUMBER DEFAULT NULL,
                       EB_SKIP_EQUAL IN BOOLEAN DEFAULT TRUE);
   --
END PK_ERRO;
/
