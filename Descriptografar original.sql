WITH 
VW_InvModAux
AS (SELECT ROWNUM AS LINHA,
           SUBSTR(CHANGED, LEVEL, 1) AS CARACT,
           CHANGED 
    FROM (SELECT ROWNUM AS LINHA,
                 '!#$%&''()*+,-./0123456789:;<=>?@abcdefghijklmnopqrstuvwxyz[]^_`ABCDEFGHIJKLMNOPQRSTUVWXYZ\' AS CHANGED 
          FROM DUAL)
    CONNECT BY LEVEL <= LENGTH(CHANGED)
)
,VW_InvModular
AS (SELECT MAX(LINHA) LINHA
    FROM VW_InvModAux
    WHERE MOD(12 * LINHA, LENGTH(CHANGED)) = 1
)
,VW_Criptografia(id
               ,senha
               ,decrypt_pwd
               ,div_decrypt
               ,decrypted
               ,char_atual
               ,posicao
               ,pos_aux
               ,original
               ,changed) 
AS (SELECT ID
        ,SENHA
        ,'' DECRYPT_PWD
        ,'' DIV_decrypt
        ,'' AFIM
        ,SUBSTR(SENHA, 1, 1) CHAR_ATUAL
        ,2 POSICAO
        ,LENGTH(SENHA) POS_AUX
        ,'Üúùø÷öõôóòñðïîíìëêéèçæåäãâáàßÞÝÛÚÙØ×ÖÕÔÓÒÑÐÏÎÍÌËÊÉÈÇÆÅÄÃÂÁÀ¿¾½¼»º¹¸·¶µ´³²±°¯®­¬«ª©¨§¦¥¤£¡' ORIGINAL 
        ,'!#$%&''()*+,-./0123456789:;<=>?@abcdefghijklmnopqrstuvwxyz[]^_`ABCDEFGHIJKLMNOPQRSTUVWXYZ\' CHANGED
    FROM Usuario_C 
    
    UNION ALL 
    
    SELECT ID
        ,SENHA
        
        ,DECRYPT_PWD 
         || SUBSTR(CHANGED, 
                   MOD((SELECT AA.LINHA FROM VW_InvModular AA) *
                        MOD(((INSTR(ORIGINAL,CHAR_ATUAL) - 1) - 14 + LENGTH(CHANGED)), 
                            LENGTH(CHANGED)
                        ),
                        LENGTH(CHANGED))
                        + 1,
                   1) 

        ,CASE 
            WHEN MOD(LENGTH(SENHA), 2) <> 0 THEN
                SUBSTR(
                    DECRYPT_PWD, 
                    Trunc(LENGTH(SENHA) / 2) + 2, 
                    LENGTH(SENHA) - Trunc(LENGTH(SENHA) / 2) + 2
                ) ||
                SUBSTR(DECRYPT_PWD, (Trunc(LENGTH(SENHA) / 2) + 1), 1) ||
                SUBSTR(DECRYPT_PWD, 1, Trunc(LENGTH(SENHA) / 2))
            ELSE
                SUBSTR(
                    DECRYPT_PWD, 
                    Trunc(LENGTH(SENHA) / 2) + 1, 
                    LENGTH(SENHA) - Trunc(LENGTH(SENHA) / 2) + 1
                ) ||
                SUBSTR(DECRYPT_PWD, 1, Trunc(LENGTH(SENHA) / 2))
            END
         AS DIV_decrypt
        
        ,CASE 
            WHEN (LENGTH(DECRYPT_PWD) = LENGTH(SENHA)) THEN 
                DECRYPTED || SUBSTR(DIV_decrypt, POS_AUX + 1, 1)
            END 
         AS DECRYPTED
         
        ,SUBSTR(SENHA, POSICAO, 1) CHAR_ATUAL
        ,POSICAO + 1    
        
        ,CASE 
            WHEN (LENGTH(DECRYPT_PWD) >= LENGTH(SENHA)) THEN 
                POS_AUX - 1
            ELSE
                POS_AUX
            END 
         AS POSX_AUX
         
        ,ORIGINAL
        ,CHANGED       
    FROM VW_Criptografia
    WHERE POSICAO <= LENGTH(SENHA) + (LENGTH(SENHA) + 2)
)
SELECT Decrypted
FROM VW_CRIPTOGRAFIA
WHERE POS_AUX = -1
ORDER BY ID