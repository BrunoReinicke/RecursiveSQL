WITH 
VW_Criptografia(id
               ,senha
               ,crypt
               ,div_crypt
               ,encrypted
               ,char_atual
               ,posicao
               ,pos_aux
               ,original
               ,changed) 
AS (SELECT ID
        ,SENHA
        ,'' CRYPT
        ,'' DIV_CRYPT
        ,'' ENCRYPTED
        ,SUBSTR(SENHA, 1, 1) CHAR_ATUAL
        ,2 POSICAO
        ,LENGTH(SENHA) POS_AUX
        ,'!#$%&''()*+,-./0123456789:;<=>?@abcdefghijklmnopqrstuvwxyz[]^_`ABCDEFGHIJKLMNOPQRSTUVWXYZ\' ORIGINAL 
        ,'Üúùø÷öõôóòñðïîíìëêéèçæåäãâáàßÞÝÛÚÙØ×ÖÕÔÓÒÑÐÏÎÍÌËÊÉÈÇÆÅÄÃÂÁÀ¿¾½¼»º¹¸·¶µ´³²±°¯®­¬«ª©¨§¦¥¤£¡' CHANGED
    FROM Usuario_A
    
    UNION ALL 
    
    SELECT ID
        ,SENHA
        
        ,CRYPT 
         || SUBSTR(CHANGED,
                       MOD(12 * 
                          (INSTR(
                              CHANGED, 
                              SUBSTR(CHANGED, INSTR(ORIGINAL,CHAR_ATUAL), 1)
                           ) - 1) + 14,
                          LENGTH(CHANGED)
                       ) + 1,
                   1)
                    
        ,CASE WHEN MOD(LENGTH(SENHA), 2) <> 0 THEN
            SUBSTR(
                CRYPT, 
                Trunc(LENGTH(SENHA) / 2) + 2, 
                LENGTH(SENHA) - Trunc(LENGTH(SENHA) / 2) + 2
            ) ||
            SUBSTR(CRYPT, (Trunc(LENGTH(SENHA) / 2) + 1), 1) ||
            SUBSTR(CRYPT, 1, Trunc(LENGTH(SENHA) / 2))
         ELSE
            SUBSTR(
                CRYPT, 
                Trunc(LENGTH(SENHA) / 2) + 1, 
                LENGTH(SENHA) - Trunc(LENGTH(SENHA) / 2) + 1
            ) ||
            SUBSTR(CRYPT, 1, Trunc(LENGTH(SENHA) / 2))
         END AS DIV_CRYPT
        
        ,CASE WHEN (LENGTH(CRYPT) = LENGTH(SENHA))
              AND (POSICAO <= (LENGTH(SENHA) * 2) + 2) THEN 
            ENCRYPTED || SUBSTR(DIV_CRYPT, POS_AUX + 1, 1)
         ELSE
            ENCRYPTED
         END AS ENCRYPTED
         
        ,SUBSTR(SENHA, POSICAO, 1) CHAR_ATUAL
        ,POSICAO + 1    
        
        ,CASE
             WHEN (LENGTH(CRYPT) >= LENGTH(SENHA)) THEN 
                POS_AUX - 1
             ELSE
                POS_AUX
         END AS POS_AUX
         
        ,ORIGINAL
        ,CHANGED       
      
    FROM VW_Criptografia
    WHERE POSICAO <= (LENGTH(SENHA) * 2) + 2
)
SELECT ENCRYPTED
FROM VW_CRIPTOGRAFIA
WHERE LENGTH(ENCRYPTED) = LENGTH(SENHA)
ORDER BY ID, POSICAO