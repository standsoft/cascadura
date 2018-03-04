prompt Importing table tipo_erro...
set feedback off
set define off
insert into tipo_erro (TIPOERRO_ID, CD, DESCR, MENSAGEM, PATTERN, GERA_LOG, GERA_EMAIL, SQLCODEX, DM_LEVEL)
values (121, 'APPLICATION_ERROR', 'Mensagem.', '%1', '%PROCESSO%:%LINHA%->%FASE%(%CD_ERRO%) - %msg_erro%', 'N', 'N', -20001, 1);

insert into tipo_erro (TIPOERRO_ID, CD, DESCR, MENSAGEM, PATTERN, GERA_LOG, GERA_EMAIL, SQLCODEX, DM_LEVEL)
values (102, 'CHECK_PARAM_NULL', 'Parâmetro nulo.', 'Parâmetro nulo. %1', '%PROCESSO%:%LINHA%->%FASE%(%CD_ERRO%) - %msg_erro%', 'N', 'N', -20001, 2);

insert into tipo_erro (TIPOERRO_ID, CD, DESCR, MENSAGEM, PATTERN, GERA_LOG, GERA_EMAIL, SQLCODEX, DM_LEVEL)
values (100, 'CHECK_PARAM_INVALID', 'Parâmetro inválido.', 'Parâmetro inválido. %1', '%PROCESSO%:%LINHA%->%FASE%(%CD_ERRO%) - %msg_erro%', 'N', 'N', -20001, 2);

insert into tipo_erro (TIPOERRO_ID, CD, DESCR, MENSAGEM, PATTERN, GERA_LOG, GERA_EMAIL, SQLCODEX, DM_LEVEL)
values (62, 'INVALID_OPERATION', 'Operação inválida.', 'Operação inválida. %1', '%PROCESSO%:%LINHA%->%FASE%(%CD_ERRO%) - %msg_erro%', 'N', 'N', -20001, 2);

insert into tipo_erro (TIPOERRO_ID, CD, DESCR, MENSAGEM, PATTERN, GERA_LOG, GERA_EMAIL, SQLCODEX, DM_LEVEL)
values (61, 'INVALID_PARAM_VL', 'Valor informado no parâmetro inválido ou inexistente.', 'O valor "%1" informado no parâmetro %2 é inválido.', '%PROCESSO%:%LINHA%->%FASE%(%CD_ERRO%) - %msg_erro%', 'N', 'N', -20001, 1);

insert into tipo_erro (TIPOERRO_ID, CD, DESCR, MENSAGEM, PATTERN, GERA_LOG, GERA_EMAIL, SQLCODEX, DM_LEVEL)
values (42, 'VALOR_INVALIDO', 'Valor informado não é válido.', 'Valor informado "%1" não é válido para o processo.', '%PROCESSO%:%LINHA%->%FASE%(%CD_ERRO%) - %msg_erro%', 'N', 'N', -20001, 2);

insert into tipo_erro (TIPOERRO_ID, CD, DESCR, MENSAGEM, PATTERN, GERA_LOG, GERA_EMAIL, SQLCODEX, DM_LEVEL)
values (41, 'VALOR_MAX_EXCEDIDO', 'Valor corrente excedeu o valor máximo permitido.', 'Valor corrente "%1" é menor do que o valor máximo permitido "%2".', '%PROCESSO%:%LINHA%->%FASE%(%CD_ERRO%) - %msg_erro%', 'N', 'N', -20001, 3);

insert into tipo_erro (TIPOERRO_ID, CD, DESCR, MENSAGEM, PATTERN, GERA_LOG, GERA_EMAIL, SQLCODEX, DM_LEVEL)
values (22, 'DUP_VAL_ON_INDEX', 'Registro duplicado. Violação de chave única.', 'Tabela %1 já possui o registro informado.', '%PROCESSO%:%LINHA%->%FASE%(%CD_ERRO%) - %msg_erro%', 'N', 'N', -20001, 2);

insert into tipo_erro (TIPOERRO_ID, CD, DESCR, MENSAGEM, PATTERN, GERA_LOG, GERA_EMAIL, SQLCODEX, DM_LEVEL)
values (21, 'VALOR_MIN_EXCEDIDO', 'Valor corrente excedeu o valor mínimo permitido.', 'Valor corrente "%1" é menor do que o valor mínimo permitido "%2".', '%PROCESSO%:%LINHA%->%FASE%(%CD_ERRO%) - %msg_erro%', 'N', 'N', -20001, 3);

insert into tipo_erro (TIPOERRO_ID, CD, DESCR, MENSAGEM, PATTERN, GERA_LOG, GERA_EMAIL, SQLCODEX, DM_LEVEL)
values (8, 'GENERIC', 'Excecao nao tratada', 'Exceção não tratada: %1.', '%PROCESSO%:%LINHA%->%FASE%(%CD_ERRO%) - %msg_erro%', 'S', 'N', -20001, 3);

insert into tipo_erro (TIPOERRO_ID, CD, DESCR, MENSAGEM, PATTERN, GERA_LOG, GERA_EMAIL, SQLCODEX, DM_LEVEL)
values (7, 'APLICACAO_NULL', 'Nenhuma aplicacao foi encontrada na sessao', 'Nenhuma aplicação foi encontrada na sessão.', '%PROCESSO%:%LINHA%->%FASE%(%CD_ERRO%) - %msg_erro%', 'N', 'N', -20001, 1);

insert into tipo_erro (TIPOERRO_ID, CD, DESCR, MENSAGEM, PATTERN, GERA_LOG, GERA_EMAIL, SQLCODEX, DM_LEVEL)
values (6, 'FUNCIONARIO_NULL', 'Nenhum funcionario encontrado na sessão', 'Nenhum funcionario foi encontrado na sessão.', '%PROCESSO%:%LINHA%->%FASE%(%CD_ERRO%) - %msg_erro%', 'N', 'N', -20001, 1);

insert into tipo_erro (TIPOERRO_ID, CD, DESCR, MENSAGEM, PATTERN, GERA_LOG, GERA_EMAIL, SQLCODEX, DM_LEVEL)
values (5, 'FILIAL_NULL', 'Nenhuma filial encontrada na sessão', 'Nenhuma filial foi encontrada na sessão.', '%PROCESSO%:%LINHA%->%FASE%(%CD_ERRO%) - %msg_erro%', 'N', 'N', -20001, 1);

insert into tipo_erro (TIPOERRO_ID, CD, DESCR, MENSAGEM, PATTERN, GERA_LOG, GERA_EMAIL, SQLCODEX, DM_LEVEL)
values (4, 'UPDATE_0', 'Nenhum update foi aferido', 'Nenhum registro aferido durante atualizacao. %1.', '%PROCESSO%:%LINHA%->%FASE%(%CD_ERRO%) - %msg_erro%', 'S', 'N', -20001, 3);

insert into tipo_erro (TIPOERRO_ID, CD, DESCR, MENSAGEM, PATTERN, GERA_LOG, GERA_EMAIL, SQLCODEX, DM_LEVEL)
values (2, 'ROWCOUNT_0', 'Nenhum registro foi aferido', 'Nenhum registro foi aferido. %1.', '%PROCESSO%:%LINHA%->%FASE%(%CD_ERRO%) - %msg_erro%', 'S', 'N', -20001, 3);

insert into tipo_erro (TIPOERRO_ID, CD, DESCR, MENSAGEM, PATTERN, GERA_LOG, GERA_EMAIL, SQLCODEX, DM_LEVEL)
values (1, 'LOCK', 'Tabela com lock', 'Tabela %1 esta sofrendo lock por %2.', '%PROCESSO%:%LINHA%->%FASE%(%CD_ERRO%) - %msg_erro%', 'S', 'N', -20001, 3);

prompt Done.
