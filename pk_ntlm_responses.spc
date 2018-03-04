CREATE OR REPLACE PACKAGE PK_NTLM_RESPONSES AS
   --
   /*
   * STANDARD SOFTWARE SOLUTIONS LTDA.
   * Edson Luis Gonçalez
   * edson.goncalez@gmail.com
   * Junho/2013
   */
   --
   --
   -- NAME: generateType1Msg
   --
   -- DESCRIPTION:
   --      Generate the first message of the AUTH NTLM process.
   --
   -- PARAMETERS
   --
   --  domain - Name of the outlook server ntdomain
   --  hostname - identifier of the local sending machine
   --
   -- USAGE NOTES:
   --  It will return a BASE64 string that shoul be sended to the mail server
   --  thru a UTL_SMTP.COMMAND.
   --

   FUNCTION GENERATETYPE1MSG(DOMAIN   IN VARCHAR2,
                             HOSTNAME IN VARCHAR2) RETURN VARCHAR2;

   --
   -- NAME: generateType3Msg
   --
   -- DESCRIPTION:
   --      Generate the third message of the AUTH NTLM process.
   --
   -- PARAMETERS
   --
   --  type2ChallengeMsg - BASE64 encoded string returned by the mail server to the type1Msg
   --  user - Username
   --  password - plain password
   --  domain - Name of the outlook server ntdomain
   --  hostname - identifier of the local sending machine
   --
   -- USAGE NOTES:
   --  It will return a BASE64 string that shoul be sended to the mail server
   --  thru a UTL_SMTP.COMMAND.
   --

   FUNCTION GENERATETYPE3MSG(TYPE2CHALLENGEMSG IN VARCHAR2,
                             USER              IN VARCHAR2,
                             PASSWORD          IN VARCHAR2,
                             DOMAIN            IN VARCHAR2,
                             HOSTNAME          IN VARCHAR2) RETURN VARCHAR2;
   -- USAGE EXAMPLE:
--
-- DECLARE
--   n_connection UTL_SMTP.CONNECTION;
--   type1NTLMResponse VARCHAR2(512);
--   type2NTMLMsg UTL_SMTP.reply;
--   type3NTLMResponse VARCHAR2(512);
--   type3Reply UTL_SMTP.reply;
--   mailhost VARCHAR2(64) := 'mailhost.domain.com';
--   mailport VARCHAR2(5) := '25';
--   user VARCHAR2(64) := 'username';
--   password VARCHAR2(64) := '-PassWord-';
--   domain VARCHAR2(64) := 'NTDOMAIN';
--   hostname VARCHAR2(64) := 'myhost.domain.com';
--   from_user VARCHAR2(64) := user || '@domain.com';
--   to_user VARCHAR2(64) := 'test_user@domain.com';
--   subject VARCHAR2(64) := 'Test message';
--   body VARCHAR2(64) := 'This is the body of the message'|| CHR(13) || CHR(10) ||'Regards';
-- BEGIN
--   n_connection := UTL_SMTP.OPEN_CONNECTION(mailhost, mailport);
--   UTL_SMTP.EHLO(n_connection,hostname);
--   UTL_SMTP.COMMAND(n_connection,'AUTH NTLM');
--   type1NTLMResponse:=NTML_RESPONSES.generateType1Msg(domain,hostname);
--   type2NTMLMsg:=UTL_SMTP.COMMAND(n_connection, type1NTLMResponse);
--   type3NTLMResponse:=NTML_RESPONSES.generateType3Msg(type2NTMLMsg.text,user,password,domain,hostname);
--   type3Reply:=UTL_SMTP.COMMAND(n_connection, type3NTLMResponse);
--   UTL_SMTP.MAIL(n_connection, 'a1cagc@indra.es');
--   UTL_SMTP.RCPT(n_connection, 'jmartino@indra.es');
--   UTL_SMTP.DATA(n_connection,
--     'Date: ' || TO_CHAR( SYSDATE, 'dd Mon yy hh24:mi:ss' ) || CHR(13) || CHR(10) ||
--     'From: <'|| from_user ||'>' || CHR(13) || CHR(10) ||
--     'Subject: '|| subject || CHR(13) || CHR(10)||
--     'To: <'|| to_user || '>' || CHR(13) || CHR(10) || CHR(13) || CHR(10) ||
--     body|| CHR(13) || CHR(10) );
--   UTL_SMTP.QUIT(n_connection);
-- END;
--
--
-- This package is a PL/SQL port from the Ntml.java, distributed under
-- GNU General Public License Version 2 only ("GPL") or the Common Development
-- and Distribution License("CDDL") 1.0 (see https://glassfish.dev.java.net/public/CDDL+GPL_1_1.html).
-- Ntlm.java is part of javamail, available at http://kenai.com/projects/javamail
-- Authors Michael McMahon and Bill Shannon
--
-- Port made by Javier Martin-Ortega,  under GPL v2
--

END PK_NTLM_RESPONSES;
/
