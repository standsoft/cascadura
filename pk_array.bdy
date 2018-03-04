PACKAGE BODY PK_ARRAY IS

   PROCEDURE DUMP_ARRAY(ET_TAB_INT_NUM IN PK_ARRAY.T_TAB_INT_NUM,
                        EV_HIST_IND    IN VARCHAR2 DEFAULT NULL,
                        EN_TYPE        IN NUMBER DEFAULT 1) IS
      VV_HIST_IND VARCHAR2(4000);
      VV_DUMP_MSG VARCHAR2(4000);
      I           NUMBER;
   BEGIN
      I := NVL(ET_TAB_INT_NUM.FIRST, 0);
   
      IF I = 0 THEN
         RETURN;
      END IF;
   
      LOOP
         VV_HIST_IND := NVL(EV_HIST_IND, '') || '(' || I || ')';
         VV_DUMP_MSG := VV_HIST_IND || '=' || ET_TAB_INT_NUM(I);
      
         IF EN_TYPE = 0 THEN
         
            DBMS_OUTPUT.PUT_LINE(VV_DUMP_MSG);
         ELSIF EN_TYPE = 1 THEN
         
            PK_LOG.L(EV_PROCESSO => NULL, EV_MSG => VV_DUMP_MSG, EB_TEMPORARY => TRUE);
         END IF;
      
         IF I = ET_TAB_INT_NUM.LAST THEN
            EXIT;
         ELSE
            I := ET_TAB_INT_NUM.NEXT(I);
         END IF;
      END LOOP;
   END DUMP_ARRAY;

   PROCEDURE DUMP_ARRAY(ET_TAB_INT_NUM IN PK_ARRAY.T_TAB_INT_NUM2,
                        EV_HIST_IND    IN VARCHAR2 DEFAULT NULL,
                        EN_TYPE        IN NUMBER DEFAULT 1) IS
      VV_HIST_IND VARCHAR2(4000);
      I           NUMBER;
   BEGIN
      I := NVL(ET_TAB_INT_NUM.FIRST, 0);
   
      IF I = 0 THEN
         RETURN;
      END IF;
   
      LOOP
         VV_HIST_IND := NVL(EV_HIST_IND, '') || '(' || I || ')';
         DUMP_ARRAY(ET_TAB_INT_NUM(I), VV_HIST_IND, EN_TYPE);
      
         IF I = ET_TAB_INT_NUM.LAST THEN
            EXIT;
         ELSE
            I := ET_TAB_INT_NUM.NEXT(I);
         END IF;
      END LOOP;
   END DUMP_ARRAY;

   PROCEDURE DUMP_ARRAY(ET_TAB_INT_NUM IN PK_ARRAY.T_TAB_INT_NUM3,
                        EV_HIST_IND    IN VARCHAR2 DEFAULT NULL,
                        EN_TYPE        IN NUMBER DEFAULT 1) IS
      VV_HIST_IND VARCHAR2(4000);
      I           NUMBER;
   BEGIN
      I := NVL(ET_TAB_INT_NUM.FIRST, 0);
   
      IF I = 0 THEN
         RETURN;
      END IF;
   
      LOOP
         VV_HIST_IND := NVL(EV_HIST_IND, '') || '(' || I || ')';
         DUMP_ARRAY(ET_TAB_INT_NUM(I), VV_HIST_IND, EN_TYPE);
      
         IF I = ET_TAB_INT_NUM.LAST THEN
            EXIT;
         ELSE
            I := ET_TAB_INT_NUM.NEXT(I);
         END IF;
      END LOOP;
   END DUMP_ARRAY;

   PROCEDURE DUMP_ARRAY(ET_TAB_INT_NUM IN PK_ARRAY.T_TAB_INT_NUM4,
                        EV_HIST_IND    IN VARCHAR2 DEFAULT NULL,
                        EN_TYPE        IN NUMBER DEFAULT 1) IS
      VV_HIST_IND VARCHAR2(4000);
      I           NUMBER;
   BEGIN
      I := NVL(ET_TAB_INT_NUM.FIRST, 0);
   
      IF I = 0 THEN
         RETURN;
      END IF;
   
      LOOP
         VV_HIST_IND := NVL(EV_HIST_IND, '') || '(' || I || ')';
         DUMP_ARRAY(ET_TAB_INT_NUM(I), VV_HIST_IND, EN_TYPE);
      
         IF I = ET_TAB_INT_NUM.LAST THEN
            EXIT;
         ELSE
            I := ET_TAB_INT_NUM.NEXT(I);
         END IF;
      END LOOP;
   END DUMP_ARRAY;

   PROCEDURE DUMP_ARRAY(ET_TAB_INT_NUM IN PK_ARRAY.T_TAB_INT_NUM5,
                        EV_HIST_IND    IN VARCHAR2 DEFAULT NULL,
                        EN_TYPE        IN NUMBER DEFAULT 1) IS
      VV_HIST_IND VARCHAR2(4000);
      I           NUMBER;
   BEGIN
      I := NVL(ET_TAB_INT_NUM.FIRST, 0);
   
      IF I = 0 THEN
         RETURN;
      END IF;
   
      LOOP
         VV_HIST_IND := NVL(EV_HIST_IND, '') || '(' || I || ')';
         DUMP_ARRAY(ET_TAB_INT_NUM(I), VV_HIST_IND, EN_TYPE);
      
         IF I = ET_TAB_INT_NUM.LAST THEN
            EXIT;
         ELSE
            I := ET_TAB_INT_NUM.NEXT(I);
         END IF;
      END LOOP;
   END DUMP_ARRAY;

   PROCEDURE DUMP_ARRAY(ET_TAB_CHAR_NUM IN PK_ARRAY.T_TAB_CHAR_NUM,
                        EV_HIST_IND     IN VARCHAR2 DEFAULT NULL,
                        EN_TYPE         IN NUMBER DEFAULT 1) IS
      VV_HIST_IND VARCHAR2(4000);
      VV_DUMP_MSG VARCHAR2(4000);
      I           NUMBER;
   BEGIN
      I := NVL(ET_TAB_CHAR_NUM.FIRST, 0);
   
      IF I = 0 THEN
         RETURN;
      END IF;
   
      LOOP
         VV_HIST_IND := NVL(EV_HIST_IND, '') || '(' || I || ')';
         VV_DUMP_MSG := VV_HIST_IND || '=' || ET_TAB_CHAR_NUM(I);
      
         IF EN_TYPE = 0 THEN
         
            DBMS_OUTPUT.PUT_LINE(VV_DUMP_MSG);
         ELSIF EN_TYPE = 1 THEN
         
            PK_LOG.L(EV_PROCESSO => NULL, EV_MSG => VV_DUMP_MSG, EB_TEMPORARY => TRUE);
         END IF;
      
         IF I = ET_TAB_CHAR_NUM.LAST THEN
            EXIT;
         ELSE
            I := ET_TAB_CHAR_NUM.NEXT(I);
         END IF;
      END LOOP;
   END DUMP_ARRAY;

   PROCEDURE DUMP_ARRAY(ET_TAB_CHAR_NUM IN PK_ARRAY.T_TAB_CHAR_NUM2,
                        EV_HIST_IND     IN VARCHAR2 DEFAULT NULL,
                        EN_TYPE         IN NUMBER DEFAULT 1) IS
      VV_HIST_IND VARCHAR2(4000);
      I           NUMBER;
   BEGIN
      I := NVL(ET_TAB_CHAR_NUM.FIRST, 0);
   
      IF I = 0 THEN
         RETURN;
      END IF;
   
      LOOP
         VV_HIST_IND := NVL(EV_HIST_IND, '') || '(' || I || ')';
         DUMP_ARRAY(ET_TAB_CHAR_NUM(I), VV_HIST_IND, EN_TYPE);
      
         IF I = ET_TAB_CHAR_NUM.LAST THEN
            EXIT;
         ELSE
            I := ET_TAB_CHAR_NUM.NEXT(I);
         END IF;
      END LOOP;
   END DUMP_ARRAY;

   PROCEDURE DUMP_ARRAY(ET_TAB_CHAR_NUM IN PK_ARRAY.T_TAB_CHAR_NUM3,
                        EV_HIST_IND     IN VARCHAR2 DEFAULT NULL,
                        EN_TYPE         IN NUMBER DEFAULT 1) IS
      VV_HIST_IND VARCHAR2(4000);
      I           NUMBER;
   BEGIN
      I := NVL(ET_TAB_CHAR_NUM.FIRST, 0);
   
      IF I = 0 THEN
         RETURN;
      END IF;
   
      LOOP
         VV_HIST_IND := NVL(EV_HIST_IND, '') || '(' || I || ')';
         DUMP_ARRAY(ET_TAB_CHAR_NUM(I), VV_HIST_IND, EN_TYPE);
      
         IF I = ET_TAB_CHAR_NUM.LAST THEN
            EXIT;
         ELSE
            I := ET_TAB_CHAR_NUM.NEXT(I);
         END IF;
      END LOOP;
   END DUMP_ARRAY;

   PROCEDURE DUMP_ARRAY(ET_TAB_CHAR_NUM IN PK_ARRAY.T_TAB_CHAR_NUM4,
                        EV_HIST_IND     IN VARCHAR2 DEFAULT NULL,
                        EN_TYPE         IN NUMBER DEFAULT 1) IS
      VV_HIST_IND VARCHAR2(4000);
      I           NUMBER;
   BEGIN
      I := NVL(ET_TAB_CHAR_NUM.FIRST, 0);
   
      IF I = 0 THEN
         RETURN;
      END IF;
   
      LOOP
         VV_HIST_IND := NVL(EV_HIST_IND, '') || '(' || I || ')';
         DUMP_ARRAY(ET_TAB_CHAR_NUM(I), VV_HIST_IND, EN_TYPE);
      
         IF I = ET_TAB_CHAR_NUM.LAST THEN
            EXIT;
         ELSE
            I := ET_TAB_CHAR_NUM.NEXT(I);
         END IF;
      END LOOP;
   END DUMP_ARRAY;

   PROCEDURE DUMP_ARRAY(ET_TAB_CHAR_NUM IN PK_ARRAY.T_TAB_CHAR_NUM5,
                        EV_HIST_IND     IN VARCHAR2 DEFAULT NULL,
                        EN_TYPE         IN NUMBER DEFAULT 1) IS
      VV_HIST_IND VARCHAR2(4000);
      I           NUMBER;
   BEGIN
      I := NVL(ET_TAB_CHAR_NUM.FIRST, 0);
   
      IF I = 0 THEN
         RETURN;
      END IF;
   
      LOOP
         VV_HIST_IND := NVL(EV_HIST_IND, '') || '(' || I || ')';
         DUMP_ARRAY(ET_TAB_CHAR_NUM(I), VV_HIST_IND, EN_TYPE);
      
         IF I = ET_TAB_CHAR_NUM.LAST THEN
            EXIT;
         ELSE
            I := ET_TAB_CHAR_NUM.NEXT(I);
         END IF;
      END LOOP;
   END DUMP_ARRAY;

END PK_ARRAY;
