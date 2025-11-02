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
    WHERE n <= CHAR_LENGTH(CHANGED)
),
VW_GetGCD as (
	SELECT 
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
	              ((90 % (LINHA % 90)) % ((LINHA % 90) % (90 % (LINHA % 90))))))
	             then (((90 % (LINHA % 90)) % ((LINHA % 90) % (90 % (LINHA % 90)))) %
		              (((LINHA % 90) % (90 % (LINHA % 90))) % 
		              ((90 % (LINHA % 90)) % ((LINHA % 90) % (90 % (LINHA % 90))))))
	        ELSE 0
	    END as gcd_result
	FROM VW_Auxiliar
),
VW_GetCoprimo as (
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
        CAST('' as CHAR(85)) AS AUXILIAR,
        CAST('' AS CHAR(85)) AS ANTERIOR,
        0 AS CONTADOR,
        0 AS VIRGULA,
        CAST('' AS CHAR(85)) AS AUX_BLOCO,
        CAST('' AS CHAR(85)) AS BLOCO_ATUAL,
        1 AS CONT_BLOCOS,
        0 AS DETERMINANTE,
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
        	  and ((cast(((LENGTH(C.CRYPT) - (LENGTH(REPLACE(C.CRYPT, '¨', '')))) / 2) as unsigned) + LENGTH(REPLACE(C.CRYPT, '¨', ''))) <= (LENGTH(C.SENHA) + 1)) then 
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
					   (SELECT GROUP_CONCAT(SUBSTRING(sub.parte_crypt, numbers.n, 1) ORDER BY numbers.n desc SEPARATOR '') 
						FROM (
						    SELECT SUBSTRING(C.CRYPT, 1, FLOOR(LENGTH(C.SENHA) / 2) - 1) AS parte_crypt
						) AS sub
						CROSS JOIN JSON_TABLE(
						    CONCAT('[1', REPEAT(',1', LENGTH(sub.parte_crypt) - 1), ']'),
						    '$[*]' COLUMNS (n FOR ORDINALITY)
						) AS numbers),
						
						SUBSTRING(C.CRYPT, FLOOR(LENGTH(C.SENHA) / 2), 1),
						
						(SELECT GROUP_CONCAT(SUBSTRING(sub.parte_crypt, numbers.n, 1) ORDER BY numbers.n desc SEPARATOR '') 
						FROM (
						    SELECT SUBSTRING(C.CRYPT, FLOOR(LENGTH(C.SENHA) / 2) + 1, FLOOR(LENGTH(C.SENHA) / 2)) AS parte_crypt
						) AS sub
						CROSS JOIN JSON_TABLE(
						    CONCAT('[1', REPEAT(',1', LENGTH(sub.parte_crypt) - 1), ']'),
						    '$[*]' COLUMNS (n FOR ORDINALITY)
						) AS numbers)
		            )
		        ELSE
		            CONCAT(
					   (SELECT GROUP_CONCAT(SUBSTRING(sub.parte_crypt, numbers.n, 1) ORDER BY numbers.n desc SEPARATOR '') 
						FROM (
						    SELECT SUBSTRING(C.CRYPT, 1, FLOOR(LENGTH(C.SENHA) / 2)) AS parte_crypt
						) AS sub
						CROSS JOIN JSON_TABLE(
						    CONCAT('[1', REPEAT(',1', LENGTH(sub.parte_crypt) - 1), ']'),
						    '$[*]' COLUMNS (n FOR ORDINALITY)
						) AS numbers),
						
						(SELECT GROUP_CONCAT(SUBSTRING(sub.parte_crypt, numbers.n, 1) ORDER BY numbers.n desc SEPARATOR '') 
						FROM (
						    SELECT SUBSTRING(C.CRYPT, FLOOR(LENGTH(C.SENHA) / 2) + 1, FLOOR(LENGTH(C.SENHA) / 2)) AS parte_crypt
						) AS sub
						CROSS JOIN JSON_TABLE(
						    CONCAT('[1', REPEAT(',1', LENGTH(sub.parte_crypt) - 1), ']'),
						    '$[*]' COLUMNS (n FOR ORDINALITY)
						) AS numbers)
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
			        when ((cast(((LENGTH(C.CRYPT) - (LENGTH(REPLACE(C.CRYPT, '¨', '')))) / 2) as unsigned) + LENGTH(REPLACE(C.CRYPT, '¨', ''))) <= LENGTH(C.SENHA)) THEN 
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
	        when (right(C.BLOCO, 1) = ';') then 
	        	CASE 
			        WHEN (LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ';', ''))) > 1 then
			        	SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO, ';', -2), ';', 1)
			        ELSE 						    
			        	SUBSTRING(
			        		 C.CHANGED
				            ,CAST(MOD(
						        	(mod(
							        	(cast(SUBSTRING_INDEX(replace(C.BLOCO, ';', ''), ',', 1) as unsigned)
							        	* cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 1) as unsigned))
							          + (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(replace(C.BLOCO, ';', ''), ',', 2), ',', -1) as unsigned)
							          	* cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 2), ',', -1) as unsigned))
							          + (cast(SUBSTRING_INDEX(replace(C.BLOCO, ';', ''), ',', -1) as unsigned)
							          	* cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', -1) as unsigned))	
							          ,CHAR_LENGTH(C.CHANGED)
							        )
							        + CHAR_LENGTH(C.CHANGED))
							       ,CHAR_LENGTH(C.CHANGED)
							    ) 
							 AS unsigned)
							,1
						)
						
			        	/*CONCAT(
			        		CONVERT(
					        	 SUBSTRING(
					        		CONVERT(C.CHANGED USING utf8mb4) COLLATE utf8mb4_bin,
						        	CAST(
							        	MOD(
								        	(mod(
									        	(cast(SUBSTRING_INDEX(replace(C.BLOCO, ';', ''), ',', 1) as unsigned)
									        	* cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 1) as unsigned))
									          + (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(replace(C.BLOCO, ';', ''), ',', 2), ',', -1) as unsigned)
									          	* cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 2), ',', -1) as unsigned))
									          + (cast(SUBSTRING_INDEX(replace(C.BLOCO, ';', ''), ',', -1) as unsigned)
									          	* cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', -1) as unsigned))	
									          ,CHAR_LENGTH(C.CHANGED)
									        )
									        + CHAR_LENGTH(C.CHANGED))
									       ,CHAR_LENGTH(C.CHANGED)
									    ) 
									 as unsigned),
									 1
								)
							USING utf8mb4)
							,','
							,
							(cast(SUBSTRING_INDEX(replace(C.BLOCO, ';', ''), ',', 1) as unsigned)
							* cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 1) as unsigned))
							+ (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(replace(C.BLOCO, ';', ''), ',', 2), ',', -1) as unsigned)
				          	* cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 2), ',', -1) as unsigned))
				            + (cast(SUBSTRING_INDEX(replace(C.BLOCO, ';', ''), ',', -1) as unsigned)
				          	* cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', -1) as unsigned))
						)*/
			    END
        	when (CHAR_LENGTH(C.DIV_CRYPT) = CHAR_LENGTH(C.SENHA)) then
	         CASE 
		        when ((LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ',', '')))) + (LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ';', ''))) = CHAR_LENGTH(C.SENHA) then
		        	CONCAT(C.BLOCO, '89,89;')				
				WHEN (mod(CHAR_LENGTH(C.SENHA), 3) = 0) THEN
			       CASE
			            WHEN (C.BLOCO = '') or (RIGHT(C.BLOCO, 1) = ';') THEN
			               CONCAT(C.BLOCO, 
			               		CONCAT(INSTR(
										  CONVERT(C.CHANGED USING utf8mb4) COLLATE utf8mb4_bin, 
										  CONVERT(
										  		SUBSTRING(
										  				C.DIV_CRYPT, 
										  				(LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ',', ''))) + (LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ';', ''))) + 1, 
										  				1) 
										  		USING utf8mb4) 
										  COLLATE utf8mb4_bin
										) - 1, ','
									)
								)
			            WHEN mod((LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ',', ''))), 2) <> 0 THEN
			               CONCAT(C.BLOCO, 
			               		CONCAT(INSTR(
										  CONVERT(CHANGED USING utf8mb4) COLLATE utf8mb4_bin, 
										  CONVERT(
										  		SUBSTRING(
										  				C.DIV_CRYPT, 
										  				(LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ',', ''))) + (LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ';', ''))) + 1, 
										  				1) 
										  		USING utf8mb4) 
										  COLLATE utf8mb4_bin
										) - 1, ','
									)
								)
			            WHEN mod((LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ',', ''))), 2) = 0 THEN
			                CONCAT(C.BLOCO, 
			               		CONCAT(INSTR(
										  CONVERT(CHANGED USING utf8mb4) COLLATE utf8mb4_bin, 
										  CONVERT(
										  		SUBSTRING(
										  				C.DIV_CRYPT, 
										  				(LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ',', ''))) + (LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ';', ''))) + 1, 
										  				1) 
										  		USING utf8mb4) 
										  COLLATE utf8mb4_bin
										) - 1, ';'
									)
								)
			            ELSE
			               C.BLOCO
			    	end
					
			    when (mod(CHAR_LENGTH(C.SENHA), 2) = 0) and 
			    	(((((LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ',', '')))) + (LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ';', ''))))
              		- ((LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, '89', ''))) / LENGTH('89'))) < CHAR_LENGTH(C.SENHA)) then
			        CASE
			            WHEN (C.BLOCO = '') or (RIGHT(C.BLOCO, 1) = ';') THEN
			               CONCAT(C.BLOCO, 
			               			CONCAT(INSTR(
										  CONVERT(CHANGED USING utf8mb4) COLLATE utf8mb4_bin, 
										  CONVERT(
										  		SUBSTRING(
										  				C.DIV_CRYPT, 
										  				(LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ',', ''))) + (LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ';', ''))) + 1, 
										  				1) 
										  		USING utf8mb4) 
										  COLLATE utf8mb4_bin
										) - 1, ','
									)
								)
			            WHEN mod((LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ',', ''))), 2) <> 0 THEN
			               CONCAT(C.BLOCO, 
			               		CONCAT(INSTR(
										  CONVERT(CHANGED USING utf8mb4) COLLATE utf8mb4_bin, 
										  CONVERT(
										  		SUBSTRING(
										  				C.DIV_CRYPT, 
										  				(LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ',', ''))) + (LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ';', ''))) + 1, 
										  				1) 
										  		USING utf8mb4) 
										  COLLATE utf8mb4_bin
										) - 1, ','
									)
								)
			            WHEN (mod((LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ',', ''))), 2) = 0) then
			            	CONCAT(C.BLOCO,
					                CONCAT(INSTR(
												  CONVERT(CHANGED USING utf8mb4) COLLATE utf8mb4_bin, 
												  CONVERT(
												  		SUBSTRING(
												  				C.DIV_CRYPT, 
												  				(LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ',', ''))) + (LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ';', ''))) + 1, 
												  				1) 
												  		USING utf8mb4) 
												  COLLATE utf8mb4_bin
												) - 1, ';'
											)
									) 						
			            ELSE
			                C.BLOCO
			    	end
	
			   when (0 not in (mod(CHAR_LENGTH(C.SENHA),3), mod(CHAR_LENGTH(C.SENHA),2))) then
			      case 
					when (C.BLOCO = '') or (RIGHT(C.BLOCO, 1) = ';') then
					  CONCAT(C.BLOCO, 
		               		CONCAT(INSTR(
									  CONVERT(CHANGED USING utf8mb4) COLLATE utf8mb4_bin, 
									  CONVERT(
									  		SUBSTRING(
									  				C.DIV_CRYPT, 
									  				(LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ',', ''))) + (LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ';', ''))) + 1, 
									  				1) 
									  		USING utf8mb4) 
									  COLLATE utf8mb4_bin
									) - 1, ','
								)
							)
		            ELSE
		               C.BLOCO
				  end
			   else
			   	  C.BLOCO
			   end
		 else
			coalesce(C.BLOCO, '')
	 	 end as BLOCO,

	 	 case
        	when (coalesce(C.AUX_BLOCO, '') <> '') then
        		case
        			when (C.COPRIMO < (select MAX(AA.LINHA) from VW_GetCoprimo AA)) then
        				(select MIN(BB.LINHA) from VW_GetCoprimo BB where BB.LINHA > C.COPRIMO)
        			when (C.COPRIMO = CHAR_LENGTH(C.CHANGED) - 1) then 
        				1
        			else
        				C.COPRIMO
        		end
        	else
        		C.COPRIMO
        	end
        as COPRIMO,
        
        C.MATRIZ,
        C.RESERVA,
        
        CONCAT(
        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', 1) as unsigned) * C.COPRIMO),
        	',',
        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', 2), ',', -1) as unsigned) * C.COPRIMO),
        	',',
        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', -1) as unsigned) * C.COPRIMO),
        	';',
        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', 1) as unsigned) * C.COPRIMO),
        	',',
        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', 2), ',', -1) as unsigned) * C.COPRIMO),
        	',',
        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', -1) as unsigned) * C.COPRIMO),
        	';',
        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', 1) as unsigned) * C.COPRIMO),
        	',',
        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', 2), ',', -1) as unsigned) * C.COPRIMO),
        	',',
        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', -1) as unsigned) * C.COPRIMO)
        ) AS AUXILIAR,
        
        case
        	when (coalesce(C.AUX_BLOCO, '') <> '') then
        		C.AUXILIAR 
        	else
        		C.ANTERIOR
        	end
        as ANTERIOR,
        
        0 AS CONTADOR,
        0 AS VIRGULA,
        
        case
	        when (coalesce(C.AUX_BLOCO, '') <> '') then
	        	SUBSTRING(C.AUX_BLOCO, LOCATE(';', C.AUX_BLOCO) + 1)
        	when (((LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ',', '')))) + (LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ';', ''))))
              = (CHAR_LENGTH(C.SENHA)
                + ((LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, '89', ''))) / LENGTH('89'))) then 
            	C.BLOCO
            else
            	C.AUX_BLOCO
            END	
        as AUX_BLOCO,
        
        case
        	when (coalesce(C.AUX_BLOCO, '') <> '') then
        		C.AUX_BLOCO
        	else
        		C.BLOCO_ATUAL
        	end
        as BLOCO_ATUAL,
        
        0 AS CONT_BLOCOS,
        
        
       /* case
        	when (coalesce(C.AUXILIAR,'') <> '') THEN
	          cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 1) as unsigned) 
	          * (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 2), ',', -1) as unsigned)
	          	* cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', -1) as unsigned)
	          	- cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', -1) as unsigned)
	          	* cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', 2), ',', -1) as unsigned))
	          	
	         - cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 2), ',', -1) as unsigned)
	           * (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 1) as unsigned)
	             * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', -1) as unsigned)
	             - cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', -1) as unsigned)
	             * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', 1) as unsigned))
	        else
	           0
	        end 
	    as*/ 0 DETERMINANTE,        
	    
           
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
    WHERE C.POSICAO <= (LENGTH(AA.SENHA) * 4) - 6
)
SELECT *
FROM VW_Criptografia