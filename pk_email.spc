CREATE OR REPLACE PACKAGE PK_EMAIL IS
   --
   /*
   * STANDARD SOFTWARE SOLUTIONS LTDA.
   * Edson Luis Gonçalez
   * edson.goncalez@gmail.com
   * Junho/2013
   */
   --
   --
   CRLF VARCHAR2(2) := CHR(13) || CHR(10);

   PROCEDURE PROCESSA_ENVIO_AGENDADO;

   PROCEDURE AGENDA_ENVIO(P_SUBJ    IN VARCHAR2,
                          P_BODY    IN VARCHAR2,
                          P_SEQ_LOG IN NUMBER,
                          P_DEST    IN VARCHAR2 DEFAULT NULL);

END PK_EMAIL;
/
