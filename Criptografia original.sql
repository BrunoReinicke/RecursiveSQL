WITH 
VW_Criptografia(id
               ,senha
               ,crypt
               ,div_crypt
               ,inv_ordem
               ,char_atual
               ,posicao
               ,pos_aux
               ,original
               ,changed) 
AS (SELECT ID
        ,SENHA
        ,'' CRYPT
        ,'' DIV_CRYPT
        ,'' INV_ORDEM
        ,SUBSTR(SENHA, 1, 1) CHAR_ATUAL
        ,2 POSICAO
        ,LENGTH(SENHA) POS_AUX
        ,'!#$%&''()*+,-./0123456789:;<=>?@abcdefghijklmnopqrstuvwxyz[]^_`ABCDEFGHIJKLMNOPQRSTUVWXYZ\\' ORIGINAL 
        ,'Üúùø÷öõôóòñðïîíìëêéèçæåäãâáàßÞÝÛÚÙØ×ÖÕÔÓÒÑÐÏÎÍÌËÊÉÈÇÆÅÄÃÂÁÀ¿¾½¼»º¹¸·¶µ´³²±°¯®­¬«ª©¨§¦¥¤£¡' CHANGED
    FROM Usuario_A 
    
    UNION ALL 
    
    SELECT ID
        ,SENHA
        ,CRYPT || SUBSTR(CHANGED, INSTR(ORIGINAL,CHAR_ATUAL), 1)  

        ,CASE 
            WHEN MOD(LENGTH(SENHA), 2) <> 0 THEN
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
            END
         AS DIV_CRYPT
        
        ,CASE 
            WHEN (LENGTH(CRYPT) = LENGTH(SENHA)) THEN 
                INV_ORDEM || SUBSTR(DIV_CRYPT, POS_AUX + 1, 1)
            END 
         AS INV_ORDEM
         
        ,SUBSTR(SENHA, POSICAO, 1) CHAR_ATUAL
        ,POSICAO + 1    
        
        ,CASE 
            WHEN (LENGTH(CRYPT) >= LENGTH(SENHA)) THEN 
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
SELECT INV_ORDEM
FROM VW_CRIPTOGRAFIA
WHERE POS_AUX = -1
ORDER BY ID