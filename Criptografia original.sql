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
               ,changed
               ,auxiliar
               ,afim_aux
               ,afim) 
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
        ,'' AUXILIAR
        ,'' AFIM_AUX
        ,'' AFIM
    FROM Usuario_A
    
    UNION ALL 
    
    SELECT ID
        ,SENHA
        ,CRYPT || SUBSTR(CHANGED, INSTR(ORIGINAL,CHAR_ATUAL), 1)  

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
            INV_ORDEM || SUBSTR(DIV_CRYPT, POS_AUX + 1, 1)
         ELSE
            INV_ORDEM
         END AS INV_ORDEM
         
        ,SUBSTR(SENHA, POSICAO, 1) CHAR_ATUAL
        ,POSICAO + 1    
        
        ,CASE WHEN (((LENGTH(AUXILIAR) - LENGTH(REPLACE(AUXILIAR,'|',''))) = LENGTH(SENHA))
            AND (POS_AUX = LENGTH(SENHA) + 1)) THEN
            1
         WHEN (POSICAO >= (LENGTH(SENHA) * 2) + 2) AND (LENGTH(SENHA) > 1) THEN
            POS_AUX + 1
         WHEN (LENGTH(CRYPT) >= LENGTH(SENHA)) THEN 
            POS_AUX - 1
         ELSE
            POS_AUX
         END AS POS_AUX
         
        ,ORIGINAL
        ,CHANGED       
        
        ,CASE WHEN ((LENGTH(AUXILIAR) - LENGTH(REPLACE(AUXILIAR,'|',''))) = LENGTH(SENHA)) THEN
                AUXILIAR 
            WHEN (POSICAO >= ((LENGTH(SENHA) * 2) + 2)) AND (LENGTH(SENHA) > 1) THEN
               AUXILIAR || (INSTR(CHANGED, SUBSTR(INV_ORDEM, POS_AUX+1, 1)) - 1) || '|'  
            WHEN (LENGTH(SENHA) = 1) THEN
                CAST((INSTR(CHANGED, SUBSTR(INV_ORDEM,1,1)) - 1) AS VARCHAR(1)) 
         END AS AUXILIAR
         
        ,CASE WHEN (((LENGTH(AUXILIAR) - LENGTH(REPLACE(AUXILIAR,'|',''))) = LENGTH(SENHA))
               AND (POS_AUX = LENGTH(SENHA) + 1))
                OR (LENGTH(SENHA) = 1) THEN
                   AUXILIAR 
             WHEN ((LENGTH(AUXILIAR) - LENGTH(REPLACE(AUXILIAR,'|',''))) = LENGTH(SENHA))
              AND (POS_AUX <= LENGTH(SENHA))
              AND LENGTH(SENHA) > 1 THEN
                   SUBSTR(AFIM_AUX, INSTR(AFIM_AUX,'|') + 1, LENGTH(AFIM_AUX) - INSTR(AFIM_AUX,'|'))
             ELSE
                   AFIM_AUX
         END AS AFIM_AUX
         
        ,CASE WHEN (LENGTH(COALESCE(AFIM_AUX,'')) > 0) THEN
            CASE WHEN (LENGTH(SENHA) > 1) THEN
                AFIM 
                || SUBSTR(
                    CHANGED, 
                    MOD(
                        (12 * CAST(SUBSTR(AFIM_AUX, 1, INSTR(AFIM_AUX, '|') - 1) AS INT) + 14), 
                        LENGTH(CHANGED)
                    ) + 1, 
                    1
                )
            ELSE
               SUBSTR(
                    CHANGED, 
                    MOD(
                        (12 * (CAST(SUBSTR(AFIM_AUX, 1, 1) AS INT)) + 14), 
                        LENGTH(CHANGED)
                    ) + 1, 
                    1
               )  
            END
         END AS AFIM
         
    FROM VW_Criptografia
    WHERE POSICAO <= (LENGTH(SENHA) * 4) + 3
)
SELECT AFIM
FROM VW_CRIPTOGRAFIA
WHERE LENGTH(AFIM) = LENGTH(SENHA)
ORDER BY ID, POSICAO