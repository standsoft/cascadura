CREATE OR REPLACE PACKAGE BODY PK_NTLM_RESPONSES AS
   --
   /*
   * STANDARD SOFTWARE SOLUTIONS LTDA.
   * Edson Luis Gonçalez
   * edson.goncalez@gmail.com
   * Junho/2013
   */
   --
   FUNCTION BITOR(X IN NUMBER,
                  Y IN NUMBER) RETURN NUMBER AS
   BEGIN
      RETURN X + Y - BITAND(X, Y);
   END;

   FUNCTION BITLEFTSHIFT(X     IN NUMBER,
                         TIMES IN NUMBER) RETURN NUMBER AS
   BEGIN
      RETURN X * POWER(2, TIMES);
   END;

   FUNCTION BITRIGHTSHIFT(X     IN NUMBER,
                          TIMES IN NUMBER) RETURN NUMBER AS
   BEGIN
      RETURN TRUNC(X / POWER(2, TIMES));
   END;

   FUNCTION BINARY_OPS_MAKE_DES_KEY(FIRST_BYTE    CHAR,
                                    SECOND_BYTE   CHAR,
                                    FIRST_OFFSET  NUMBER,
                                    SECOND_OFFSET NUMBER) RETURN CHAR IS
      V_RETURN CHAR;
   BEGIN
      RETURN LTRIM(TO_CHAR(BITOR(BITAND(BITLEFTSHIFT(TO_NUMBER(FIRST_BYTE, '0x'), FIRST_OFFSET), 255),
                                 BITRIGHTSHIFT(TO_NUMBER(SECOND_BYTE, '0x'), SECOND_OFFSET)),
                           '0x'));
   END;

   FUNCTION MAKEDESKEY(KEY    VARCHAR,
                       OFFSET NUMBER) RETURN VARCHAR2 AS
   BEGIN
      RETURN SUBSTR(KEY, 1 + OFFSET * 2, 2) || BINARY_OPS_MAKE_DES_KEY(SUBSTR(KEY, 1 + OFFSET * 2, 2),
                                                                       SUBSTR(KEY, 3 + OFFSET * 2, 2),
                                                                       7,
                                                                       1) 
                                            || BINARY_OPS_MAKE_DES_KEY(SUBSTR(KEY,
                                                                              3 + OFFSET * 2,
                                                                              2),
                                                                       SUBSTR(KEY,
                                                                              5 + OFFSET * 2,
                                                                              2),
                                                                       6,
                                                                       2) 
                                            || BINARY_OPS_MAKE_DES_KEY(SUBSTR(KEY,
                                                                              5 +
                                                                              OFFSET * 2,
                                                                              2),
                                                                       SUBSTR(KEY,
                                                                              7 +
                                                                              OFFSET * 2,
                                                                              2),
                                                                       5,
                                                                       3) 
                                            || BINARY_OPS_MAKE_DES_KEY(SUBSTR(KEY,
                                                                              7 +
                                                                              OFFSET * 2,
                                                                              2),
                                                                       SUBSTR(KEY,
                                                                              9 +
                                                                              OFFSET * 2,
                                                                              2),
                                                                       4,
                                                                       4) 
                                            || BINARY_OPS_MAKE_DES_KEY(SUBSTR(KEY,
                                                                              9 +
                                                                              OFFSET * 2,
                                                                              2),
                                                                       SUBSTR(KEY,
                                                                              11 +
                                                                              OFFSET * 2,
                                                                              2),
                                                                       3,
                                                                       5) 
                                            || BINARY_OPS_MAKE_DES_KEY(SUBSTR(KEY,
                                                                              11 +
                                                                              OFFSET * 2,
                                                                              2),
                                                                       SUBSTR(KEY,
                                                                              13 +
                                                                              OFFSET * 2,
                                                                              2),
                                                                       2,
                                                                       6) 
                                            || LTRIM(TO_CHAR(BITAND(BITLEFTSHIFT(TO_NUMBER(SUBSTR(KEY,
                                                                             13 +
                                                                             OFFSET * 2,
                                                                             2),
                                                                      '0x'),
                                                            1),
                                               255),
                                        '0x'));
   END;

   -- Add a parity bit at the end of every byte
   FUNCTION GENERATESECRETBYTE(DESKEY IN VARCHAR2) RETURN VARCHAR2 AS
      NDESKEY      NUMBER;
      AUX_DESKEY   NUMBER;
      NUMBER_OF_1S NUMBER;
   BEGIN
      -- We have to count the number of 1s. Lets divide the original number by two until it reaches 0.
      NDESKEY      := TO_NUMBER(DESKEY, '0x');
      AUX_DESKEY   := NDESKEY;
      NUMBER_OF_1S := 0;
   
      WHILE (AUX_DESKEY > 0)
      LOOP
         NUMBER_OF_1S := NUMBER_OF_1S + MOD(AUX_DESKEY, 2);
         AUX_DESKEY   := TRUNC(AUX_DESKEY / 2, 0);
      END LOOP;
   
      -- If number_of_1s is even, add a final bit
      IF (MOD(NUMBER_OF_1S, 2) = 0) THEN
         -- If original number is odd, there is already a final bit, do not add it.
         IF (MOD(NDESKEY, 2) = 0) THEN
            RETURN LTRIM(TO_CHAR(NDESKEY + 1, '0x'));
         END IF;
      END IF;
   
      -- If not, return the same number
      RETURN LTRIM(TO_CHAR(NDESKEY, '0x'));
   END;

   FUNCTION GENERATESECRET(DESKEY VARCHAR2) RETURN VARCHAR2 AS
   BEGIN
      RETURN GENERATESECRETBYTE(SUBSTR(DESKEY, 1, 2)) 
          || GENERATESECRETBYTE(SUBSTR(DESKEY, 3, 2)) 
          || GENERATESECRETBYTE(SUBSTR(DESKEY, 5, 2)) 
          || GENERATESECRETBYTE(SUBSTR(DESKEY, 7, 2)) 
          || GENERATESECRETBYTE(SUBSTR(DESKEY, 9, 2)) 
          || GENERATESECRETBYTE(SUBSTR(DESKEY, 11, 2)) 
          || GENERATESECRETBYTE(SUBSTR(DESKEY, 13, 2)) 
          || GENERATESECRETBYTE(SUBSTR(DESKEY, 15, 2));
   END;

   FUNCTION CALCRESPONSE(V_KEY  IN VARCHAR2,
                         V_TEXT IN VARCHAR2) RETURN VARCHAR2 AS
      V_KEY1   VARCHAR2(64);
      V_KEY2   VARCHAR2(64);
      V_KEY3   VARCHAR2(64);
      V_OUT1   VARCHAR2(64);
      V_OUT2   VARCHAR2(64);
      V_OUT3   VARCHAR2(64);
      V_RESULT VARCHAR2(64);
      V_DKS1   VARCHAR2(64);
      V_DKS2   VARCHAR2(64);
      V_DKS3   VARCHAR2(64);
   BEGIN
      V_DKS1 := MAKEDESKEY(V_KEY, 0);
      V_DKS2 := MAKEDESKEY(V_KEY, 7);
      V_DKS3 := MAKEDESKEY(V_KEY, 14);
      V_KEY1 := GENERATESECRET(V_DKS1);
      V_KEY2 := GENERATESECRET(V_DKS2);
      V_KEY3 := GENERATESECRET(V_DKS3);
      V_OUT1 := DBMS_CRYPTO.ENCRYPT(KEY => HEXTORAW(V_KEY1),
                                    SRC => HEXTORAW(V_TEXT),
                                    TYP => DBMS_CRYPTO.CHAIN_ECB + DBMS_CRYPTO.ENCRYPT_DES + DBMS_CRYPTO.PAD_NONE);
      V_OUT2 := DBMS_CRYPTO.ENCRYPT(KEY => HEXTORAW(V_KEY2),
                                    SRC => HEXTORAW(V_TEXT),
                                    TYP => DBMS_CRYPTO.CHAIN_ECB + DBMS_CRYPTO.ENCRYPT_DES + DBMS_CRYPTO.PAD_NONE);
      V_OUT3 := DBMS_CRYPTO.ENCRYPT(KEY => HEXTORAW(V_KEY3),
                                    SRC => HEXTORAW(V_TEXT),
                                    TYP => DBMS_CRYPTO.CHAIN_ECB + DBMS_CRYPTO.ENCRYPT_DES + DBMS_CRYPTO.PAD_NONE);
      /*    DBMS_output.put_line('key: '||v_key||'<-');
      DBMS_output.put_line('v_dks1: '||v_dks1||'<-');
      DBMS_output.put_line('v_dks2: '||v_dks2||'<-');
      DBMS_output.put_line('v_dks3: '||v_dks3||'<-');
      DBMS_output.put_line('v_key1: '||v_key1||'<-');
      DBMS_output.put_line('v_key2: '||v_key2||'<-');
      DBMS_output.put_line('v_key3: '||v_key3||'<-');
      DBMS_output.put_line('v_out1: '||v_out1||'<-');
      DBMS_output.put_line('v_out2: '||v_out2||'<-');
      DBMS_output.put_line('v_out3: '||v_out3||'<-');
      DBMS_output.put_line('result: '||v_out1||v_out2||v_out3||'<-');*/
      RETURN V_OUT1 || V_OUT2 || V_OUT3;
   END;

   FUNCTION CALCLMHASH(PASSWORD IN VARCHAR2) RETURN VARCHAR2 AS
      MAGIC      VARCHAR2(16) := '4b47532140232425';
      V_DKS1     VARCHAR2(64);
      V_DKS2     VARCHAR2(64);
      V_KEY1     VARCHAR2(64);
      V_KEY2     VARCHAR2(64);
      V_OUT1     VARCHAR2(64);
      V_OUT2     VARCHAR2(64);
      V_PASSWORD VARCHAR2(64);
   BEGIN
      V_PASSWORD := RPAD(SUBSTR(RAWTOHEX(UTL_RAW.CAST_TO_RAW(UPPER(PASSWORD))), 1, 28), 28, '0');
      V_DKS1     := MAKEDESKEY(V_PASSWORD, 0);
      V_DKS2     := MAKEDESKEY(V_PASSWORD, 7);
      V_KEY1     := GENERATESECRET(V_DKS1);
      V_KEY2     := GENERATESECRET(V_DKS2);
      V_OUT1     := DBMS_CRYPTO.ENCRYPT(KEY => HEXTORAW(V_KEY1),
                                        SRC => HEXTORAW(MAGIC),
                                        TYP => DBMS_CRYPTO.CHAIN_ECB + DBMS_CRYPTO.ENCRYPT_DES + DBMS_CRYPTO.PAD_NONE);
      V_OUT2     := DBMS_CRYPTO.ENCRYPT(KEY => HEXTORAW(V_KEY2),
                                        SRC => HEXTORAW(MAGIC),
                                        TYP => DBMS_CRYPTO.CHAIN_ECB + DBMS_CRYPTO.ENCRYPT_DES + DBMS_CRYPTO.PAD_NONE);
      /*    DBMS_output.put_line('pwb1: '||v_password||'<-');
      DBMS_output.put_line('v_dks1: '||v_dks1||'<-');
      DBMS_output.put_line('v_dks2: '||v_dks2||'<-');
      DBMS_output.put_line('v_key1: '||v_key1||'<-');
      DBMS_output.put_line('v_key2: '||v_key2||'<-');
      DBMS_output.put_line('v_out1: '||v_out1||'<-');
      DBMS_output.put_line('v_out2: '||v_out2||'<-');
      DBMS_output.put_line('result: '||rpad(v_out1||v_out2,21*2,'0')||'<-');*/
      RETURN RPAD(V_OUT1 || V_OUT2, 21 * 2, '0');
   END;

   FUNCTION GETUNICODELITTLEUNMARKED(TEXT VARCHAR2) RETURN VARCHAR2 AS
      UNICODE_TEXT VARCHAR2(2000);
   BEGIN
      -- We simply add a 00 byte after every original text's byte
      FOR I IN 1 .. LENGTH(TEXT)
      LOOP
         UNICODE_TEXT := UNICODE_TEXT || RAWTOHEX(UTL_RAW.CAST_TO_RAW(SUBSTR(TEXT, I, 1))) || '00';
      END LOOP;
   
      RETURN UNICODE_TEXT;
   END;

   FUNCTION CALCNTHASH(PASSWORD VARCHAR2) RETURN VARCHAR2 AS
   BEGIN
      -- get the MD4 digest message, filled with 0s 'til 21 bytes
      RETURN RPAD(SUBSTR(DBMS_CRYPTO.HASH(SRC => HEXTORAW(GETUNICODELITTLEUNMARKED(PASSWORD)), TYP => DBMS_CRYPTO.HASH_MD4),
                         1,
                         16 * 2),
                  21 * 2,
                  '0');
   END;

   FUNCTION GETINTWOBYTES(DATA NUMBER) RETURN VARCHAR2 AS
   BEGIN
      RETURN LTRIM(TO_CHAR(MOD(DATA, 256), '0x')) || LTRIM(TO_CHAR(TRUNC(DATA / 256, 0), '0x'));
   END;

   FUNCTION GENERATETYPE3MSG(TYPE2CHALLENGEMSG IN VARCHAR2,
                             USER              IN VARCHAR2,
                             PASSWORD          IN VARCHAR2,
                             DOMAIN            IN VARCHAR2,
                             HOSTNAME          IN VARCHAR2) RETURN VARCHAR2 AS
      FIRSTDOTHOSTNAME        VARCHAR2(128);
      NONCE                   VARCHAR2(16);
      USER_LENGTH_BYTES       VARCHAR2(4);
      DOMAIN_LENGTH_BYTES     VARCHAR2(4);
      HOSTNAME_LENGTH_BYTES   VARCHAR2(4);
      LMRESPONSE              VARCHAR2(64);
      NTRESPONSE              VARCHAR2(64);
      UNICODE_USER            VARCHAR2(128);
      UNICODE_DOMAIN          VARCHAR2(128);
      UNICODE_HOSTNAME        VARCHAR2(128);
      USER_OFFSET_BYTES       VARCHAR2(4);
      HOSTNAME_OFFSET_BYTES   VARCHAR2(4);
      LMRESPONSE_OFFSET_BYTES VARCHAR2(4);
      NTRESPONSE_OFFSET_BYTES VARCHAR2(4);
      TOTAL_LENGTH_BYTES      VARCHAR2(4);
      TEMP_OFFSET             NUMBER := 64;
   BEGIN
      -- hostname is only until the first dot
      FIRSTDOTHOSTNAME := HOSTNAME;
   
      IF (INSTR(HOSTNAME, '.') > 0) THEN
         FIRSTDOTHOSTNAME := SUBSTR(HOSTNAME, 1, INSTR(HOSTNAME, '.') - 1);
      END IF;
   
      -- nonce is located at challenge mensage, byte 24 for 8 bytes.
      -- type2 challenge message comes in BASE64
      NONCE                   := SUBSTR(RAWTOHEX(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(TYPE2CHALLENGEMSG))),
                                        24 * 2 + 1,
                                        8 * 2);
      USER_LENGTH_BYTES       := GETINTWOBYTES(LENGTH(USER) * 2);
      DOMAIN_LENGTH_BYTES     := GETINTWOBYTES(LENGTH(DOMAIN) * 2);
      HOSTNAME_LENGTH_BYTES   := GETINTWOBYTES(LENGTH(FIRSTDOTHOSTNAME) * 2);
      LMRESPONSE              := CALCRESPONSE(CALCLMHASH(PASSWORD), NONCE);
      NTRESPONSE              := CALCRESPONSE(CALCNTHASH(PASSWORD), NONCE);
      UNICODE_USER            := GETUNICODELITTLEUNMARKED(USER);
      UNICODE_DOMAIN          := GETUNICODELITTLEUNMARKED(DOMAIN);
      UNICODE_HOSTNAME        := GETUNICODELITTLEUNMARKED(FIRSTDOTHOSTNAME);
      TEMP_OFFSET             := TEMP_OFFSET + LENGTH(UNICODE_DOMAIN) / 2;
      USER_OFFSET_BYTES       := GETINTWOBYTES(TEMP_OFFSET);
      TEMP_OFFSET             := TEMP_OFFSET + LENGTH(UNICODE_USER) / 2;
      HOSTNAME_OFFSET_BYTES   := GETINTWOBYTES(TEMP_OFFSET);
      TEMP_OFFSET             := TEMP_OFFSET + LENGTH(UNICODE_HOSTNAME) / 2;
      LMRESPONSE_OFFSET_BYTES := GETINTWOBYTES(TEMP_OFFSET);
      TEMP_OFFSET             := TEMP_OFFSET + LENGTH(LMRESPONSE) / 2;
      NTRESPONSE_OFFSET_BYTES := GETINTWOBYTES(TEMP_OFFSET);
      TEMP_OFFSET             := TEMP_OFFSET + LENGTH(NTRESPONSE) / 2;
      TOTAL_LENGTH_BYTES      := GETINTWOBYTES(TEMP_OFFSET);
      -- BASE64_ENCODE includes a CR/LF every 64 characters that must be removed
      RETURN REPLACE(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(HEXTORAW('4E544C4D535350000300000018001800' || -- bytes 00-15
                                                                                LMRESPONSE_OFFSET_BYTES || '000018001800' || -- bytes 18-23
                                                                                NTRESPONSE_OFFSET_BYTES || '0000' || --bytes 16-27
                                                                                DOMAIN_LENGTH_BYTES || DOMAIN_LENGTH_BYTES ||
                                                                                '4000' || --domain offset is always 64
                                                                                '0000' || --bytes 34-35
                                                                                USER_LENGTH_BYTES || USER_LENGTH_BYTES ||
                                                                                USER_OFFSET_BYTES || '0000' || -- bytes 42-43
                                                                                HOSTNAME_LENGTH_BYTES || HOSTNAME_LENGTH_BYTES ||
                                                                                HOSTNAME_OFFSET_BYTES || '000000000000' || -- bytes 50-56
                                                                                TOTAL_LENGTH_BYTES || '000001820000' || -- bytes 58-63
                                                                                UNICODE_DOMAIN || UNICODE_USER ||
                                                                                UNICODE_HOSTNAME || LMRESPONSE || NTRESPONSE))),
                     CHR(13) || CHR(10),
                     '');
   END;

   FUNCTION GENERATETYPE1MSG(DOMAIN   IN VARCHAR2,
                             HOSTNAME IN VARCHAR2) RETURN VARCHAR2 AS
      FIRSTDOTHOSTNAME      VARCHAR2(128);
      DOMAIN_LENGTH_BYTES   VARCHAR2(4);
      HOSTNAME_LENGTH_BYTES VARCHAR2(4);
      DOMAIN_OFFSET_BYTES   VARCHAR2(4);
   BEGIN
      -- hostname is only until the first dot
      FIRSTDOTHOSTNAME := HOSTNAME;
   
      IF (INSTR(HOSTNAME, '.') > 0) THEN
         FIRSTDOTHOSTNAME := SUBSTR(HOSTNAME, 1, INSTR(HOSTNAME, '.') - 1);
      END IF;
   
      DOMAIN_LENGTH_BYTES   := GETINTWOBYTES(LENGTH(DOMAIN));
      HOSTNAME_LENGTH_BYTES := GETINTWOBYTES(LENGTH(FIRSTDOTHOSTNAME));
      DOMAIN_OFFSET_BYTES   := GETINTWOBYTES(32 + LENGTH(FIRSTDOTHOSTNAME));
      -- BASE64_ENCODE includes a CR/LF every 64 characters that must be removed
      RETURN REPLACE(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(HEXTORAW('4E544C4D535350000100000003B20000' || -- bytes 00-15
                                                                                DOMAIN_LENGTH_BYTES || DOMAIN_LENGTH_BYTES ||
                                                                                DOMAIN_OFFSET_BYTES || '0000' || -- bytes 22-23
                                                                                HOSTNAME_LENGTH_BYTES || HOSTNAME_LENGTH_BYTES ||
                                                                                '20000000' || -- bytes 28-31
                                                                                RAWTOHEX(UTL_RAW.CAST_TO_RAW(FIRSTDOTHOSTNAME)) ||
                                                                                RAWTOHEX(UTL_RAW.CAST_TO_RAW(DOMAIN))))),
                     CHR(13) || CHR(10),
                     '');
   END;
   --   
END PK_NTLM_RESPONSES;
/
