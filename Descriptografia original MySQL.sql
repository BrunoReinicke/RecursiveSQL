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
        cast('18,11,12;13,14,15;2,16,17' as CHAR(500)) AS MATRIZ,
        cast('18,11,12;13,14,15;2,16,17' as CHAR(500)) AS AUXILIAR,
        CAST('' AS CHAR(500)) AS ANTERIOR,
        0 AS CONTADOR,
        0 as CONTADOR_AUX,
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
        CAST('' as CHAR(500)) as DECIFRADO,
        'F' as BLOCO_PREENCHIDO,
        'F' as CONTADOR_2
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
       
        COALESCE( 
		 	 (case
			 	 when (C.BLOCO_PREENCHIDO = 'T') and (C.CONT_BLOCOS <> (CHAR_LENGTH(C.BLOCO_ATUAL) - CHAR_LENGTH(REPLACE(C.BLOCO_ATUAL, 'Ж', '')))) then
	        		case
	        			when (C.COPRIMO < (select MAX(AA.LINHA) from VW_GetCoprimo AA)) then
	        				(select MIN(BB.LINHA) from VW_GetCoprimo BB where BB.LINHA > 
	        				(case 
					    	  	when ((CASE 
									    WHEN ((SELECT 
									            CASE 
									                WHEN 90 = 0 THEN ABS(DE.det)
									                WHEN DE.det = 0 THEN 90
									                ELSE 
									                    CASE 
														    WHEN DE.det = 0 THEN 90
														    WHEN 90 % DE.det = 0 THEN ABS(DE.det)
														    WHEN DE.det IN (1, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 49, 
														                   53, 59, 61, 67, 71, 73, 77, 79, 83, 89) THEN 1
														    
														    WHEN DE.det % 2 = 0 AND 90 % 2 = 0 THEN 2
														    WHEN DE.det % 3 = 0 AND 90 % 3 = 0 THEN 3
														    WHEN DE.det % 5 = 0 AND 90 % 5 = 0 THEN 5
														    
														    WHEN DE.det % (90 % DE.det) = 0 THEN (90 % DE.det)
														    WHEN (90 % DE.det) % (DE.det % (90 % DE.det)) = 0 THEN (DE.det % (90 % DE.det))
														    WHEN (DE.det % (90 % DE.det)) % ((90 % DE.det) % (DE.det % (90 % DE.det))) = 0 
														         THEN ((90 % DE.det) % (DE.det % (90 % DE.det)))
														    when ((90 % DE.det) % (DE.det % (90 % DE.det))) % ((DE.det % (90 % DE.det)) % ((90 % DE.det) % (DE.det % (90 % DE.det)))) = 0 
														    	 then ((DE.det % (90 % DE.det)) % ((90 % DE.det) % (DE.det % (90 % DE.det))))
	 													    
														    ELSE 0
														END
									            END
									          FROM (SELECT ABS(
									              (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 1) as SIGNED)
									               * (CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED)
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
									            ) % 90) as det
									         ) DE) = 1)
									    THEN 1
									    ELSE 0
									END) 
									 = 0) then
									 case
					        			when (C.COPRIMO < (select MAX(AA.LINHA) from VW_GetCoprimo AA)) then
					        			    (select MIN(BB.LINHA) from VW_GetCoprimo BB where BB.LINHA > C.COPRIMO)
					        			when (C.COPRIMO = CHAR_LENGTH(C.ORIGINAL) - 1) then 
					        				1
					        			else
					        				C.COPRIMO
					        		 end
								else 
									C.COPRIMO
								end))
	        			when (C.COPRIMO = CHAR_LENGTH(C.ORIGINAL) - 1) then 
	        				1
	        			else
	        				C.COPRIMO
	        		end
	        	else
	        		C.COPRIMO
	        	end)
	        , 1) as COPRIMO,
         
        COALESCE(C.COPRIMO, 0) as COPRIMO_AUX,
        
        C.MATRIZ,
        
        case 
	       when (((C.COPRIMO = (select MAX(AA.LINHA) from VW_GetCoprimo AA)) and (C.COPRIMO <> C.COPRIMO_AUX)) and (C.CONTADOR = 1)) then 
	       	  CONCAT(
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', 1) as SIGNED),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', -1) as SIGNED),
		        	';',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 1) as SIGNED),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 2), ',', -1) as SIGNED),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', -1) as SIGNED),
		        	';',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 1) as SIGNED),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 2), ',', -1) as SIGNED),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', -1) as SIGNED)
		        )
	       when (C.CONTADOR = 2) then 
	         /*case 
	         	when (coalesce(C.INVERSA,'') <> '') and (coalesce(C.COFATORES,'') <> '') and (coalesce(C.ADJUNTA,'') <> '') then  
	         		case 
	         			when ((CASE 
						    WHEN ((SELECT 
						            CASE 
						                WHEN 90 = 0 THEN ABS(DE.det)
						                WHEN DE.det = 0 THEN 90
						                ELSE 
						                    CASE 
											    WHEN DE.det = 0 THEN 90
											    WHEN 90 % DE.det = 0 THEN ABS(DE.det)
											    WHEN DE.det IN (1, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 49, 
											                   53, 59, 61, 67, 71, 73, 77, 79, 83, 89) THEN 1
											    
											    WHEN DE.det % 2 = 0 AND 90 % 2 = 0 THEN 2
											    WHEN DE.det % 3 = 0 AND 90 % 3 = 0 THEN 3
											    WHEN DE.det % 5 = 0 AND 90 % 5 = 0 THEN 5
											    
											    WHEN DE.det % (90 % DE.det) = 0 THEN (90 % DE.det)
											    WHEN (90 % DE.det) % (DE.det % (90 % DE.det)) = 0 THEN (DE.det % (90 % DE.det))
											    WHEN (DE.det % (90 % DE.det)) % ((90 % DE.det) % (DE.det % (90 % DE.det))) = 0 
											         THEN ((90 % DE.det) % (DE.det % (90 % DE.det)))
											    when ((90 % DE.det) % (DE.det % (90 % DE.det))) % ((DE.det % (90 % DE.det)) % ((90 % DE.det) % (DE.det % (90 % DE.det)))) = 0 
												     then ((DE.det % (90 % DE.det)) % ((90 % DE.det) % (DE.det % (90 % DE.det))))
											    
												ELSE 0
											END
						            END
						          FROM (SELECT ABS(
						              (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', 1) as SIGNED)
						               * (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 2), ',', -1) as SIGNED)
						                 * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', -1) as SIGNED)
						                 - cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', -1) as SIGNED)
						                 * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 2), ',', -1) as SIGNED)
						                 )
						               - cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED) 
						                * (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 1) as SIGNED)
						                 * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', -1) as SIGNED)
						                 - cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', -1) as SIGNED)
						                 * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 1) as SIGNED)
						                 )
						               + cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', -1) as SIGNED)
						               * (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 1) as SIGNED)
						                 * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 2), ',', -1) as SIGNED)
						                 - cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 2), ',', -1) as SIGNED)
						                 * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 1) as SIGNED) 
						                 )
						            ) % 90) as det
						         ) DE) = 1)
						    THEN 1
						    ELSE 0
						END) 
						 = 0) then 
						CONCAT(
				        	((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', 1) as SIGNED) * C.COPRIMO) + 1),
				        	',',
				        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', 2), ',', -1) as SIGNED) * C.COPRIMO),
				        	',',
				        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', -1) as SIGNED) * C.COPRIMO),
				        	';',
				        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', 1) as SIGNED) * C.COPRIMO),
				        	',',
				        	((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED) * C.COPRIMO) + 1),
				        	',',
				        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', -1) as SIGNED) * C.COPRIMO),
				        	';',
				        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', 1) as SIGNED) * C.COPRIMO),
				        	',',
				        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', 2), ',', -1) as SIGNED) * C.COPRIMO),
				        	',',
				        	((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', -1) as SIGNED) * C.COPRIMO) + 1)
				        )
					else
						CONCAT(
				        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', 1) as SIGNED),
				        	',',
				        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED),
				        	',',
				        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', -1) as SIGNED),
				        	';',
				        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 1) as SIGNED),
				        	',',
				        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 2), ',', -1) as SIGNED),
				        	',',
				        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', -1) as SIGNED),
				        	';',
				        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 1) as SIGNED),
				        	',',
				        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 2), ',', -1) as SIGNED),
				        	',',
				        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', -1) as SIGNED)
				        )	
	         		end
		        else
		        	C.AUXILIAR
	         end*/
	       		/*CONCAT(
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', 1) as SIGNED),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', -1) as SIGNED),
		        	';',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 1) as SIGNED),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 2), ',', -1) as SIGNED),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', -1) as SIGNED),
		        	';',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 1) as SIGNED),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 2), ',', -1) as SIGNED),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', -1) as SIGNED)
		        )*/
	       		case
	       			when (C.CONT_BLOCOS <> (CHAR_LENGTH(C.BLOCO_ATUAL) - CHAR_LENGTH(REPLACE(C.BLOCO_ATUAL, 'Ж', '')))) THEN
			      		CONCAT(
				        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', 1) as SIGNED),
				        	',',
				        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED),
				        	',',
				        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', -1) as SIGNED),
				        	';',
				        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 1) as SIGNED),
				        	',',
				        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 2), ',', -1) as SIGNED),
				        	',',
				        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', -1) as SIGNED),
				        	';',
				        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 1) as SIGNED),
				        	',',
				        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 2), ',', -1) as SIGNED),
				        	',',
				        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', -1) as SIGNED)
				        )
				    else
				    	C.ANTERIOR
				END
	       /*when ((C.COPRIMO = (select MAX(AA.LINHA) from VW_GetCoprimo AA)) and (C.COPRIMO <> C.COPRIMO_AUX)) and (C.CONTADOR < 2) then 
	        	case	
		        	when ((CASE 
					    WHEN ((SELECT 
					            CASE 
					                WHEN 90 = 0 THEN ABS(DE.det)
					                WHEN DE.det = 0 THEN 90
					                ELSE 
					                    CASE 
										    WHEN DE.det = 0 THEN 90
										    WHEN 90 % DE.det = 0 THEN ABS(DE.det)
										    WHEN DE.det IN (1, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 49, 
										                   53, 59, 61, 67, 71, 73, 77, 79, 83, 89) THEN 1
										    
										    WHEN DE.det % 2 = 0 AND 90 % 2 = 0 THEN 2
										    WHEN DE.det % 3 = 0 AND 90 % 3 = 0 THEN 3
										    WHEN DE.det % 5 = 0 AND 90 % 5 = 0 THEN 5
										    
										    WHEN DE.det % (90 % DE.det) = 0 THEN (90 % DE.det)
										    WHEN (90 % DE.det) % (DE.det % (90 % DE.det)) = 0 THEN (DE.det % (90 % DE.det))
										    WHEN (DE.det % (90 % DE.det)) % ((90 % DE.det) % (DE.det % (90 % DE.det))) = 0 
										         THEN ((90 % DE.det) % (DE.det % (90 % DE.det)))
										    when ((90 % DE.det) % (DE.det % (90 % DE.det))) % ((DE.det % (90 % DE.det)) % ((90 % DE.det) % (DE.det % (90 % DE.det)))) = 0 
											     then ((DE.det % (90 % DE.det)) % ((90 % DE.det) % (DE.det % (90 % DE.det))))
										    
											ELSE 0
										END
					            END
					          FROM (SELECT ABS(
					              (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', 1) as SIGNED)
					               * (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 2), ',', -1) as SIGNED)
					                 * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', -1) as SIGNED)
					                 - cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', -1) as SIGNED)
					                 * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 2), ',', -1) as SIGNED)
					                 )
					               - cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED) 
					                * (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 1) as SIGNED)
					                 * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', -1) as SIGNED)
					                 - cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', -1) as SIGNED)
					                 * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 1) as SIGNED)
					                 )
					               + cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', -1) as SIGNED)
					               * (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 1) as SIGNED)
					                 * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 2), ',', -1) as SIGNED)
					                 - cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 2), ',', -1) as SIGNED)
					                 * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 1) as SIGNED) 
					                 )
					            ) % 90) as det
					         ) DE) = 1)
					    THEN 1
					    ELSE 0
					END) 
					 = 0) then 
					case 
	         			when ((CASE 
							    WHEN ((SELECT 
							            CASE 
							                WHEN 90 = 0 THEN ABS(DE.det)
							                WHEN DE.det = 0 THEN 90
							                ELSE 
							                    CASE 
												    WHEN DE.det = 0 THEN 90
												    WHEN 90 % DE.det = 0 THEN ABS(DE.det)
												    WHEN DE.det IN (1, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 49, 
												                   53, 59, 61, 67, 71, 73, 77, 79, 83, 89) THEN 1
												    
												    WHEN DE.det % 2 = 0 AND 90 % 2 = 0 THEN 2
												    WHEN DE.det % 3 = 0 AND 90 % 3 = 0 THEN 3
												    WHEN DE.det % 5 = 0 AND 90 % 5 = 0 THEN 5
												    
												    WHEN DE.det % (90 % DE.det) = 0 THEN (90 % DE.det)
												    WHEN (90 % DE.det) % (DE.det % (90 % DE.det)) = 0 THEN (DE.det % (90 % DE.det))
												    WHEN (DE.det % (90 % DE.det)) % ((90 % DE.det) % (DE.det % (90 % DE.det))) = 0 
												         THEN ((90 % DE.det) % (DE.det % (90 % DE.det)))
												    when ((90 % DE.det) % (DE.det % (90 % DE.det))) % ((DE.det % (90 % DE.det)) % ((90 % DE.det) % (DE.det % (90 % DE.det)))) = 0 
													     then ((DE.det % (90 % DE.det)) % ((90 % DE.det) % (DE.det % (90 % DE.det))))
												    
													ELSE 0
												END
							            END
							          FROM (SELECT ABS(
							              ((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', 1) as SIGNED) * C.COPRIMO) + 1)
							               * (((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED) * C.COPRIMO) + 1)
							                 * ((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', -1) as SIGNED) * C.COPRIMO) + 1)
							                 - (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', -1) as SIGNED) * C.COPRIMO)
							                 * (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', 2), ',', -1) as SIGNED) * C.COPRIMO)
							                 )
							               - (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', 2), ',', -1) as SIGNED) * C.COPRIMO) 
							                * ((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', 1) as SIGNED) * C.COPRIMO)
							                 * ((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', -1) as SIGNED) * C.COPRIMO) + 1)
							                 - (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', -1) as SIGNED) * C.COPRIMO)
							                 * (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', 1) as SIGNED) * C.COPRIMO)
							                 )
							               + (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', -1) as SIGNED) * C.COPRIMO)
							               * ((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', 1) as SIGNED) * C.COPRIMO)
							                 * (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', 2), ',', -1) as SIGNED) * C.COPRIMO)
							                 - ((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED) * C.COPRIMO) + 1)
							                 * (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', 1) as SIGNED) * C.COPRIMO) 
							                 )
							            ) % 90) as det
							         ) DE) = 1)
							    THEN 1
							    ELSE 0
							END) 
							 = 0) then 
							 	'19,12,13;14,15,16;3,17,18'
					else
						CONCAT(
				        	((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', 1) as SIGNED) * C.COPRIMO) + 1),
				        	',',
				        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', 2), ',', -1) as SIGNED) * C.COPRIMO),
				        	',',
				        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', -1) as SIGNED) * C.COPRIMO),
				        	';',
				        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', 1) as SIGNED) * C.COPRIMO),
				        	',',
				        	((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED) * C.COPRIMO) + 1),
				        	',',
				        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', -1) as SIGNED) * C.COPRIMO),
				        	';',
				        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', 1) as SIGNED) * C.COPRIMO),
				        	',',
				        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', 2), ',', -1) as SIGNED) * C.COPRIMO),
				        	',',
				        	((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', -1) as SIGNED) * C.COPRIMO) + 1)
				        )	
	         		end
				else
					CONCAT(
			        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', 1) as SIGNED),
			        	',',
			        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED),
			        	',',
			        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', -1) as SIGNED),
			        	';',
			        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 1) as SIGNED),
			        	',',
			        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 2), ',', -1) as SIGNED),
			        	',',
			        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', -1) as SIGNED),
			        	';',
			        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 1) as SIGNED),
			        	',',
			        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 2), ',', -1) as SIGNED),
			        	',',
			        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', -1) as SIGNED)
			        )	
         		end*/
        	when (C.BLOCO_PREENCHIDO = 'T') and (C.CONT_BLOCOS <> (CHAR_LENGTH(C.BLOCO_ATUAL) - CHAR_LENGTH(REPLACE(C.BLOCO_ATUAL, 'Ж', '')))) THEN
	          case 
	        	when (C.COPRIMO >= (select MAX(AA.LINHA) from VW_GetCoprimo AA))	
		          and ((CASE 
					    WHEN ((SELECT 
					            CASE 
					                WHEN 90 = 0 THEN ABS(DE.det)
					                WHEN DE.det = 0 THEN 90
					                ELSE 
					                    CASE 
										    WHEN DE.det = 0 THEN 90
										    WHEN 90 % DE.det = 0 THEN ABS(DE.det)
										    WHEN DE.det IN (1, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 49, 
										                   53, 59, 61, 67, 71, 73, 77, 79, 83, 89) THEN 1
										    
										    WHEN DE.det % 2 = 0 AND 90 % 2 = 0 THEN 2
										    WHEN DE.det % 3 = 0 AND 90 % 3 = 0 THEN 3
										    WHEN DE.det % 5 = 0 AND 90 % 5 = 0 THEN 5
										    
										    WHEN DE.det % (90 % DE.det) = 0 THEN (90 % DE.det)
										    WHEN (90 % DE.det) % (DE.det % (90 % DE.det)) = 0 THEN (DE.det % (90 % DE.det))
										    WHEN (DE.det % (90 % DE.det)) % ((90 % DE.det) % (DE.det % (90 % DE.det))) = 0 
										         THEN ((90 % DE.det) % (DE.det % (90 % DE.det)))
										    when ((90 % DE.det) % (DE.det % (90 % DE.det))) % ((DE.det % (90 % DE.det)) % ((90 % DE.det) % (DE.det % (90 % DE.det)))) = 0 
												 then ((DE.det % (90 % DE.det)) % ((90 % DE.det) % (DE.det % (90 % DE.det))))     
										    
										    ELSE 0
										END
					            END
					          FROM (SELECT ABS(
					              (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 1) as SIGNED)
					               * (CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED)
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
					            ) % 90) as det
					         ) DE) = 1)
					    THEN 1
					    ELSE 0
					END) 
					 = 0) then
			        C.MATRIZ
			     else
			     	C.ANTERIOR
			   END
        	else
		        CONCAT(
			        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', 1) as SIGNED) * C.COPRIMO),
			        	',',
			        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', 2), ',', -1) as SIGNED) * C.COPRIMO),
			        	',',
			        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 1), ',', -1) as SIGNED) * C.COPRIMO),
			        	';',
			        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', 1) as SIGNED) * C.COPRIMO),
			        	',',
			        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED) * C.COPRIMO),
			        	',',
			        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', 2), ';', -1), ',', -1) as SIGNED) * C.COPRIMO),
			        	';',
			        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', 1) as SIGNED) * C.COPRIMO),
			        	',',
			        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', 2), ',', -1) as SIGNED) * C.COPRIMO),
			        	',',
			        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.MATRIZ, ';', -1), ',', -1) as SIGNED) * C.COPRIMO)
			        )
			END
	    as AUXILIAR,
        
        case
	       /* when (C.CONTADOR = 2) then 
	        	CONCAT(
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', 1) as SIGNED),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', -1) as SIGNED),
		        	';',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 1) as SIGNED),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 2), ',', -1) as SIGNED),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', -1) as SIGNED),
		        	';',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 1) as SIGNED),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 2), ',', -1) as SIGNED),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', -1) as SIGNED)
		        )*/
        	when (coalesce(C.AUXILIAR,'') <> '') then
        		C.AUXILIAR	
        	end
        as ANTERIOR,
        
        case 
        	when /*((CASE 
					    WHEN ((SELECT 
					            CASE 
					                WHEN 90 = 0 THEN ABS(DE.det)
					                WHEN DE.det = 0 THEN 90
					                ELSE 
					                    CASE 
										    WHEN DE.det = 0 THEN 90
										    WHEN 90 % DE.det = 0 THEN ABS(DE.det)
										    WHEN DE.det IN (1, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 49, 
										                   53, 59, 61, 67, 71, 73, 77, 79, 83, 89) THEN 1
										    
										    WHEN DE.det % 2 = 0 AND 90 % 2 = 0 THEN 2
										    WHEN DE.det % 3 = 0 AND 90 % 3 = 0 THEN 3
										    WHEN DE.det % 5 = 0 AND 90 % 5 = 0 THEN 5
										    
										    WHEN DE.det % (90 % DE.det) = 0 THEN (90 % DE.det)
										    WHEN (90 % DE.det) % (DE.det % (90 % DE.det)) = 0 THEN (DE.det % (90 % DE.det))
										    WHEN (DE.det % (90 % DE.det)) % ((90 % DE.det) % (DE.det % (90 % DE.det))) = 0 
										         THEN ((90 % DE.det) % (DE.det % (90 % DE.det)))
										    when ((90 % DE.det) % (DE.det % (90 % DE.det))) % ((DE.det % (90 % DE.det)) % ((90 % DE.det) % (DE.det % (90 % DE.det)))) = 0 
											     then ((DE.det % (90 % DE.det)) % ((90 % DE.det) % (DE.det % (90 % DE.det))))
										    
											ELSE 0
										END
					            END
					          FROM (SELECT ABS(
					              (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 1) as SIGNED)
					               * (CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED)
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
					            ) % 90) as det
					         ) DE) = 1)
					    THEN 1
					    ELSE 0
					END) 
					 = 0)
			   and*/ (C.CONTADOR < 2) 
			   and (C.COPRIMO = (select MAX(AA.LINHA) from VW_GetCoprimo AA))
			   and (C.COPRIMO <> C.COPRIMO_AUX) then
				C.CONTADOR + 1
			ELSE
        		C.CONTADOR
        	end
        as CONTADOR,        
        
        C.CONTADOR_AUX,
        
        case 
	        when ((CHAR_LENGTH(C.BLOCO_ATUAL) - CHAR_LENGTH(REPLACE(C.BLOCO_ATUAL, ',', '')))
	        	+ (CHAR_LENGTH(C.BLOCO_ATUAL) - CHAR_LENGTH(REPLACE(C.BLOCO_ATUAL, 'Ж', ''))))
	        	< CHAR_LENGTH(C.SENHA) THEN
	        	CASE
		        	when (coalesce(C.AUX_BLOCO,'') = '') and (coalesce(C.BLOCO_ATUAL) = '') then
		        		C.SENHA
		        	else
		        		SUBSTRING(C.AUX_BLOCO, 2, CHAR_LENGTH(C.AUX_BLOCO))
	        	end
	        else
	        	''
        	END
        as AUX_BLOCO,
        
        case
	        when (coalesce(C.INVERSA,'') <> '') and (coalesce(C.COFATORES,'') <> '') and (coalesce(C.ADJUNTA,'') <> '') then 
	        	SUBSTRING_INDEX(C.BLOCO_ATUAL, 'Ж', - (CHAR_LENGTH(C.BLOCO_ATUAL) - CHAR_LENGTH(REPLACE(C.BLOCO_ATUAL, 'Ж', ''))))
	        when (((CHAR_LENGTH(C.BLOCO_ATUAL) - CHAR_LENGTH(REPLACE(C.BLOCO_ATUAL, ',', '')))
	        	 + (CHAR_LENGTH(C.BLOCO_ATUAL) - CHAR_LENGTH(REPLACE(C.BLOCO_ATUAL, 'Ж', ''))))
	        	 = CHAR_LENGTH(C.SENHA) - 1) 
	        	 or (C.COPRIMO <> C.COPRIMO_AUX) then
	        	C.BLOCO_ATUAL
        	when (coalesce(C.AUX_BLOCO,'') <> '') and (coalesce(C.INVERSA,'') = '') then
        		case 
	        		when ((CHAR_LENGTH(C.BLOCO_ATUAL) - CHAR_LENGTH(REPLACE(C.BLOCO_ATUAL, ',', ''))) = 0) 
	        		  or not (mod((CHAR_LENGTH(C.BLOCO_ATUAL) - CHAR_LENGTH(REPLACE(C.BLOCO_ATUAL, ',', ''))), 2) = 0) THEN 		
	        			CONCAT(C.BLOCO_ATUAL,
		        			   INSTR(
								  CONVERT(ORIGINAL USING utf8mb4) COLLATE utf8mb4_bin, 
								  CONVERT(SUBSTRING(C.AUX_BLOCO, 1, 1) USING utf8mb4) 
								  COLLATE utf8mb4_bin
								) - 1,
								','
							)
					when (MOD(
							 (CHAR_LENGTH(C.BLOCO_ATUAL) - CHAR_LENGTH(REPLACE(C.BLOCO_ATUAL, ',', ''))) 
							 + (CHAR_LENGTH(C.BLOCO_ATUAL) - CHAR_LENGTH(REPLACE(C.BLOCO_ATUAL, 'Ж', '')))
						    ,3
						  ) = 0) THEN 	
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
								'Ж'
							)
					END
        	else
        		C.BLOCO_ATUAL
        	end
        as BLOCO_ATUAL,
        
        case 
	        when (C.COPRIMO <> C.COPRIMO_AUX) then 
	        	C.BLOCO_ANT
        	when (((CHAR_LENGTH(C.BLOCO_ATUAL) - CHAR_LENGTH(REPLACE(C.BLOCO_ATUAL, ',', '')))
	        	+ (CHAR_LENGTH(C.BLOCO_ATUAL) - CHAR_LENGTH(REPLACE(C.BLOCO_ATUAL, 'Ж', ''))))
	        	= CHAR_LENGTH(C.SENHA) - 1) THEN
		       C.BLOCO_ATUAL
		    END
        as BLOCO_ANT,
        
		case
			when (C.BLOCO_PREENCHIDO = 'T') then
				(CHAR_LENGTH(C.BLOCO_ATUAL) - CHAR_LENGTH(REPLACE(C.BLOCO_ATUAL, 'Ж', '')))
			end
		as CONT_BLOCOS,
		
		C.CONT_BLOCOS_AUX, 
		C.LINHA + 1 LINHA,
		
		case 
			when (coalesce(C.INVERSA,'') <> '') and (coalesce(C.COFATORES,'') <> '') and (coalesce(C.ADJUNTA,'') <> '') then 
				''
			when ((((CHAR_LENGTH(C.BLOCO_ATUAL) - CHAR_LENGTH(REPLACE(C.BLOCO_ATUAL, ',', '')))
	          + (CHAR_LENGTH(C.BLOCO_ATUAL) - CHAR_LENGTH(REPLACE(C.BLOCO_ATUAL, 'Ж', '')))) 
	          = CHAR_LENGTH(C.SENHA) - 1)
	          or (C.BLOCO_ATUAL <> C.BLOCO_ANT)
	          or (C.BLOCO_PREENCHIDO = 'T'))
	          and (C.COPRIMO = C.COPRIMO_AUX) then
	           CONCAT(
		        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED)
		        	* cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', -1) as SIGNED)
		        	- CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', -1) as SIGNED)
		        	* CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', 2), ',', -1) as SIGNED)),  -- cofatores[0][0]
		        	',',
		        	((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 1) as SIGNED)
		        	  * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', -1) as SIGNED)
		        	  - CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', -1) as SIGNED)
		        	  * CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', 1) as SIGNED)) 
	        	      * -1),   -- cofatores[0][1]
	        	    ',',
	        	    (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 1) as SIGNED)
		        	  * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', 2), ',', -1) as SIGNED)
		        	  - CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED)
		        	  * CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', 1) as SIGNED)),  -- cofatores[0][2]
		            ';',
		            ((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 2), ',', -1) as SIGNED)
		        	  * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', -1) as SIGNED)
		        	  - CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', -1) as SIGNED)
		        	  * CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', 2), ',', -1) as SIGNED))
		        	  * -1), -- cofatores[1][0] 
		        	',',
		        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 1) as SIGNED)
		        	  * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', -1) as SIGNED)
		        	  - cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', -1) as SIGNED)
		        	  * CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', 1) as SIGNED)),  -- cofatores[1][1]
		        	',', 
		        	((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 1) as SIGNED)
		        	  * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', 2), ',', -1) as SIGNED)
		        	  - cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 2), ',', -1) as SIGNED)
		        	  * CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', 1) as SIGNED))
		        	  * -1),  -- cofatores[1][2]
		        	';',
		        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 2), ',', -1) as SIGNED)
		        	  * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', -1) as SIGNED)
		        	  - CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', -1) as SIGNED)
		        	  * CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED)),  -- cofatores[2][0] 
		        	',',
		        	((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 1) as SIGNED)
		        	  * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', -1) as SIGNED)
		        	  - CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', -1) as SIGNED)
		        	  * CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 1) as SIGNED))
		        	  * -1),  -- cofatores[2][1] 
		        	',',  
		        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 1) as SIGNED)
		        	  * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED)
		        	  - CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 2), ',', -1) as SIGNED)
		        	  * CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 1) as SIGNED))  -- cofatores[2][2] 
		        )
	        else
	        	''
			end
		as COFATORES,
		
		case 
			when (coalesce(C.INVERSA,'') <> '') and (coalesce(C.COFATORES,'') <> '') and (coalesce(C.ADJUNTA,'') <> '') then 
				''
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
			when (coalesce(C.INVERSA,'') <> '') and (coalesce(C.COFATORES,'') <> '') and (coalesce(C.ADJUNTA,'') <> '') then  
				''
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
			when (((C.COPRIMO = (select MAX(AA.LINHA) from VW_GetCoprimo AA)) and (C.COPRIMO <> C.COPRIMO_AUX)) and (C.CONTADOR = 1)) then
				C.DECIFRADO
			when (coalesce(C.BLOCO_ATUAL,'') = '') then 
				replace(C.DECIFRADO, 'Б', '')
			when (coalesce(C.INVERSA,'') <> '') and (coalesce(C.COFATORES,'') <> '') and (coalesce(C.ADJUNTA,'') <> '') then  
				CONCAT(
					coalesce(C.DECIFRADO,''),
					CONCAT(
						SUBSTRING(C.ORIGINAL
								, mod(
									mod(
										(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.INVERSA, ';', 1), ',', 1) as SIGNED) * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, 'Ж', 1), ',', 1) as SIGNED))
									  + (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.INVERSA, ';', 1), ',', 2), ',', -1) as SIGNED) * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, 'Ж', 1), ',', 2), ',', -1) as SIGNED))
									  + (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.INVERSA, ';', 1), ',', -1) as SIGNED) * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, 'Ж', 1), ',', -1) as SIGNED))
								   	  ,CHAR_LENGTH(C.ORIGINAL)	
									) + CHAR_LENGTH(C.ORIGINAL)	
									,CHAR_LENGTH(C.ORIGINAL)
								  ) + 1
								 , 1),
						SUBSTRING(C.ORIGINAL
								, mod(
									mod(
										(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.INVERSA, ';', 2), ';', -1), ',', 1) as SIGNED) * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, 'Ж', 1), ',', 1) as SIGNED))
									  + (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.INVERSA, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED) * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, 'Ж', 1), ',', 2), ',', -1) as SIGNED))
									  + (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.INVERSA, ';', 2), ';', -1), ',', -1) as SIGNED) * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, 'Ж', 1), ',', -1) as SIGNED))
								   	  ,CHAR_LENGTH(C.ORIGINAL)	
									) + CHAR_LENGTH(C.ORIGINAL)	
									,CHAR_LENGTH(C.ORIGINAL)
								  ) + 1
								 , 1),
						SUBSTRING(C.ORIGINAL
								, mod(
									mod(
										(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.INVERSA, ';', -1), ',', 1) as SIGNED) * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, 'Ж', 1), ',', 1) as SIGNED))
									  + (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.INVERSA, ';', -1), ',', 2), ',', -1) as SIGNED) * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, 'Ж', 1), ',', 2), ',', -1) as SIGNED))
									  + (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.INVERSA, ';', -1), ',', -1) as SIGNED) * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, 'Ж', 1), ',', -1) as SIGNED))
								   	  ,CHAR_LENGTH(C.ORIGINAL)	
									) + CHAR_LENGTH(C.ORIGINAL)	
									,CHAR_LENGTH(C.ORIGINAL)
								  ) + 1
								 , 1)
						)
				)
			else
				C.DECIFRADO
			END
		as DECIFRADO,
		
		case
			when (((CHAR_LENGTH(C.BLOCO_ATUAL) - CHAR_LENGTH(REPLACE(C.BLOCO_ATUAL, ',', '')))
	           + (CHAR_LENGTH(C.BLOCO_ATUAL) - CHAR_LENGTH(REPLACE(C.BLOCO_ATUAL, 'Ж', '')))) 
	           = CHAR_LENGTH(C.SENHA) - 1) then 
	            'T' 
	        else
	        	C.BLOCO_PREENCHIDO
			end
		as BLOCO_PREENCHIDO,
		
		case
			when (C.CONTADOR = 1) then 
				'T'
			else
				C.CONTADOR_2
			end
		as CONTADOR_2	
			
	FROM USUARIO_B AA
    JOIN VW_Criptografia C ON AA.ID = C.ID
    where (C.LINHA <= 450)
)
SELECT *
FROM VW_CRIPTOGRAFIA