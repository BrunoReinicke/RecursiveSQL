WITH 
VW_Criptografia(id
               ,senha
               ,decrypt
               ,div_decrypt
               ,inv_ordem
               ,char_atual
               ,posicao
               ,pos_aux
               ,original
               ,changed) 
AS (SELECT ID
        ,SENHA
        ,'' decrypt
        ,'' DIV_decrypt
        ,'' INV_ORDEM
        ,SUBSTR(SENHA, 1, 1) CHAR_ATUAL
        ,2 POSICAO
        ,LENGTH(SENHA) POS_AUX
        ,'Üúùø÷öõôóòñðïîíìëêéèçæåäãâáàßÞÝÛÚÙØ×ÖÕÔÓÒÑÐÏÎÍÌËÊÉÈÇÆÅÄÃÂÁÀ¿¾½¼»º¹¸·¶µ´³²±°¯®­¬«ª©¨§¦¥¤£¡' ORIGINAL 
        ,'!#$%&''()*+,-./0123456789:;<=>?@abcdefghijklmnopqrstuvwxyz[]^_`ABCDEFGHIJKLMNOPQRSTUVWXYZ\\' CHANGED
    FROM Usuario_B 
    
    UNION ALL 
    
    SELECT ID
        ,SENHA
        ,decrypt || SUBSTR(CHANGED, INSTR(ORIGINAL,CHAR_ATUAL), 1)  

        ,CASE 
            WHEN MOD(LENGTH(SENHA), 2) <> 0 THEN
                SUBSTR(
                    decrypt, 
                    Trunc(LENGTH(SENHA) / 2) + 2, 
                    LENGTH(SENHA) - Trunc(LENGTH(SENHA) / 2) + 2
                ) ||
                SUBSTR(decrypt, (Trunc(LENGTH(SENHA) / 2) + 1), 1) ||
                SUBSTR(decrypt, 1, Trunc(LENGTH(SENHA) / 2))
            ELSE
                SUBSTR(
                    decrypt, 
                    Trunc(LENGTH(SENHA) / 2) + 1, 
                    LENGTH(SENHA) - Trunc(LENGTH(SENHA) / 2) + 1
                ) ||
                SUBSTR(decrypt, 1, Trunc(LENGTH(SENHA) / 2))
            END
         AS DIV_decrypt
        
        ,CASE 
            WHEN (LENGTH(decrypt) = LENGTH(SENHA)) THEN 
                INV_ORDEM || SUBSTR(DIV_decrypt, POS_AUX + 1, 1)
            END 
         AS INV_ORDEM
         
        ,SUBSTR(SENHA, POSICAO, 1) CHAR_ATUAL
        ,POSICAO + 1    
        
        ,CASE 
            WHEN (LENGTH(decrypt) >= LENGTH(SENHA)) THEN 
                POS_AUX - 1
            ELSE
                POS_AUX
            END 
         AS POS_AUX
         
        ,ORIGINAL
        ,CHANGED       
    FROM VW_Criptografia
    WHERE POSICAO <= LENGTH(SENHA) + (LENGTH(SENHA) + 2)
)
SELECT ID, INV_ORDEM
FROM VW_CRIPTOGRAFIA
WHERE POS_AUX = -1
ORDER BY ID