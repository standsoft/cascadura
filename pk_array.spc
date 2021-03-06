PACKAGE PK_ARRAY IS

   TYPE TYPE_R_DUMP_ARRAY1 IS RECORD(
      I1 VARCHAR2(1000),
      V  VARCHAR2(32767));

   TYPE TYPE_T_DUMP_ARRAY1 IS TABLE OF TYPE_R_DUMP_ARRAY1;

   TYPE TYPE_R_DUMP_ARRAY2 IS RECORD(
      I1 VARCHAR2(1000),
      I2 VARCHAR2(1000),
      V  VARCHAR2(32767));

   TYPE TYPE_T_DUMP_ARRAY2 IS TABLE OF TYPE_R_DUMP_ARRAY2;

   TYPE TYPE_R_DUMP_ARRAY3 IS RECORD(
      I1 VARCHAR2(1000),
      I2 VARCHAR2(1000),
      I3 VARCHAR2(1000),
      V  VARCHAR2(32767));

   TYPE TYPE_T_DUMP_ARRAY3 IS TABLE OF TYPE_R_DUMP_ARRAY3;

   TYPE TYPE_R_DUMP_ARRAY4 IS RECORD(
      I1 VARCHAR2(1000),
      I2 VARCHAR2(1000),
      I3 VARCHAR2(1000),
      I4 VARCHAR2(1000),
      V  VARCHAR2(32767));

   TYPE TYPE_T_DUMP_ARRAY4 IS TABLE OF TYPE_R_DUMP_ARRAY4;

   TYPE TYPE_R_DUMP_ARRAY5 IS RECORD(
      I1 VARCHAR2(1000),
      I2 VARCHAR2(1000),
      I3 VARCHAR2(1000),
      I4 VARCHAR2(1000),
      I5 VARCHAR2(1000),
      V  VARCHAR2(32767));

   TYPE TYPE_T_DUMP_ARRAY5 IS TABLE OF TYPE_R_DUMP_ARRAY5;

   SUBTYPE T_CHAR IS VARCHAR2;

   TYPE T_TAB_CHAR_CHAR IS TABLE OF VARCHAR2(32767) INDEX BY VARCHAR2(1000);

   TYPE T_TAB_CHAR_NUM IS TABLE OF NUMBER INDEX BY VARCHAR2(1000);

   TYPE T_TAB_CHAR_DATE IS TABLE OF DATE INDEX BY VARCHAR2(1000);

   TYPE T_TAB_CHAR_CHAR2 IS TABLE OF T_TAB_CHAR_CHAR INDEX BY VARCHAR2(1000);

   TYPE T_TAB_CHAR_NUM2 IS TABLE OF T_TAB_CHAR_NUM INDEX BY VARCHAR2(1000);

   TYPE T_TAB_CHAR_DATE2 IS TABLE OF T_TAB_CHAR_DATE INDEX BY VARCHAR2(1000);

   TYPE T_TAB_CHAR_CHAR3 IS TABLE OF T_TAB_CHAR_CHAR2 INDEX BY VARCHAR2(1000);

   TYPE T_TAB_CHAR_NUM3 IS TABLE OF T_TAB_CHAR_NUM2 INDEX BY VARCHAR2(1000);

   TYPE T_TAB_CHAR_DATE3 IS TABLE OF T_TAB_CHAR_DATE2 INDEX BY VARCHAR2(1000);

   TYPE T_TAB_CHAR_CHAR4 IS TABLE OF T_TAB_CHAR_CHAR3 INDEX BY VARCHAR2(1000);

   TYPE T_TAB_CHAR_NUM4 IS TABLE OF T_TAB_CHAR_NUM3 INDEX BY VARCHAR2(1000);

   TYPE T_TAB_CHAR_DATE4 IS TABLE OF T_TAB_CHAR_DATE3 INDEX BY VARCHAR2(1000);

   TYPE T_TAB_CHAR_CHAR5 IS TABLE OF T_TAB_CHAR_CHAR4 INDEX BY VARCHAR2(1000);

   TYPE T_TAB_CHAR_NUM5 IS TABLE OF T_TAB_CHAR_NUM4 INDEX BY VARCHAR2(1000);

   TYPE T_TAB_CHAR_DATE5 IS TABLE OF T_TAB_CHAR_DATE4 INDEX BY VARCHAR2(1000);

   TYPE T_TAB_INT_CHAR IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;

   TYPE T_TAB_INT_NUM IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

   TYPE T_TAB_INT_DATE IS TABLE OF DATE INDEX BY BINARY_INTEGER;

   TYPE T_TAB_INT_CHAR2 IS TABLE OF T_TAB_INT_CHAR INDEX BY BINARY_INTEGER;

   TYPE T_TAB_INT_NUM2 IS TABLE OF T_TAB_INT_NUM INDEX BY BINARY_INTEGER;

   TYPE T_TAB_INT_DATE2 IS TABLE OF T_TAB_INT_DATE INDEX BY BINARY_INTEGER;

   TYPE T_TAB_INT_CHAR3 IS TABLE OF T_TAB_INT_CHAR2 INDEX BY BINARY_INTEGER;

   TYPE T_TAB_INT_NUM3 IS TABLE OF T_TAB_INT_NUM2 INDEX BY BINARY_INTEGER;

   TYPE T_TAB_INT_DATE3 IS TABLE OF T_TAB_INT_DATE2 INDEX BY BINARY_INTEGER;

   TYPE T_TAB_INT_CHAR4 IS TABLE OF T_TAB_INT_CHAR3 INDEX BY BINARY_INTEGER;

   TYPE T_TAB_INT_NUM4 IS TABLE OF T_TAB_INT_NUM3 INDEX BY BINARY_INTEGER;

   TYPE T_TAB_INT_DATE4 IS TABLE OF T_TAB_INT_DATE3 INDEX BY BINARY_INTEGER;

   TYPE T_TAB_INT_CHAR5 IS TABLE OF T_TAB_INT_CHAR4 INDEX BY BINARY_INTEGER;

   TYPE T_TAB_INT_NUM5 IS TABLE OF T_TAB_INT_NUM4 INDEX BY BINARY_INTEGER;

   TYPE T_TAB_INT_DATE5 IS TABLE OF T_TAB_INT_DATE4 INDEX BY BINARY_INTEGER;

   PROCEDURE DUMP_ARRAY(ET_TAB_INT_NUM IN PK_ARRAY.T_TAB_INT_NUM,
                        EV_HIST_IND    IN VARCHAR2 DEFAULT NULL,
                        EN_TYPE        IN NUMBER DEFAULT 1);

   PROCEDURE DUMP_ARRAY(ET_TAB_INT_NUM IN PK_ARRAY.T_TAB_INT_NUM2,
                        EV_HIST_IND    IN VARCHAR2 DEFAULT NULL,
                        EN_TYPE        IN NUMBER DEFAULT 1);

   PROCEDURE DUMP_ARRAY(ET_TAB_INT_NUM IN PK_ARRAY.T_TAB_INT_NUM3,
                        EV_HIST_IND    IN VARCHAR2 DEFAULT NULL,
                        EN_TYPE        IN NUMBER DEFAULT 1);

   PROCEDURE DUMP_ARRAY(ET_TAB_INT_NUM IN PK_ARRAY.T_TAB_INT_NUM4,
                        EV_HIST_IND    IN VARCHAR2 DEFAULT NULL,
                        EN_TYPE        IN NUMBER DEFAULT 1);

   PROCEDURE DUMP_ARRAY(ET_TAB_INT_NUM IN PK_ARRAY.T_TAB_INT_NUM5,
                        EV_HIST_IND    IN VARCHAR2 DEFAULT NULL,
                        EN_TYPE        IN NUMBER DEFAULT 1);

   PROCEDURE DUMP_ARRAY(ET_TAB_CHAR_NUM IN PK_ARRAY.T_TAB_CHAR_NUM,
                        EV_HIST_IND     IN VARCHAR2 DEFAULT NULL,
                        EN_TYPE         IN NUMBER DEFAULT 1);

   PROCEDURE DUMP_ARRAY(ET_TAB_CHAR_NUM IN PK_ARRAY.T_TAB_CHAR_NUM2,
                        EV_HIST_IND     IN VARCHAR2 DEFAULT NULL,
                        EN_TYPE         IN NUMBER DEFAULT 1);

   PROCEDURE DUMP_ARRAY(ET_TAB_CHAR_NUM IN PK_ARRAY.T_TAB_CHAR_NUM3,
                        EV_HIST_IND     IN VARCHAR2 DEFAULT NULL,
                        EN_TYPE         IN NUMBER DEFAULT 1);

   PROCEDURE DUMP_ARRAY(ET_TAB_CHAR_NUM IN PK_ARRAY.T_TAB_CHAR_NUM4,
                        EV_HIST_IND     IN VARCHAR2 DEFAULT NULL,
                        EN_TYPE         IN NUMBER DEFAULT 1);

   PROCEDURE DUMP_ARRAY(ET_TAB_CHAR_NUM IN PK_ARRAY.T_TAB_CHAR_NUM5,
                        EV_HIST_IND     IN VARCHAR2 DEFAULT NULL,
                        EN_TYPE         IN NUMBER DEFAULT 1);

END;
