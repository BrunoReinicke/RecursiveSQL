WITH RECURSIVE
VW_Auxiliar AS (
    SELECT 
        @rownum := @rownum + 1 AS LINHA,
        SUBSTRING(CHANGED, n, 1) AS CARACT,
        CHANGED 
    FROM (
        SELECT 
            @rownum := 0,
            'Üúùø÷öõôóòñðïîíìëêéèçæåäãâáàßÝÛÚÙØ×ÖÕÔÓÒÑÐÏÎÍÌËÊÉÈÇÆÅÄÃÂÁÀ¿¾½¼»º¹¸·¶µ´³²±°¯®Д¬«ª©¨§¦¥¤£¡ГБ' AS CHANGED
    ) AS t
    JOIN (
        SELECT a.N + b.N * 10 + 1 AS n
        FROM 
            (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) AS a,
            (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) AS b
        ORDER BY n
    ) AS numbers
    WHERE n <= LENGTH(CHANGED)
),
VW_Gcd AS (
    SELECT 
        LINHA,
        MOD(LENGTH(CHANGED), MOD(LINHA, LENGTH(CHANGED))) AS GCD
    FROM VW_Auxiliar
),
VW_GetCoprimo AS (
    SELECT 
        AA.LINHA,
        MOD(AA.LINHA, (SELECT BB.GCD FROM VW_Gcd BB WHERE BB.LINHA = AA.LINHA)) AS COPR
    FROM VW_Auxiliar AA 
    WHERE MOD(AA.LINHA, (SELECT BB.GCD FROM VW_Gcd BB WHERE BB.LINHA = AA.LINHA)) = 1
),
VW_Criptografia AS (
    SELECT 
        AA.ID,
        AA.SENHA,
        CAST('' AS CHAR(85)) AS CRYPT,
        CAST('' AS CHAR(85)) AS DIV_CRYPT,
        CAST('' AS CHAR(85)) AS ENCRYPTED,
        SUBSTRING(AA.SENHA, 1, 1) AS CHAR_ATUAL,
        1 AS POSICAO,
        LENGTH(AA.SENHA) AS POS_AUX,
        '!#$%&''()*+,-./0123456789:;<=>?@abcdefghijklmnopqrstuvwxyz[]^_`ABCDEFGHIJKLMNOPQRSTUVWXYZ\Б' AS ORIGINAL,
        'Üúùø÷öõôóòñðïîíìëêéèçæåäãâáàßÝÛÚÙØ×ÖÕÔÓÒÑÐÏÎÍÌËÊÉÈÇÆÅÄÃÂÁÀ¿¾½¼»º¹¸·¶µ´³²±°¯®Д¬«ª©¨§¦¥¤£¡ГБ' AS CHANGED,
        CAST('' AS CHAR(85)) AS BLOCO,
        1 AS COPRIMO,
        '18,11,12;13,14,15;2,16,17' AS MATRIZ,
        '19,12,13;14,15,16;3,17,18' AS RESERVA,
        '18,11,12;13,14,15;2,16,17' AS AUXILIAR,
        '18,11,12;13,14,15;2,16,17' AS ANTERIOR,
        0 AS CONTADOR,
        0 AS VIRGULA,
        CAST('' AS CHAR(85)) AS AUX_BLOCO,
        CAST('' AS CHAR(85)) AS BLOCO_ATUAL,
        1 AS CONT_BLOCOS,
        CAST('' as CHAR(85)) AS DETERMINANTE,
        '18,11,12;13,14,15;2,16,17' AS MATR_COPRIMO,
        0 AS GCD,
        0 AS DIVIDENDO,
        0 AS DIVISOR,
        0 AS RESTO
    FROM USUARIO_A AA
    WHERE AA.ID = 1 
    
    UNION ALL
    
    SELECT 
        C.ID,
        C.SENHA,
        
        CASE 
            WHEN (LENGTH(C.CRYPT) < LENGTH(C.SENHA)) THEN
                CONCAT(
                    C.CRYPT,
                    SUBSTRING(
                        C.CHANGED,
                        CAST(MOD(18 * (LOCATE(C.CHAR_ATUAL,C.ORIGINAL) - 1) + 20, ((LENGTH(C.CHANGED) / 2) - 1)) AS UNSIGNED) + 1,
                        1
                    )
                )
            ELSE
                C.CRYPT
        END AS CRYPT,
        
        CASE WHEN MOD(LENGTH(C.SENHA), 2) <> 0 THEN
            CONCAT(
                SUBSTRING(
                    C.CRYPT, 
                    FLOOR(LENGTH(C.SENHA) / 2) + 2, 
                    LENGTH(C.SENHA) - FLOOR(LENGTH(C.SENHA) / 2) + 2
                ),
                SUBSTRING(C.CRYPT, FLOOR(LENGTH(C.SENHA) / 2) + 1, 1),
                SUBSTRING(C.CRYPT, 1, FLOOR(LENGTH(C.SENHA) / 2))
            )
        ELSE
            CONCAT(
                SUBSTRING(
                    C.CRYPT, 
                    FLOOR(LENGTH(C.SENHA) / 2) + 1, 
                    LENGTH(C.SENHA) - FLOOR(LENGTH(C.SENHA) / 2) + 1
                ),
                SUBSTRING(C.CRYPT, 1, FLOOR(LENGTH(C.SENHA) / 2))
            )
        END AS DIV_CRYPT,
         
        CASE when ((cast(((LENGTH(C.CRYPT) - (LENGTH(REPLACE(C.CRYPT, '¨', '')))) / 2) as unsigned) + LENGTH(REPLACE(C.CRYPT, '¨', ''))) 
        	= LENGTH(C.SENHA))
            AND (C.POSICAO <= (LENGTH(C.SENHA) * 2) + 2) THEN 
              CONCAT(C.ENCRYPTED, SUBSTRING(C.DIV_CRYPT, C.POS_AUX + 1, 1)) 
        ELSE
            C.ENCRYPTED
        END AS ENCRYPTED,

        SUBSTRING(C.SENHA, C.POSICAO, 1) AS CHAR_ATUAL,
        C.POSICAO + 1,
        
        CASE 
	        when (C.POS_AUX = -1) then 
             	0
	        when ((cast(((LENGTH(C.CRYPT) - (LENGTH(REPLACE(C.CRYPT, '¨', '')))) / 2) as unsigned) + LENGTH(REPLACE(C.CRYPT, '¨', ''))) 
        	  >= LENGTH(C.SENHA)) THEN 
                C.POS_AUX - 1
            ELSE
                C.POS_AUX
        END AS POS_AUX,
         
        C.ORIGINAL,
        C.CHANGED,
        
       CASE when ((cast(((LENGTH(C.ENCRYPTED) - (LENGTH(REPLACE(C.ENCRYPTED, '¨', '')))) / 2) as unsigned) + LENGTH(REPLACE(C.ENCRYPTED, '¨', ''))) 
        	= LENGTH(C.SENHA)) then
        	CASE
                WHEN ((/*(LENGTH(C.BLOCO) -*/ LENGTH(REPLACE(C.BLOCO, ',', '')) = (cast(((LENGTH(C.ENCRYPTED) - (LENGTH(REPLACE(C.ENCRYPTED, '¨', '')))) / 2) as unsigned) + LENGTH(REPLACE(C.ENCRYPTED, '¨', '')))) 
                    and (C.BLOCO is not NULL)) THEN
                	CASE 
                        WHEN MOD(LENGTH(C.SENHA), 3) = 0 THEN 
                           CONCAT(C.BLOCO, ';')
                        WHEN MOD(LENGTH(C.SENHA), 2) = 0 THEN
                           CONCAT(C.BLOCO, (INSTR(C.CHANGED,'Б') - 1), ';')
                        ELSE
                           CONCAT(C.BLOCO, (INSTR(C.CHANGED,'Б') - 1), ',', (INSTR(C.CHANGED,'Б') - 1), ';')
                    END
           
                WHEN ((cast(((LENGTH(C.ENCRYPTED) - (LENGTH(REPLACE(C.ENCRYPTED, '¨', '')))) / 2) as unsigned) + LENGTH(REPLACE(C.ENCRYPTED, '¨', ''))) = LENGTH(C.SENHA)) 
               		AND (C.BLOCO IS NULL) THEN
                       CONCAT(C.BLOCO, (INSTR(C.CHANGED, SUBSTRING(C.ENCRYPTED, 1, 1)) - 1), ',')
                WHEN ((cast(((LENGTH(C.ENCRYPTED) - (LENGTH(REPLACE(C.ENCRYPTED, '¨', '')))) / 2) as unsigned) + LENGTH(REPLACE(C.ENCRYPTED, '¨', ''))) = LENGTH(C.SENHA)) 
                	AND (C.BLOCO IS NOT NULL) THEN 
                		case 
                			when ((INSTR(C.CHANGED, SUBSTRING(C.ENCRYPTED, C.POSICAO - (LENGTH(C.SENHA) * 2 + 2), 1))) > 0) then 
                			    CONCAT(C.BLOCO, (INSTR(C.CHANGED, SUBSTRING(C.ENCRYPTED, C.POSICAO - (LENGTH(C.SENHA) * 2 + 2), 1)) - 1))
                			else 
                				C.BLOCO
                		end
                END
            else
            	case
            		when ((cast(((LENGTH(C.ENCRYPTED) - (LENGTH(REPLACE(C.ENCRYPTED, '¨', '')))) / 2) as unsigned) + LENGTH(REPLACE(C.ENCRYPTED, '¨', ''))) <> 0) then 
            			(cast(((LENGTH(C.ENCRYPTED) - (LENGTH(REPLACE(C.ENCRYPTED, '¨', '')))) / 2) as unsigned) + LENGTH(REPLACE(C.ENCRYPTED, '¨', '')))
            		else 
            			C.BLOCO
            	end
         END as BLOCO,

       /* CASE
             WHEN ((MOD(DIVIDENDO, DIVISOR) = 0) AND (RESTO <> 1)) 
                AND (CONTADOR < 2) then 
                1
             else 
             	1
             END
        AS*/ 1 COPRIMO,
        
        C.MATRIZ,
        C.RESERVA,
        C.MATRIZ AS AUXILIAR,
        C.AUXILIAR AS ANTERIOR,
        0 AS CONTADOR,
        0 AS VIRGULA,
        CAST('' AS CHAR(85)) AS AUX_BLOCO,
        CAST('' AS CHAR(85)) AS BLOCO_ATUAL,
        0 AS CONT_BLOCOS,
        
        -- SUBSTRING(@matriz, 1, CHARINDEX(';', @matriz) - 1)
        -- matriz[1][1] * matriz[2][2] - matriz[1][2] * matriz[2][1]
		
        	/*LOCATE(',',
	     			substring(C.AUXILIAR, 
	     		      LOCATE(';', C.AUXILIAR) + 1,
	     		      (LOCATE(';', C.AUXILIAR) + 1) - 2)
	     		    ,length(C.AUXILIAR) - LOCATE(';', C.AUXILIAR)) 
        	CONCAT(SUBSTRING(
				        substring(C.AUXILIAR, 
				     		      LOCATE(';', C.AUXILIAR) + 1,
				     		      (LOCATE(';', C.AUXILIAR) + 1) - 2)
				     	,LOCATE(',',
				     			substring(C.AUXILIAR, 
				     		      LOCATE(';', C.AUXILIAR) + 1,
				     		      (LOCATE(';', C.AUXILIAR) + 1) - 2)
				     		    ,1) 
				     		    + 1),
	        	 CAST(SUBSTRING(
				        substring(C.AUXILIAR, 
				     		      LOCATE(';', C.AUXILIAR) + 1,
				     		      (LOCATE(';', C.AUXILIAR) + 1) - 2)
				     	,LOCATE(',',
				     			substring(C.AUXILIAR, 
				     		      LOCATE(';', C.AUXILIAR) + 1,
				     		      (LOCATE(';', C.AUXILIAR) + 1) - 2)
				     		    ,1) 
				     		    + 1)
					 as unsigned)  *
			        	cast(
				        	SUBSTRING(SUBSTRING(
									        substring(C.AUXILIAR, 
									     		      LOCATE(';', C.AUXILIAR) + 1,
									     		      (LOCATE(';', C.AUXILIAR) + 1) - 2)
									     	,LOCATE(',',
									     			substring(C.AUXILIAR, 
									     		      LOCATE(';', C.AUXILIAR) + 1,
									     		      (LOCATE(';', C.AUXILIAR) + 1) - 2)
									     		    ,1) 
									     		    + 1)
									   ,1
						        	   ,LOCATE(','
											   ,SUBSTRING(
											        substring(C.AUXILIAR, 
											     		      LOCATE(';', C.AUXILIAR) + 1,
											     		      (LOCATE(';', C.AUXILIAR) + 1) - 2)
											     	,LOCATE(',',
											     			substring(C.AUXILIAR, 
											     		      LOCATE(';', C.AUXILIAR) + 1,
											     		      (LOCATE(';', C.AUXILIAR) + 1) - 2)
											     		    ,1)
											     		   ) + 1
											   )
										)
								as unsigned) 
							)
						) */
        			SUBSTRING(
				        substring(C.AUXILIAR, 
				     		      LOCATE(';', C.AUXILIAR) + 1,
				     		      (LOCATE(';', C.AUXILIAR) + 1) - 2)
				     	,LOCATE(',',
				     			substring(C.AUXILIAR, 
				     		      LOCATE(';', C.AUXILIAR) + 1,
				     		      (LOCATE(';', C.AUXILIAR) + 1) - 2)
				     		    ,1) 
				     		    + 1)
        				DETERMINANTE,        
        		  
        C.MATR_COPRIMO,
        C.GCD,
        
        case 
        	when (C.DIVIDENDO = 0) then 
        		(LOCATE(C.CHAR_ATUAL,C.ORIGINAL) - 1)
        	else 
        		RESTO
            end 
        as DIVIDENDO,
        
        cast((length(C.CHANGED) / 2) as unsigned) DIVISOR,
        
        mod((LOCATE(C.CHAR_ATUAL,C.ORIGINAL) - 1), cast((length(C.CHANGED) / 2) as unsigned)) RESTO
        
    FROM USUARIO_A AA
    JOIN VW_Criptografia C ON AA.ID = C.ID
    WHERE C.POSICAO <= (LENGTH(AA.SENHA) * 7) 
)
SELECT * 
FROM VW_Criptografia;