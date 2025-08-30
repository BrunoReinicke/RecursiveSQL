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
)
,
VW_Criptografia AS (
    SELECT 
        AA.ID,
        AA.SENHA,
        CAST('' AS CHAR(85)) AS CRYPT,
        CAST('' AS CHAR(85)) AS DIV_CRYPT,
        CAST('' AS CHAR(85)) AS ENCRYPTED,
        CAST('' as CHAR(85)) AS CHAR_ATUAL,
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

        case 
        	when (C.CHAR_ATUAL <> '') 
        	  and ((cast(((LENGTH(C.CRYPT) - (LENGTH(REPLACE(C.CRYPT, '¨', '')))) / 2) as unsigned) + LENGTH(REPLACE(C.CRYPT, '¨', ''))) < LENGTH(C.SENHA)) then 
        		CONCAT(
                    C.CRYPT,
                    SUBSTRING(
                        C.CHANGED,
                        CAST(MOD(18 * (LOCATE(C.CHAR_ATUAL,C.ORIGINAL) - 1) + 20, ((LENGTH(C.CHANGED) / 2) - 1)) AS UNSIGNED) + 1,
                        1
                    )
                )
        	else
        		C.CRYPT
        	end
        as CRYPT,
        
       CASE 
	        when (CHAR_LENGTH(C.CRYPT) = CHAR_LENGTH(C.SENHA)) THEN
		        CASE WHEN MOD(LENGTH(C.SENHA), 2) <> 0 then
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
		            	SUBSTRING(C.CRYPT, 1, FLOOR(LENGTH(C.SENHA) / 2)),
		                SUBSTRING(
		                    C.CRYPT, 
		                    FLOOR(LENGTH(C.SENHA) / 2) + 1, 
		                    LENGTH(C.SENHA) - FLOOR(LENGTH(C.SENHA) / 2) + 1
		                )
		            )
		        end
		    else 
		    	''
	   		end 
	   	as DIV_CRYPT,
         
       case 
        	when (INSTR(C.BLOCO, ';') = 0) 
        	  AND (((cast(((LENGTH(C.CRYPT) - (LENGTH(REPLACE(C.CRYPT, '¨', '')))) / 2) as unsigned) + LENGTH(REPLACE(C.CRYPT, '¨', ''))) = LENGTH(C.SENHA))
		      AND (C.POSICAO <= (LENGTH(C.SENHA) * 2) + 2)) THEN 
		         CONCAT(C.ENCRYPTED, SUBSTRING(C.DIV_CRYPT, C.POS_AUX + 1, 1)) 
        else 
        	'Teste'
        end as ENCRYPTED,

       COALESCE(case
			        when ((cast(((LENGTH(C.CRYPT) - (LENGTH(REPLACE(C.CRYPT, '¨', '')))) / 2) as unsigned) + LENGTH(REPLACE(C.CRYPT, '¨', ''))) < LENGTH(C.SENHA)) THEN 
		        	CASE
				        when (C.CHAR_ATUAL = '') then
				        	SUBSTRING(AA.SENHA, 1, 1) 
		        		else 
		        			SUBSTRING(C.SENHA, C.POSICAO, 1)
		            end 
	            end
	           ,'') AS CHAR_ATUAL,
        
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
        
        case 
        	when (CHAR_LENGTH(C.DIV_CRYPT) = CHAR_LENGTH(C.SENHA)) THEN
	         CASE 
			    WHEN ((LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ',', ''))) = 2) AND (RIGHT(C.BLOCO, 1) = ';') then
			    	CONCAT(
					    CONCAT(
						    	SUBSTRING(
								    		CONVERT(C.CHANGED USING utf8mb4) COLLATE utf8mb4_bin
									    	,MOD(	
										    	MOD(
									    		    (cast(substring_INDEX(replace(C.BLOCO, ';', ''), ',', 1) as unsigned)
											    	* cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', 1) as unsigned)
											    	) +
											     	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(replace(C.BLOCO, ';', ''), ',', 2), ',', -1) as unsigned)
											        * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', 2), ',', -1) as unsigned)
											    	) +
											    	(cast(substring_INDEX(replace(C.BLOCO, ';', ''), ',', -1) as unsigned)
											        * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', -1) as unsigned)
											    	)
											    	,cast((length(C.CHANGED) / 2) as unsigned)
												  ) 
												 + cast((length(C.CHANGED) / 2) as unsigned)
											    ,cast((length(C.CHANGED) / 2) as unsigned)
											 ) + 1
											 ,1
								)
								,SUBSTRING(
											CONVERT(C.CHANGED USING utf8mb4) COLLATE utf8mb4_bin
											,MOD(
												MOD(
													(cast(substring_INDEX(replace(C.BLOCO, ';', ''), ',', 1) as unsigned)
											    	 * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', 1) as unsigned)
											    	) +
											    	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(replace(C.BLOCO, ';', ''), ',', 2), ',', -1) as unsigned)
											    	* cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', 2), ',', -1) as unsigned)
											    	) +
											    	(cast(substring_INDEX(replace(C.BLOCO, ';', ''), ',', -1) as unsigned)
											    	 * CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', 2), ',', -1) as UNSIGNED)
											    	)
											    	,cast((length(C.CHANGED) / 2) as unsigned)
											    )
											    + cast((length(C.CHANGED) / 2) as unsigned)
											    ,cast((length(C.CHANGED) / 2) as unsigned)
											 )
											 ,1
								)
						)	
						,SUBSTRING(
								   CONVERT(C.CHANGED USING utf8mb4) COLLATE utf8mb4_bin
								   ,MOD(
										MOD(
											(cast(substring_INDEX(replace(C.BLOCO, ';', ''), ',', 1) as unsigned)
											 * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', 1) as unsigned)
											 ) +
											 (cast(SUBSTRING_INDEX(substring_INDEX(replace(C.BLOCO, ';', ''), ',', 2), ',', -1) as unsigned)
											 * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', 2), ',', -1) as unsigned)
											 ) +
											 (CAST(substring_INDEX(replace(C.BLOCO, ';', ''), ',', -1) as UNSIGNED)
											 * CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', -1) as UNSIGNED)
											 )
											 ,cast((length(C.CHANGED) / 2) as unsigned)
										)
										+ cast((length(C.CHANGED) / 2) as unsigned)
										,cast((length(C.CHANGED) / 2) as unsigned)
									) + 1
									,1
							)
					)
					
				WHEN (mod(LENGTH(C.SENHA), 3) = 0) THEN
			       CONCAT(C.BLOCO, 
		               		CONCAT(INSTR(
									  CONVERT(CHANGED USING utf8mb4) COLLATE utf8mb4_bin, 
									  CONVERT(SUBSTRING(C.DIV_CRYPT, 1, 1) USING utf8mb4) COLLATE utf8mb4_bin
									) - 1, ','
								)
							)
					
			    when (mod(LENGTH(C.SENHA), 2) = 0) then
			        CASE
			            WHEN C.BLOCO = '' THEN
			               CONCAT(C.BLOCO, 
			               		CONCAT(INSTR(
										  CONVERT(CHANGED USING utf8mb4) COLLATE utf8mb4_bin, 
										  CONVERT(SUBSTRING(C.DIV_CRYPT, 1, 1) USING utf8mb4) COLLATE utf8mb4_bin
										) - 1, ','
									)
								)
			            WHEN (LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ',', ''))) = 1 THEN
			               CONCAT(C.BLOCO, 
			               		CONCAT(INSTR(
										  CONVERT(CHANGED USING utf8mb4) COLLATE utf8mb4_bin, 
										  CONVERT(SUBSTRING(C.DIV_CRYPT, 2, 1) USING utf8mb4) COLLATE utf8mb4_bin
										) - 1, ','
									)
								)
			            WHEN (LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ',', ''))) = 2 THEN
			                CONCAT(C.BLOCO, '89;')
			            ELSE
			                C.BLOCO
			    end
	
			   when (0 not in (mod(LENGTH(C.SENHA),3), mod(LENGTH(C.SENHA),2))) then
			       case 
						when C.BLOCO = '' then
							CONCAT(C.BLOCO, 
			               		CONCAT(INSTR(
										  CONVERT(CHANGED USING utf8mb4) COLLATE utf8mb4_bin, 
										  CONVERT(SUBSTRING(C.DIV_CRYPT, 1, 1) USING utf8mb4) COLLATE utf8mb4_bin
										), ','
									)
								)
						WHEN (LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ',', ''))) IN (1,2) then
						  CONCAT(C.BLOCO, '89,89;')
			            ELSE
			              C.BLOCO
					end
			   end
		 else
			coalesce(C.BLOCO, '')
	 	 end as BLOCO,

         (select MAX(COPR) from VW_GetCoprimo) as COPRIMO,
        
        C.MATRIZ,
        C.RESERVA,
        C.MATRIZ AS AUXILIAR,
        C.AUXILIAR AS ANTERIOR,
        0 AS CONTADOR,
        0 AS VIRGULA,
        CAST('' AS CHAR(85)) AS AUX_BLOCO,
        
        case 
        	when (CHAR_LENGTH(C.DIV_CRYPT) = CHAR_LENGTH(C.SENHA)) then
        		CASE 
			    	WHEN ((LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ',', ''))) = 2) AND (INSTR(C.BLOCO, ';') > 0) then
			    		'1'
			    	else
			    		'0'
			    END
        	else
        		C.BLOCO_ATUAL
        	end
        as BLOCO_ATUAL,
        
        0 AS CONT_BLOCOS,
        
        CONCAT(
	        cast(
		        SUBSTRING_INDEX(
			        SUBSTRING_INDEX(
						SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1),
						',',
						2
					),
					',',
					-1
				)
			as unsigned)
		   ,SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', -1)
		) DETERMINANTE,        
	        		  
        C.MATR_COPRIMO,
        C.GCD,
        
        case 
        	when (C.DIVIDENDO = 0) then 
        		(LOCATE(C.CHAR_ATUAL,C.ORIGINAL) - 1)
        	when (C.DIVISOR = 0) then
        		C.RESTO
        	else
        		C.DIVISOR
            end 
        as DIVIDENDO,
        
        case
        	when (C.RESTO = 0) then
        		cast((length(C.CHANGED) / 2) as unsigned)
        	when (C.DIVIDENDO = 0) then
        		C.RESTO
        end DIVISOR,
        
        case
        	when (C.RESTO = 0) then
        		mod((LOCATE(C.CHAR_ATUAL,C.ORIGINAL) - 1), cast((length(C.CHANGED) / 2) as unsigned))
        	else
        		RESTO
        end RESTO
        
    FROM USUARIO_A AA
    JOIN VW_Criptografia C ON AA.ID = C.ID
    WHERE C.POSICAO <= (LENGTH(AA.SENHA) * 6) 
)
SELECT *
FROM VW_Criptografia