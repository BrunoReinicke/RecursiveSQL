WITH RECURSIVE
VW_Auxiliar AS (
    SELECT 
        @rownum := @rownum + 1 AS LINHA,
        SUBSTRING(ORIGINAL, n, 1) AS CARACT,
        ORIGINAL 
    FROM (
        SELECT 
            @rownum := 0,
            'Üúùø÷öõôóòñðïîíìëêéèçæåäãâáàßÝÛÚÙØ×ÖÕÔÓÒÑÐÏÎÍÌËÊÉÈÇÆÅÄÃÂÁÀ¿¾½¼»º¹¸·¶µ´³²±°¯®Д¬«ª©¨§¦¥¤£¡ГБ' AS ORIGINAL
    ) AS t
    JOIN (
        SELECT a.N + b.N * 10 + 1 AS n
        FROM 
            (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) AS a,
            (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) AS b
        ORDER BY n
    ) AS numbers
    WHERE n <= CHAR_LENGTH(ORIGINAL)
),
VW_GetGCD as ( 	-- Calcula MDC entre LINHA e 90 usando algoritmo de Euclides
	select 
	    LINHA,
	    CARACT,
	    LINHA as input_a,
	    90 as input_b,
	    case
		    WHEN 90 = 0 THEN LINHA
	        WHEN LINHA % 90 = 0 THEN 90
	        WHEN 90 % (LINHA % 90) = 0 THEN (LINHA % 90)
	        WHEN (LINHA % 90) % (90 % (LINHA % 90)) = 0 THEN (90 % (LINHA % 90))
	        WHEN (90 % (LINHA % 90)) % ((LINHA % 90) % (90 % (LINHA % 90))) = 0 
	             THEN ((LINHA % 90) % (90 % (LINHA % 90)))
	        WHEN ((LINHA % 90) % (90 % (LINHA % 90))) % 
	             ((90 % (LINHA % 90)) % ((LINHA % 90) % (90 % (LINHA % 90)))) = 0
	             THEN ((90 % (LINHA % 90)) % ((LINHA % 90) % (90 % (LINHA % 90))))
	        WHEN ((90 % (LINHA % 90)) % ((LINHA % 90) % (90 % (LINHA % 90)))) %
	             (((LINHA % 90) % (90 % (LINHA % 90))) % 
	              ((90 % (LINHA % 90)) % ((LINHA % 90) % (90 % (LINHA % 90))))) = 0
	             THEN (((LINHA % 90) % (90 % (LINHA % 90))) % 
	                   ((90 % (LINHA % 90)) % ((LINHA % 90) % (90 % (LINHA % 90)))))
	        when (((LINHA % 90) % (90 % (LINHA % 90))) % 
	       		 ((90 % (LINHA % 90)) % ((LINHA % 90) % (90 % (LINHA % 90))))) %
	       		 (((90 % (LINHA % 90)) % ((LINHA % 90) % (90 % (LINHA % 90)))) %
	             (((LINHA % 90) % (90 % (LINHA % 90))) % 
	              ((90 % (LINHA % 90)) % ((LINHA % 90) % (90 % (LINHA % 90)))))) = 0
	             then (((90 % (LINHA % 90)) % ((LINHA % 90) % (90 % (LINHA % 90)))) %
		              (((LINHA % 90) % (90 % (LINHA % 90))) % 
		              ((90 % (LINHA % 90)) % ((LINHA % 90) % (90 % (LINHA % 90))))))
	        ELSE 0
	    END as gcd_result
	FROM VW_Auxiliar
),
VW_GetCoprimo as (	-- Filtrar apenas números COPRIMOS (relativamente primos) com 90
	select 
		LINHA,
		CARACT,
		INPUT_A,
		INPUT_B,
		GCD_Result
	from VW_GetGCD
	where GCD_Result = 1
),
VW_Criptografia AS (
    SELECT 
        AA.ID,
        AA.SENHA,
        CAST('' AS CHAR(500)) AS CRYPT,
        CAST('' AS CHAR(500)) AS DIV_CRYPT,
        CAST('' AS CHAR(500)) AS ENCRYPTED,
        CAST('' as CHAR(500)) AS CHAR_ATUAL,
        1 AS POSICAO,
        LENGTH(AA.SENHA) AS POS_AUX,
        '!#$%&''()*+,-./0123456789:;<=>?@abcdefghijklmnopqrstuvwxyz[]^_`ABCDEFGHIJKLMNOPQRSTUVWXYZ\Б' AS CHANGED,
        'Üúùø÷öõôóòñðïîíìëêéèçæåäãâáàßÝÛÚÙØ×ÖÕÔÓÒÑÐÏÎÍÌËÊÉÈÇÆÅÄÃÂÁÀ¿¾½¼»º¹¸·¶µ´³²±°¯®Д¬«ª©¨§¦¥¤£¡ГБ' AS ORIGINAL,
        CAST('' AS CHAR(500)) AS BLOCO,
        1 AS COPRIMO,
        0 as COPRIMO_AUX,
        '18,11,12;13,14,15;2,16,17' AS MATRIZ,
        '18,11,12;13,14,15;2,16,17' AS AUXILIAR,
        CAST('' AS CHAR(500)) AS ANTERIOR,
        0 AS CONTADOR,
        0 as CONTADOR_2,
        CAST('' AS CHAR(500)) AS AUX_BLOCO,
        CAST('' AS CHAR(500)) AS BLOCO_ATUAL,
        CAST('' AS CHAR(500)) AS BLOCO_ANT,        
        0 AS CONT_BLOCOS,
        0 as CONT_BLOCOS_AUX,
        1 as LINHA,
        CAST('' AS CHAR(500)) AS COFATORES,
        CAST('' AS CHAR(500)) AS ADJUNTA,
        0 as DETERMINANTE,
        0 as INV_MODULAR,
        CAST('' as CHAR(500)) as INVERSA,
        CAST('' as CHAR(500)) as DECIFRADO
    FROM USUARIO_B AA
    
    union all
   
    select 
    	C.ID,
        C.SENHA,
        C.CRYPT,  
        C.DIV_CRYPT,
        C.ENCRYPTED,
        C.CHAR_ATUAL,
        C.POSICAO, 
        C.POS_AUX,
        C.CHANGED,
        C.ORIGINAL,
        C.BLOCO,
        C.COPRIMO,
        C.COPRIMO_AUX,
        C.MATRIZ,
        C.AUXILIAR,
        C.ANTERIOR,
        C.CONTADOR,
        C.CONTADOR_2,
        
        case 
	        when ((LENGTH(C.BLOCO_ATUAL) - LENGTH(REPLACE(C.BLOCO_ATUAL, ',', '')))
	        	+ (LENGTH(C.BLOCO_ATUAL) - LENGTH(REPLACE(C.BLOCO_ATUAL, ';', ''))))
	        	< CHAR_LENGTH(C.SENHA) THEN
	        	CASE
		        	when (coalesce(C.AUX_BLOCO,'') = '') then
		        		C.SENHA
		        	else
		        		SUBSTRING(C.AUX_BLOCO, 2, length(C.AUX_BLOCO))
	        	end
	        else
	        	''
        	END
        as AUX_BLOCO,
        
        case
	        when (coalesce(C.INVERSA,'') <> '') then 
	        	SUBSTRING_INDEX(C.BLOCO_ATUAL, ';', - (LENGTH(C.BLOCO_ATUAL) - LENGTH(REPLACE(C.BLOCO_ATUAL, ';', ''))))
        	when (coalesce(C.AUX_BLOCO,'') <> '') and (coalesce(C.INVERSA,'') = '') then
        		case 
	        		when (MOD( 
		        			((LENGTH(C.BLOCO_ATUAL) - LENGTH(REPLACE(C.BLOCO_ATUAL, ',', '')))
		        			 + (LENGTH(C.BLOCO_ATUAL) - LENGTH(REPLACE(C.BLOCO_ATUAL, ';', ''))))
		        			 ,3) = 0)
		        		  or (MOD( 
			        			 (LENGTH(C.BLOCO_ATUAL) - LENGTH(REPLACE(C.BLOCO_ATUAL, ',', '')))
			        			 ,2) <> 0) THEN
		        		CONCAT(C.BLOCO_ATUAL,
		        			   INSTR(
								  CONVERT(ORIGINAL USING utf8mb4) COLLATE utf8mb4_bin, 
								  CONVERT(SUBSTRING(C.AUX_BLOCO, 1, 1) USING utf8mb4) 
								  COLLATE utf8mb4_bin
								) - 1,
								','
							)
					 else
					 	CONCAT(C.BLOCO_ATUAL,
		        			   INSTR(
								  CONVERT(ORIGINAL USING utf8mb4) COLLATE utf8mb4_bin, 
								  CONVERT(SUBSTRING(C.AUX_BLOCO, 1, 1) USING utf8mb4) 
								  COLLATE utf8mb4_bin
								) - 1,
								';'
							)
					END
        	else
        		C.BLOCO_ATUAL
        	end
        as BLOCO_ATUAL,
        
        C.BLOCO_ANT,
		C.CONT_BLOCOS,
		C.CONT_BLOCOS_AUX, 
		C.LINHA + 1 LINHA,
		
		case 
			when ((LENGTH(C.BLOCO_ATUAL) - LENGTH(REPLACE(C.BLOCO_ATUAL, ',', '')))
	          + (LENGTH(C.BLOCO_ATUAL) - LENGTH(REPLACE(C.BLOCO_ATUAL, ';', '')))) 
	          = CHAR_LENGTH(C.SENHA) then
	           CONCAT(
		        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED)
		        	* cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', -1) as SIGNED)
		        	- CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', -1) as SIGNED)
		        	* CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', 2), ',', -1) as SIGNED)),  -- cofatores[0][0]
		        	',',
		        	((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', 1) as SIGNED)
		        	  * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', -1) as SIGNED)
		        	  - CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', -1) as SIGNED)
		        	  * CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', 1) as SIGNED)) 
	        	      * -1),   -- cofatores[0][1]
	        	    ',',
	        	    (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', 1) as SIGNED)
		        	  * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', 2), ',', -1) as SIGNED)
		        	  - CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED)
		        	  * CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', 1) as SIGNED)),  -- cofatores[0][2]
		            ';',
		            ((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', 2), ',', -1) as SIGNED)
		        	  * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', -1) as SIGNED)
		        	  - CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', -1) as SIGNED)
		        	  * CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', 2), ',', -1) as SIGNED))
		        	  * -1),  -- cofatores[1][0] 
		        	',',
		        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', 1) as SIGNED)
		        	  * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', -1) as SIGNED)
		        	  - cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', -1) as SIGNED)
		        	  * CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', 1) as SIGNED)),  -- cofatores[1][1]
		        	',', 
		        	((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', 1) as SIGNED)
		        	  * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', 2), ',', -1) as SIGNED)
		        	  - cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', 2), ',', -1) as SIGNED)
		        	  * CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', 1) as SIGNED))
		        	  * -1),  -- cofatores[1][2]
		        	';',
		        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', 2), ',', -1) as SIGNED)
		        	  * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', -1) as SIGNED)
		        	  - CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', -1) as SIGNED)
		        	  * CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED)),  -- cofatores[2][0] 
		        	',',
		        	((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', 1) as SIGNED)
		        	  * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', -1) as SIGNED)
		        	  - CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', -1) as SIGNED)
		        	  * CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', 1) as SIGNED))
		        	  * -1),  -- cofatores[2][1] 
		        	',',  
		        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', 1) as SIGNED)
		        	  * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED)
		        	  - CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', 2), ',', -1) as SIGNED)
		        	  * CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', 1) as SIGNED))  -- cofatores[2][2] 
		        )
	        else
	        	''
			end
		as COFATORES,
		
		case 
			when (coalesce(C.COFATORES,'') <> '') then 
				CONCAT(
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.COFATORES, ';', 1), ',', 1) as SIGNED),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.COFATORES, ';', 2), ';', -1), ',', 1) as SIGNED),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.COFATORES, ';', -1), ',', 1) as SIGNED),
		        	';',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.COFATORES, ';', 1), ',', 2), ',', -1) as SIGNED),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.COFATORES, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.COFATORES, ';', -1), ',', 2), ',', -1) as SIGNED),
		        	';',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.COFATORES, ';', 1), ',', -1) as SIGNED),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.COFATORES, ';', 2), ';', -1), ',', -1) as SIGNED),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.COFATORES, ';', -1), ',', -1) as SIGNED)
		        )
			end
		as ADJUNTA,
		
		(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 1) as SIGNED)
             * (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED)
             * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', -1) as SIGNED)
             - cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', -1) as SIGNED)
             * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', 2), ',', -1) as SIGNED)
             )
           - cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 2), ',', -1) as SIGNED)
            * (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 1) as SIGNED)
             * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', -1) as SIGNED)
             - cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', -1) as SIGNED)
             * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', 1) as SIGNED)
             )
           + cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', -1) as SIGNED)
             * (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 1) as SIGNED)
             * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', 2), ',', -1) as SIGNED)
             - cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED)
             * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', 1) as SIGNED) 
             )
        ) as DETERMINANTE,
        
        case 
        	when (coalesce(C.DETERMINANTE,0) <> 0) THEN
		        (SELECT mult AS inverso_modular
				 FROM (
				      SELECT @row := @row + 1 AS mult
				      FROM 
				         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION 
				          SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t1,
				         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION 
				          SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t2,
				         (SELECT @row := -1) r
				      LIMIT 100
				) numbers
				WHERE (C.DETERMINANTE * mult) % 90 = 1
				LIMIT 1)
			else 
				0
			end 
		as INV_MODULAR,
		
		case 
			when (COALESCE(C.ADJUNTA,'') <> '') and (coalesce(C.INV_MODULAR,0) <> 0) then 
				 CONCAT(case 
							when (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ADJUNTA, ';', 1), ',', 1) as SIGNED) < 0) THEN 
								CHAR_LENGTH(C.ORIGINAL) + MOD((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ADJUNTA, ';', 1), ',', 1) as SIGNED) * C.INV_MODULAR), CHAR_LENGTH(C.ORIGINAL))	
							else
								MOD((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ADJUNTA, ';', 1), ',', 1) as SIGNED) * C.INV_MODULAR), CHAR_LENGTH(C.ORIGINAL))
						end,
						',',
						case 
							when (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ADJUNTA, ';', 1), ',', 2), ',', -1) as SIGNED) < 0) THEN 
								CHAR_LENGTH(C.ORIGINAL) + MOD((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ADJUNTA, ';', 1), ',', 2), ',', -1) as SIGNED) * C.INV_MODULAR), CHAR_LENGTH(C.ORIGINAL))	
							else
								MOD((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ADJUNTA, ';', 1), ',', 2), ',', -1) as SIGNED) * C.INV_MODULAR), CHAR_LENGTH(C.ORIGINAL))
						end,
						',',
						case 
							when (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ADJUNTA, ';', 1), ',', -1) as SIGNED) < 0) THEN 
								CHAR_LENGTH(C.ORIGINAL) + MOD((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ADJUNTA, ';', 1), ',', -1) as SIGNED) * C.INV_MODULAR), CHAR_LENGTH(C.ORIGINAL))	
							else
								MOD((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ADJUNTA, ';', 1), ',', -1) as SIGNED) * C.INV_MODULAR), CHAR_LENGTH(C.ORIGINAL))
						end,
						';',
						case 
							when (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ADJUNTA, ';', 2), ';', -1), ',', 1) as SIGNED) < 0) THEN 
								CHAR_LENGTH(C.ORIGINAL) + MOD((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ADJUNTA, ';', 2), ';', -1), ',', 1) as SIGNED) * C.INV_MODULAR), CHAR_LENGTH(C.ORIGINAL))	
							else
								MOD((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ADJUNTA, ';', 2), ';', -1), ',', 1) as SIGNED) * C.INV_MODULAR), CHAR_LENGTH(C.ORIGINAL))
						end,
						',',
						case 
							when (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ADJUNTA, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED) < 0) THEN 
								CHAR_LENGTH(C.ORIGINAL) + MOD((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ADJUNTA, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED) * C.INV_MODULAR), CHAR_LENGTH(C.ORIGINAL))	
							else
								MOD((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ADJUNTA, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED) * C.INV_MODULAR), CHAR_LENGTH(C.ORIGINAL))
						end,
						',',
						case 
							when (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ADJUNTA, ';', 2), ';', -1), ',', -1) as SIGNED) < 0) THEN 
								CHAR_LENGTH(C.ORIGINAL) + MOD((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ADJUNTA, ';', 2), ';', -1), ',', -1) as SIGNED) * C.INV_MODULAR), CHAR_LENGTH(C.ORIGINAL))	
							else
								MOD((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ADJUNTA, ';', 2), ';', -1), ',', -1) as SIGNED) * C.INV_MODULAR), CHAR_LENGTH(C.ORIGINAL))
						end,
						';',
						case 
							when (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ADJUNTA, ';', -1), ',', 1) as SIGNED) < 0) THEN 
								CHAR_LENGTH(C.ORIGINAL) + MOD((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ADJUNTA, ';', -1), ',', 1) as SIGNED) * C.INV_MODULAR), CHAR_LENGTH(C.ORIGINAL))	
							else
								MOD((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ADJUNTA, ';', -1), ',', 1) as SIGNED) * C.INV_MODULAR), CHAR_LENGTH(C.ORIGINAL))
						end,
						',',
						case 
							when (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ADJUNTA, ';', -1), ',', 2), ',', -1) as SIGNED) < 0) THEN 
								CHAR_LENGTH(C.ORIGINAL) + MOD((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ADJUNTA, ';', -1), ',', 2), ',', -1) as SIGNED) * C.INV_MODULAR), CHAR_LENGTH(C.ORIGINAL))	
							else
								MOD((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ADJUNTA, ';', -1), ',', 2), ',', -1) as SIGNED) * C.INV_MODULAR), CHAR_LENGTH(C.ORIGINAL))
						end,
						',',
						case 
							when (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ADJUNTA, ';', -1), ',', -1) as SIGNED) < 0) THEN 
								CHAR_LENGTH(C.ORIGINAL) + MOD((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ADJUNTA, ';', -1), ',', -1) as SIGNED) * C.INV_MODULAR), CHAR_LENGTH(C.ORIGINAL))	
							else
								MOD((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ADJUNTA, ';', -1), ',', -1) as SIGNED) * C.INV_MODULAR), CHAR_LENGTH(C.ORIGINAL))
						end
					)
			end 
		as INVERSA,
		
		case 
			when (coalesce(C.INVERSA,'') <> '') then 
				CONCAT(
					SUBSTRING(C.ORIGINAL
							, mod(
								mod(
									(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.INVERSA, ';', 1), ',', 1) as SIGNED) * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, ';', 1), ',', 1) as SIGNED))
								  + (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.INVERSA, ';', 1), ',', 2), ',', -1) as SIGNED) * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, ';', 1), ',', 2), ',', -1) as SIGNED))
								  + (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.INVERSA, ';', 1), ',', -1) as SIGNED) * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, ';', 1), ',', -1) as SIGNED))
							   	  ,CHAR_LENGTH(C.ORIGINAL)	
								) + CHAR_LENGTH(C.ORIGINAL)	
								,CHAR_LENGTH(C.ORIGINAL)
							  ) + 1
							 , 1),
					SUBSTRING(C.ORIGINAL
							, mod(
								mod(
									(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.INVERSA, ';', 2), ';', -1), ',', 1) as SIGNED) * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, ';', 1), ',', 1) as SIGNED))
								  + (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.INVERSA, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED) * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, ';', 1), ',', 2), ',', -1) as SIGNED))
								  + (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.INVERSA, ';', 2), ';', -1), ',', -1) as SIGNED) * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, ';', 1), ',', -1) as SIGNED))
							   	  ,CHAR_LENGTH(C.ORIGINAL)	
								) + CHAR_LENGTH(C.ORIGINAL)	
								,CHAR_LENGTH(C.ORIGINAL)
							  ) + 1
							 , 1),
					SUBSTRING(C.ORIGINAL
							, mod(
								mod(
									(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.INVERSA, ';', -1), ',', 1) as SIGNED) * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, ';', 1), ',', 1) as SIGNED))
								  + (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.INVERSA, ';', -1), ',', 2), ',', -1) as SIGNED) * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, ';', 1), ',', 2), ',', -1) as SIGNED))
								  + (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.INVERSA, ';', -1), ',', -1) as SIGNED) * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, ';', 1), ',', -1) as SIGNED))
							   	  ,CHAR_LENGTH(C.ORIGINAL)	
								) + CHAR_LENGTH(C.ORIGINAL)	
								,CHAR_LENGTH(C.ORIGINAL)
							  ) + 1
							 , 1)
					)
			END
		as DECIFRADO
			
	FROM USUARIO_B AA
    JOIN VW_Criptografia C ON AA.ID = C.ID
    where C.LINHA <= 8
)
SELECT *
FROM VW_CRIPTOGRAFIA