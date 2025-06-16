WITH 
VW_Auxiliar
AS (SELECT ROWNUM AS LINHA,
           SUBSTR(CHANGED, LEVEL, 1) AS CARACT,
           CHANGED 
    FROM (SELECT ROWNUM AS LINHA,
                 'Üúùø÷öõôóòñðïîíìëêéèçæåäãâáàßÝÛÚÙØ×ÖÕÔÓÒÑÐÏÎÍÌËÊÉÈÇÆÅÄÃÂÁÀ¿¾½¼»º¹¸·¶µ´³²±°¯®Д¬«ª©¨§¦¥¤£¡ГБ' AS CHANGED 
          FROM DUAL)
    CONNECT BY LEVEL <= LENGTH(CHANGED)
)
,VW_Gcd
AS (SELECT LINHA
        ,MOD(LENGTH(CHANGED), MOD(LINHA, LENGTH(CHANGED))) GCD
    FROM VW_Auxiliar
)
,VW_GetCoprimo
AS (SELECT AA.LINHA
        ,MOD(AA.LINHA, (SELECT BB.GCD FROM VW_Gcd BB WHERE BB.LINHA = AA.LINHA)) COPR
    FROM VW_AUXILIAR AA 
    WHERE MOD(AA.LINHA, (SELECT BB.GCD FROM VW_Gcd BB WHERE BB.LINHA = AA.LINHA)) = 1
)
,VW_Criptografia(id
               ,senha
               ,crypt
               ,div_crypt
               ,encrypted
               ,char_atual
               ,posicao
               ,pos_aux
               ,original
               ,changed
               ,bloco
               ,coprimo
               ,matriz
               ,reserva
               ,auxiliar
               ,anterior
               ,contador
               ,virgula
               ,aux_bloco
               ,bloco_atual
               ,cont_blocos
               ,determinante
               ,teste
               ,matr_coprimo
               ,gcd
               ,cofatores) 
AS (SELECT AA.ID
        ,AA.SENHA
        ,'' CRYPT
        ,'' DIV_CRYPT
        ,'' ENCRYPTED
        ,SUBSTR(AA.SENHA, 1, 1) CHAR_ATUAL
        ,2 POSICAO
        ,LENGTH(AA.SENHA) POS_AUX
        ,'!#$%&''()*+,-./0123456789:;<=>?@abcdefghijklmnopqrstuvwxyz[]^_`ABCDEFGHIJKLMNOPQRSTUVWXYZ\Б' ORIGINAL 
        ,'Üúùø÷öõôóòñðïîíìëêéèçæåäãâáàßÝÛÚÙØ×ÖÕÔÓÒÑÐÏÎÍÌËÊÉÈÇÆÅÄÃÂÁÀ¿¾½¼»º¹¸·¶µ´³²±°¯®Д¬«ª©¨§¦¥¤£¡ГБ' CHANGED
        ,'' BLOCO
        ,1 COPRIMO
        ,'18,11,12;13,14,15;2,16,17' MATRIZ
        ,'19,12,13;14,15,16;3,17,18' RESERVA
       -- ,'18,11,12;13,14,15;2,16,17' AUXILIAR
        ,'' AUXILIAR
        ,'18,11,12;13,14,15;2,16,17' ANTERIOR
        ,0 CONTADOR
        ,0 VIRGULA
        ,'' AUX_BLOCO
        ,'' BLOCO_ATUAL
        ,1 CONT_BLOCOS
        ,0 DETERMINANTE
        ,0 TESTE
        ,'' MATR_COPRIMO
        ,0 GCD
        ,'' COFATORES
    FROM Usuario AA
    
    UNION ALL 
    
    SELECT ID
        ,SENHA
        
        ,CRYPT 
         || SUBSTR(CHANGED,
                       MOD(18 * 
                          (INSTR(
                              CHANGED, 
                              SUBSTR(CHANGED, INSTR(ORIGINAL,CHAR_ATUAL), 1)
                           ) - 1) + 20,
                          LENGTH(CHANGED) - 1
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
        
        ,CASE   
            WHEN (LENGTH(ENCRYPTED) = LENGTH(SENHA)) THEN   
                CASE
                    WHEN (REGEXP_COUNT(BLOCO, ',') = LENGTH(ENCRYPTED)) THEN
                         CASE 
                            WHEN MOD(LENGTH(SENHA), 3) = 0 THEN 
                                BLOCO || ';'
                            WHEN MOD(LENGTH(SENHA), 2) = 0 THEN
                                BLOCO || (INSTR(CHANGED,'Б') - 1) || ';' 
                            ELSE
                                BLOCO || (INSTR(CHANGED,'Б') - 1) || ',' || (INSTR(CHANGED,'Б') - 1) || ';'
                         END 
                    WHEN (LENGTH(ENCRYPTED) = LENGTH(SENHA)) AND (BLOCO is null) THEN
                        BLOCO || (INSTR(CHANGED, SUBSTR(ENCRYPTED, 1, 1)) - 1) || ','
                     WHEN (LENGTH(ENCRYPTED) = LENGTH(SENHA)) AND (BLOCO is not null) THEN   
                        BLOCO || (INSTR(CHANGED, SUBSTR(ENCRYPTED, POSICAO - ((LENGTH(SENHA) * 2) + 2), 1)) - 1) 
                END
            ELSE
                BLOCO
            END 
         AS BLOCO
         
         ,/*CASE    
            WHEN (AUX_BLOCO is not null) THEN 
                CASE
                    WHEN (COPRIMO < (SELECT MAX(AA.LINHA) FROM VW_GetCoprimo AA WHERE AA.LINHA > COPRIMO)) THEN    
                        (SELECT MIN(AA.LINHA) FROM VW_GetCoprimo AA WHERE AA.LINHA > COPRIMO)
                    ELSE
                        COPRIMO + 1
                END
            ELSE
                COPRIMO 
            END
          AS*/ 
          CASE    
             WHEN (AUX_BLOCO is not null) THEN
                CASE
                    WHEN (COPRIMO < (SELECT MAX(AA.LINHA) FROM VW_GetCoprimo AA)) THEN
                        (SELECT MIN(AA.LINHA) FROM VW_GetCoprimo AA WHERE AA.LINHA > COPRIMO)
                    ELSE
                        1
                END
             ELSE
                COPRIMO
             END 
          AS COPRIMO
                
         ,MATRIZ
         ,RESERVA
         
         
         ,CASE
            WHEN (LENGTH(AUX_BLOCO) >= LENGTH(SENHA)) AND (MOD(LENGTH(AUX_BLOCO),3) = 0) THEN   
                 CAST((CAST(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 1) AS INT) * COPRIMO) AS VARCHAR(75)) || ',' ||
                 CAST((CAST(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 2) AS INT) * COPRIMO) AS VARCHAR(75)) || ',' || 
                 CAST((CAST(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 3) AS INT) * COPRIMO) AS VARCHAR(75)) || ';' ||
                 CAST((CAST(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 1) AS INT) * COPRIMO) AS VARCHAR(75)) || ',' ||
                 CAST((CAST(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 2) AS INT) * COPRIMO) AS VARCHAR(75)) || ',' || 
                 CAST((CAST(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 3) AS INT) * COPRIMO) AS VARCHAR(75)) || ';' ||
                 CAST((CAST(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 1) AS INT) * COPRIMO) AS VARCHAR(75)) || ',' ||
                 CAST((CAST(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 2) AS INT) * COPRIMO) AS VARCHAR(75)) || ',' || 
                 CAST((CAST(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 3) AS INT) * COPRIMO) AS VARCHAR(75))
            ELSE
                MATRIZ
            END 
          AS AUXILIAR
         
         ,/*CASE
            WHEN (LENGTH(AUX_BLOCO) >= LENGTH(SENHA)) AND (MOD(LENGTH(AUX_BLOCO),3) = 0) THEN 
                AUXILIAR
            ELSE
                ''
            END 
          AS*/ AUXILIAR ANTERIOR
         
         ,CASE
            WHEN (CONTADOR = 3) THEN
                0
            ELSE
                CONTADOR
            END 
          AS CONTADOR
          
         ,REGEXP_COUNT(BLOCO,';') VIRGULA
         
         ,CASE 
             WHEN (BLOCO_ATUAL IS NOT NULL) THEN
                SUBSTR(CHANGED,
                        MOD(
                            (MOD(
                                 ((CAST(REGEXP_SUBSTR(BLOCO_ATUAL, '[^,]+', 1, 1) AS INT) * CAST(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 1) AS INT))
                                 + (CAST(REGEXP_SUBSTR(BLOCO_ATUAL, '[^,]+', 1, 2) AS INT) * CAST(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 2) AS INT))
                                 + (CAST(REGEXP_SUBSTR(BLOCO_ATUAL, '[^,]+', 1, 3) AS INT) * CAST(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 3) AS INT)))
                                , (LENGTH(CHANGED)))
                            + (LENGTH(CHANGED)))
                           , (LENGTH(CHANGED)))
                           + 1,
                        1) ||
                SUBSTR(CHANGED,
                        MOD(
                           (MOD(
                                 ((CAST(REGEXP_SUBSTR(BLOCO_ATUAL, '[^,]+', 1, 1) AS INT) * CAST(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 1) AS INT))
                                 + (CAST(REGEXP_SUBSTR(BLOCO_ATUAL, '[^,]+', 1, 2) AS INT) * CAST(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 2) AS INT))
                                 + (CAST(REGEXP_SUBSTR(BLOCO_ATUAL, '[^,]+', 1, 3) AS INT) * CAST(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 3) AS INT)))
                                , (LENGTH(CHANGED)))
                            + (LENGTH(CHANGED)))
                           , (LENGTH(CHANGED)))
                           + 1,
                        1) ||
                SUBSTR(CHANGED,
                         MOD(
                             (MOD(
                                 ((CAST(REGEXP_SUBSTR(BLOCO_ATUAL, '[^,]+', 1, 1) AS INT) * CAST(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 1) AS INT))
                                 + (CAST(REGEXP_SUBSTR(BLOCO_ATUAL, '[^,]+', 1, 2) AS INT) * CAST(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 2) AS INT))
                                 + (CAST(REGEXP_SUBSTR(BLOCO_ATUAL, '[^,]+', 1, 3) AS INT) * CAST(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 3) AS INT)))
                                , (LENGTH(CHANGED)))
                            + (LENGTH(CHANGED)))
                           , (LENGTH(CHANGED)))
                           + 1,
                        1)
             END
          AS AUX_BLOCO        
         
         ,CASE 
             WHEN (BLOCO_ATUAL is not null) THEN
                 SUBSTR(BLOCO_ATUAL, 1, INSTR(BLOCO_ATUAL, ';') - 1)
             ELSE
                SUBSTR(BLOCO, 1, INSTR(BLOCO, ';') - 1)
             END
          AS BLOCO_ATUAL   
          
         ,COALESCE(REGEXP_COUNT(BLOCO,';'),0) + COALESCE(REGEXP_COUNT(BLOCO,','),0)  CONT_BLOCOS
          
        ,REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 1) * 1* 
                (REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 2) 
                *  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 3)  
                -  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 3)  
                *  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 2))
         - REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 2) * 
                (REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 1)  
                *  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 3) 
                -  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 3)  
                *  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 1))
         + REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 3) * 
                (REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 1)  
                *  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 2)  
                -  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 2)  
                *  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 1)) DETERMINANTE
        
        ,(SELECT 
              MIN(CASE 
                WHEN iteracao = 1 THEN MOD(valor_inicial, divisor)
                ELSE MOD(
                  (SELECT MOD(valor_inicial, divisor) FROM DUAL),
                  divisor
                )
              END)
            FROM (SELECT 
                        (REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 1) * 
                                    (REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 2)  
                                    *  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 3)  
                                    -  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 2)  
                                    *  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 2))
                             - REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 2) * 
                                    (REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 1)  
                                    *  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 3)  
                                    -  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 3)  
                                    *  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 1))
                             + REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 3) * 
                                    (REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 1)  
                                    *  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 2)  
                                    -  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 2)  
                                    *  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 1))
                        ) AS valor_inicial,
                        LENGTH(CHANGED) AS divisor,
                        LEVEL AS iteracao
                  FROM DUAL
                  CONNECT BY LEVEL <= (REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 1) * 
                                                (REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 2)  
                                                *  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 3)  
                                                -  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 2)  
                                                *  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 2))
                                         - REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 2) * 
                                                (REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 1)  
                                                *  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 3)  
                                                -  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 3)  
                                                *  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 1))
                                         + REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 3) * 
                                                (REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 1)  
                                                *  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 2)  
                                                -  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 2)  
                                                *  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 1))
                                    )
                  )
          WHERE CASE 
                    WHEN iteracao = 1 THEN MOD(valor_inicial, divisor)
                    ELSE MOD(
                      (SELECT MOD(valor_inicial, divisor) FROM DUAL),
                      divisor
                    )
                END > 0                  
       ) TESTE
        
       , /*CAST((CAST(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 1) AS INT) * COPRIMO) AS VARCHAR(75)) || ',' ||
         CAST((CAST(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 2) AS INT) * COPRIMO) AS VARCHAR(75)) || ',' || 
         CAST((CAST(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 3) AS INT) * COPRIMO) AS VARCHAR(75)) || ';' ||
         CAST((CAST(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 1) AS INT) * COPRIMO) AS VARCHAR(75)) || ',' ||
         CAST((CAST(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 2) AS INT) * COPRIMO) AS VARCHAR(75)) || ',' || 
         CAST((CAST(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 3) AS INT) * COPRIMO) AS VARCHAR(75)) || ';' ||
         CAST((CAST(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 1) AS INT) * COPRIMO) AS VARCHAR(75)) || ',' ||
         CAST((CAST(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 2) AS INT) * COPRIMO) AS VARCHAR(75)) || ',' || 
         CAST((CAST(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 3) AS INT) * COPRIMO) AS VARCHAR(75))*/
          '' AS MATR_COPRIMO

        ,/*CASE
            WHEN (LENGTH(AUX_BLOCO) >= LENGTH(SENHA)) AND (MOD(LENGTH(AUX_BLOCO),3) = 0) THEN 
                (SELECT MIN(MOD(AA.LINHA, LENGTH(CHANGED)))--MOD(AA.LINHA, LENGTH(CHANGED)) GCD, AA.LINHA, AA.DETERMINANTE  
				FROM 
					(SELECT ROWNUM AS LINHA,
						   DETERMINANTE
					 FROM (SELECT ROWNUM AS LINHA,
								  (REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 1) * 1* 
											(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 2) 
											*  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 3)  
											-  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 3)  
											*  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 2))
									 - REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 2) * 
											(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 1)  
											*  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 3) 
											-  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 3)  
											*  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 1))
									 + REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 3) * 
											(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 1)  
											*  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 2)  
											-  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 2)  
											*  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 1))) DETERMINANTE
						   FROM DUAL)
					 CONNECT BY LEVEL <= (REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 1) * 1* 
												(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 2) 
												*  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 3)  
												-  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 3)  
												*  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 2))
										 - REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 2) * 
												(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 1)  
												*  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 3) 
												-  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 3)  
												*  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 1))
										 + REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 3) * 
												(REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 1)  
												*  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 2)  
												-  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 2)  
												*  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 1)))
					) AA
                )
            ELSE
                0
            END 
         AS*/ 0 GCD
        
        ,/*CASE 
             WHEN (BLOCO_ATUAL IS NOT NULL) THEN
                CAST(
                    (REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 2) 
                    * REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 3) 
                    - REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 3)
                    *  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 2))
                AS VARCHAR(75)) || ',' ||
                CAST(
                    (REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 1) 
                    * REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 3) 
                    - REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 3)
                    *  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 1))
                    * -1
                AS VARCHAR(75)) || ',' ||     
                CAST(
                    (REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 1) 
                    * REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 2) 
                    - REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 2), '[^,]+', 1, 2)
                    *  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 1))
                AS VARCHAR(75)) || ';' ||
                CAST(
                    (REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 2) 
                    * REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 3) 
                    - REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 1), '[^,]+', 1, 3)
                    *  REGEXP_SUBSTR(REGEXP_SUBSTR(AUXILIAR, '[^;]+', 1, 3), '[^,]+', 1, 2))
                AS VARCHAR(75))
            ELSE
                ''
            END 
          AS*/ '' COFATORES
       
    FROM VW_Criptografia
    WHERE POSICAO <= (LENGTH(SENHA) * 8) + 7
)
SELECT ENCRYPTED
    ,BLOCO_ATUAL
    ,BLOCO
    ,AUX_BLOCO
    ,REGEXP_COUNT(BLOCO, ',') virgula
    ,POSICAO
    ,MATRIZ
    ,RESERVA
    ,AUXILIAR
    ,ANTERIOR
    ,DETERMINANTE
    ,TESTE
    ,MATR_COPRIMO
    ,COFATORES
    ,COPRIMO
    ,GCD
FROM VW_CRIPTOGRAFIA
--WHERE LENGTH(ENCRYPTED) = LENGTH(SENHA)
ORDER BY ID, POSICAO