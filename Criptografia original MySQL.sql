/*delete from USUARIO_A 

insert into USUARIO_A(ID, SENHA) VALUES(1, 'h')
insert into USUARIO_A(ID, SENHA) VALUES(1, '0biQz2;y6(FQ2Gc7ANq952YCLIXjaA01234567890biQz2;y6(FQ2Gc7ANq952YCLIXjaA01234567890biQz2;y6(FQ2Gc7ANq952YCLIXjaA01234567890biQz2;y6(FQ2Gc7ANq952YCLIXjaA0123456789')

select *
from usuario_a*/

-- SET SESSION cte_max_recursion_depth = 10000000000;

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
        CAST('' AS CHAR(500)) AS CRYPT,
        CAST('' AS CHAR(500)) AS DIV_CRYPT,
        CAST('' AS CHAR(500)) AS ENCRYPTED,
        CAST('' as CHAR(500)) AS CHAR_ATUAL,
        1 AS POSICAO,
        LENGTH(AA.SENHA) AS POS_AUX,
        '!#$%&''()*+,-./0123456789:;<=>?@abcdefghijklmnopqrstuvwxyz[]^_`ABCDEFGHIJKLMNOPQRSTUVWXYZ\Б' AS ORIGINAL,
        'Üúùø÷öõôóòñðïîíìëêéèçæåäãâáàßÝÛÚÙØ×ÖÕÔÓÒÑÐÏÎÍÌËÊÉÈÇÆÅÄÃÂÁÀ¿¾½¼»º¹¸·¶µ´³²±°¯®Д¬«ª©¨§¦¥¤£¡ГБ' AS CHANGED,
        CAST('' AS CHAR(500)) AS LEN_BLOCO,
        CAST('' AS CHAR(500)) AS LEN_SENHA,
        CAST('' AS CHAR(500)) AS BLOCO,
        1 AS COPRIMO,
        0 as COPRIMO_AUX,
        0 as COPRIMO_AUX_2,
        0 as COPRIMO_AUX_3,
        0 as COPRIMO_AUX_4,
        0 as COPRIMO_AUX_5,
        '18,11,12;13,14,15;2,16,17' AS MATRIZ,
        CAST('' as CHAR(500)) AS AUXILIAR,
        CAST('' AS CHAR(500)) AS ANTERIOR,
        0 AS CONTADOR,
        0 as CONTADOR_2,
        0 AS VIRGULA,
        CAST('' AS CHAR(500)) AS AUX_BLOCO,
        CAST('' AS CHAR(500)) AS BLOCO_ATUAL,
        0 as ITERACAO_EXTRA,
        CAST('' AS CHAR(500)) AS BLOCO_ANT,        
        0 AS CONT_BLOCOS,
        0 as CONT_BLOCOS_AUX,
        0 AS DETERMINANTE,
        '18,11,12;13,14,15;2,16,17' AS MATR_COPRIMO,
        0 AS GCD,
        0 AS DIVIDENDO,
        0 AS DIVISOR,
        0 AS RESTO,
        1 as LINHA
    FROM USUARIO_A AA
    
    UNION ALL
    
    SELECT 
        C.ID,
        C.SENHA,

        case 
        	when (C.CHAR_ATUAL <> '') 
        	  and (CHAR_LENGTH(C.CRYPT) <= CHAR_LENGTH(C.SENHA)) then 
        		CONCAT(
                    C.CRYPT,
                    SUBSTRING(
                        C.CHANGED,
                        CAST(MOD(18 * (INSTR(binary C.ORIGINAL, BINARY C.CHAR_ATUAL) - 1) + 20, ((LENGTH(C.CHANGED) / 2) - 1)) AS UNSIGNED) + 1,
                        1
                    )
                ) 
        	else
        	   C.CRYPT
        	end
        as CRYPT,
        
       CASE 
	        when (CHAR_LENGTH(C.CRYPT) = CHAR_LENGTH(C.SENHA)) THEN
	          CASE 
				when (CHAR_LENGTH(C.CRYPT) + CHAR_LENGTH(C.SENHA)) = 2 then 
		        	C.CRYPT
	        	WHEN MOD(CHAR_LENGTH(C.SENHA), 2) <> 0 then
	        		CONCAT(
		        		REVERSE(SUBSTRING(C.CRYPT, 1, FLOOR(CHAR_LENGTH(C.CRYPT) / 2))),
		        	    SUBSTRING(C.CRYPT, FLOOR(CHAR_LENGTH(C.SENHA) / 2) + 1, 1),
	   				    REVERSE(SUBSTRING(C.CRYPT, FLOOR(CHAR_LENGTH(C.CRYPT) / 2) + 2))
   					)
		      ELSE
		            CONCAT(
		        		REVERSE(SUBSTRING(C.CRYPT, 1, FLOOR(CHAR_LENGTH(C.CRYPT) / 2))),
		        	    REVERSE(SUBSTRING(C.CRYPT, FLOOR(CHAR_LENGTH(C.CRYPT) / 2) + 1))
   					)
		      end
		    else 
		       C.DIV_CRYPT
	   		end 
	   	as DIV_CRYPT,
         
       case 
        	when (INSTR(C.BLOCO, ';') = 0) 
        	  AND (((cast(((LENGTH(C.CRYPT) - (LENGTH(REPLACE(C.CRYPT, '¨', '')))) / 2) as unsigned) + LENGTH(REPLACE(C.CRYPT, '¨', ''))) = LENGTH(C.SENHA))
		      AND (C.POSICAO <= (LENGTH(C.SENHA) * 2) + 2)) THEN 
		         CONCAT(C.ENCRYPTED, SUBSTRING(C.DIV_CRYPT, C.POS_AUX + 1, 1)) 
        else 
        	C.ENCRYPTED
        end as ENCRYPTED,

       COALESCE(case
			        when (CHAR_LENGTH(C.CRYPT) <= CHAR_LENGTH(C.SENHA)) THEN 
		        	CASE
				        when (C.CHAR_ATUAL = '') then
				        	SUBSTRING(AA.SENHA, 1, 1) 
		        		else 
		        			case 
		        				when coalesce(SUBSTRING(C.SENHA, C.POSICAO, 1), '') <> '' then
		        					SUBSTRING(C.SENHA, C.POSICAO, 1)
		        				else 
		        					C.CHAR_ATUAL		
		        			end
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
        
        ((LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ',', '')))) + (LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ';', ''))) LEN_BLOCO,
        CHAR_LENGTH(C.SENHA) LEN_SENHA,
        
        case 
	        when ((LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ',', '')))) + (LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ';', ''))) = CHAR_LENGTH(C.SENHA) then
		        CASE
			        when (mod(CHAR_LENGTH(C.SENHA) + 2, 3) = 0) then 
			        	CONCAT(C.BLOCO, '89,89;')
			        when (mod(CHAR_LENGTH(C.SENHA) + 1, 3) = 0) then 
			        	CONCAT(C.BLOCO, '89;')	
			        else
			        	C.BLOCO
			    END
        	when (CHAR_LENGTH(C.DIV_CRYPT) = CHAR_LENGTH(C.SENHA))
        	  and ((INSTR(
					  CONVERT(CHANGED USING utf8mb4) COLLATE utf8mb4_bin, 
					  CONVERT(
					  		SUBSTRING(
					  				C.DIV_CRYPT, 
					  				(LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ',', ''))) + (LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ';', ''))) + 1, 
					  				1) 
					  		USING utf8mb4) 
					  COLLATE utf8mb4_bin
					) - 1 > 0) 
					or (CHAR_LENGTH(C.SENHA) > 1))
				and (((LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ',', '')))) + (LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ';', ''))) < CHAR_LENGTH(C.SENHA)) then
	         CASE 
				WHEN (mod(CHAR_LENGTH(C.SENHA), 3) = 0) then
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
				   	  when ((LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ',', ''))) % 2 <> 0)
				   	    or (RIGHT(C.BLOCO, 1) = ';')
				   	  	or (coalesce(C.BLOCO,'') = '') then
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
					  else
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
					  end
			   else
			   	  C.BLOCO
			   end
		 else
			coalesce(C.BLOCO, '')
	 	 end as BLOCO,
        
	 	 case 
		 	 when (1 <> 1) then 
		 	 	7
		 	 ELSE
		 	 COALESCE(
			 	 (case
		        	when (((((C.CONT_BLOCOS_AUX <> (LENGTH(C.BLOCO_ATUAL) - LENGTH(REPLACE(C.BLOCO_ATUAL, 'Ж', '')))) or (C.BLOCO_ATUAL <> C.BLOCO_ANT))
		        	  and (C.CONT_BLOCOS_AUX <> C.CONT_BLOCOS))) 
		        	  or (((coalesce(C.AUXILIAR,'') <> '') and (coalesce(C.ANTERIOR,'') <> '')) and (C.AUXILIAR <> C.ANTERIOR)))
		        	  and (C.COPRIMO = C.COPRIMO_AUX) then
		        		case
		        			when (C.COPRIMO < (select MAX(AA.LINHA) from VW_GetCoprimo AA)) then
		        				(select MIN(BB.LINHA) from VW_GetCoprimo BB where BB.LINHA > 
		        				(case 
						    	  	when not ((CASE 
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
										 = 0) /*and (C.CONTADOR < 2)*/ then
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
									end))
		        			when (C.COPRIMO = CHAR_LENGTH(C.CHANGED) - 1) then 
		        				1
		        			else
		        				C.COPRIMO
		        		end
		        	else
		        		C.COPRIMO
		        	end)
		        , 1) 
		 end as COPRIMO,
         
        COALESCE(C.COPRIMO, 0) as COPRIMO_AUX,
       
        COALESCE(C.COPRIMO_AUX, 0) as COPRIMO_AUX_2,
         
        COALESCE(C.COPRIMO_AUX_2, 0) as COPRIMO_AUX_3,
        
        COALESCE(C.COPRIMO_AUX_3, 0) as COPRIMO_AUX_4,
        
        COALESCE(C.COPRIMO_AUX_4, 0) as COPRIMO_AUX_5,
        
        C.MATRIZ,
        
      /*  case 
        	when (coalesce(C.IDENTIDADE,'') <> '') then 
        		'19,12,13;14,15,16;3,17,18'
        	else
        		''
            end
        as RESERVA,*/
        
        case
		    when (C.CONTADOR = 2) then 
		    	case
			    	when (C.CONTADOR_2 = 0) then 
			    	    case
				    	    when (1=1)/*not ((CASE 
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
								 = 0)*/ then 
							CONCAT(
					        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', 1) as SIGNED) + 1),
					        	',',
					        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED),
					        	',',
					        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', -1) as SIGNED),
					        	';',
					        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 1) as SIGNED),
					        	',',
					        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 2), ',', -1) as SIGNED) + 1),
					        	',',
					        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', -1) as SIGNED),
					        	';',
					        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 1) as SIGNED),
					        	',',
					        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 2), ',', -1) as SIGNED),
					        	',',
					        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', -1) as SIGNED) + 1)
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
				        END
		    		else
		    			case
				    	    when /*not ((CASE 
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
								              (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 1) as SIGNED)
								               * (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', 2), ',', -1) as SIGNED)
								                 * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', -1) as SIGNED)
								                 - cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', -1) as SIGNED)
								                 * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 2), ',', -1) as SIGNED)
								                 )
								               - cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED)
								                * (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', 1) as SIGNED)
								                 * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', -1) as SIGNED)
								                 - cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', -1) as SIGNED)
								                 * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 1) as SIGNED)
								                 )
								               + cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', -1) as SIGNED)
								               * (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', 1) as SIGNED)
								                 * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 2), ',', -1) as SIGNED)
								                 - cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', 2), ',', -1) as SIGNED)
								                 * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 1) as SIGNED)
								                 )
								            ) % 90) as det
								         ) DE) = 1)
								    THEN 1
								    ELSE 0
								END) 
								 = 0)*/ (1=1) then 
							CONCAT(
					        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 1) as SIGNED) + 1),
					        	',',
					        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED),
					        	',',
					        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', -1) as SIGNED),
					        	';',
					        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', 1) as SIGNED),
					        	',',
					        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', 2), ',', -1) as SIGNED) + 1),
					        	',',
					        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', -1) as SIGNED),
					        	';',
					        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 1) as SIGNED),
					        	',',
					        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 2), ',', -1) as SIGNED),
					        	',',
					        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', -1) as SIGNED) + 1)
					        )	 
			    	    else
				    		CONCAT(
					        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 1) as SIGNED),
					        	',',
					        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED),
					        	',',
					        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', -1) as SIGNED),
					        	';',
					        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', 1) as SIGNED),
					        	',',
					        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', 2), ',', -1) as SIGNED),
					        	',',
					        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', -1) as SIGNED),
					        	';',
					        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 1) as SIGNED),
					        	',',
					        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 2), ',', -1) as SIGNED),
					        	',',
					        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', -1) as SIGNED)
					        )
				        END
				    END
	        when (COALESCE(
				 	 (case
			        	when ((((C.CONT_BLOCOS_AUX <> (LENGTH(C.BLOCO_ATUAL) - LENGTH(REPLACE(C.BLOCO_ATUAL, 'Ж', '')))) or (C.BLOCO_ATUAL <> C.BLOCO_ANT))
			        	  and (C.CONT_BLOCOS_AUX <> C.CONT_BLOCOS)) 
			        	  or (((coalesce(C.AUXILIAR,'') <> '') and (coalesce(C.ANTERIOR,'') <> '')) and (C.AUXILIAR <> C.ANTERIOR)))
			        	  and (coalesce(C.AUXILIAR,'') <> '') then
			        		case
			        			when (C.COPRIMO < (select MAX(AA.LINHA) from VW_GetCoprimo AA)) then
			        				(select MIN(BB.LINHA) from VW_GetCoprimo BB where BB.LINHA > 
			        				(case 
							    	  	when not ((CASE 
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
											 = 0) and (C.CONTADOR < 2) then
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
										end))
			        			when (C.COPRIMO = CHAR_LENGTH(C.CHANGED) - 1) then 
			        				1
			        			else
			        				C.COPRIMO
			        		end
			        	else
			        		C.COPRIMO
			        	end)
		        	, 1) = 1)
		      and (C.CONT_BLOCOS <> (LENGTH(C.BLOCO_ATUAL) - LENGTH(REPLACE(C.BLOCO_ATUAL, 'Ж', '')))) 
		      and (C.CONTADOR < 2) then
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
	        when  (C.CONTADOR < 2) 
	          and ((case
		        	when ((((C.CONT_BLOCOS_AUX <> (LENGTH(C.BLOCO_ATUAL) - LENGTH(REPLACE(C.BLOCO_ATUAL, 'Ж', '')))) or (C.BLOCO_ATUAL <> C.BLOCO_ANT))
		        	  and (C.CONT_BLOCOS_AUX <> C.CONT_BLOCOS) or (((C.CONT_BLOCOS_AUX <> (LENGTH(C.BLOCO_ATUAL) - LENGTH(REPLACE(C.BLOCO_ATUAL, 'Ж', ''))))) and (C.BLOCO_ATUAL <> C.BLOCO_ANT) and (C.CONT_BLOCOS_AUX <> C.CONT_BLOCOS))) 
		        	  or (((coalesce(C.AUXILIAR,'') <> '') and (coalesce(C.ANTERIOR,'') <> '')) and (C.AUXILIAR <> C.ANTERIOR)))
		        	  and (coalesce(C.AUXILIAR,'') <> '') then
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
										 = 0) and (C.CONTADOR < 2) then
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
									end))
		        			when (C.COPRIMO = CHAR_LENGTH(C.CHANGED) - 1) then 
		        				1
		        			else
		        				C.COPRIMO
		        		end
		        	else
		        		C.COPRIMO
		        	end) >= (select MAX(AA.LINHA) from VW_GetCoprimo AA)) 
		        	
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
	        when (C.CONTADOR = 3) or (coalesce(C.AUXILIAR,'') = '') then 
	        	C.MATRIZ
	       /* when (C.CONTADOR = 2) 
	          and (coalesce(C.ANTERIOR,'') <> '') 
	          and (coalesce(C.AUXILIAR,'') <> '') then */
	  
	         	/*case 
		        	when not ((CASE 
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
					    	when not ((CASE 
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
								              ((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', 1) as SIGNED) + 1)
								               * ((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 2), ',', -1) as SIGNED) + 1)
								                 * (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', -1) as SIGNED) + 1)
								                 - cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', -1) as SIGNED)
								                 * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 2), ',', -1) as SIGNED)
								                 )
								               - cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED)
								                * (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 1) as SIGNED)
								                 * (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', -1) as SIGNED) + 1)
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
								 '19,12,13;14,15,16;3,17,18'
							else
								CONCAT(
						        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', 1) as SIGNED) + 1),
						        	',',
						        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED),
						        	',',
						        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', -1) as SIGNED),
						        	';',
						        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 1) as SIGNED),
						        	',',
						        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 2), ',', -1) as SIGNED) + 1),
						        	',',
						        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', -1) as SIGNED),
						        	';',
						        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 1) as SIGNED),
						        	',',
						        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 2), ',', -1) as SIGNED),
						        	',',
						        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', -1) as SIGNED) + 1)
						        )
				        end
					else
						CONCAT(
				        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', 1) as SIGNED) + 1),
				        	',',
				        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED),
				        	',',
				        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', -1) as SIGNED),
				        	';',
				        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 1) as SIGNED),
				        	',',
				        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 2), ',', -1) as SIGNED) + 1),
				        	',',
				        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', -1) as SIGNED),
				        	';',
				        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 1) as SIGNED),
				        	',',
				        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 2), ',', -1) as SIGNED),
				        	',',
				        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', -1) as SIGNED) + 1)
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
			    END*/
		    ELSE	        
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
		    end
		AS AUXILIAR,
        
        case
	        when (C.CONTADOR = 2) and (C.CONTADOR_2 = 0) then 
	        	C.ANTERIOR
        	when ((C.CONT_BLOCOS <> (LENGTH(C.BLOCO_ATUAL) - LENGTH(REPLACE(C.BLOCO_ATUAL, 'Ж', ''))))
        	  or  (coalesce(C.AUXILIAR,'') <> ''))
        	  and (C.COPRIMO = C.COPRIMO_AUX) then
        		C.AUXILIAR 
        	else
        		C.ANTERIOR
        	end
        as ANTERIOR,
        
        /*CASE
        	when (C.CONTADOR = 2) then 
	        	CONCAT(
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', 1) as unsigned),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', 2), ',', -1) as unsigned),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', -1) as unsigned),
		        	';',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 1) as unsigned),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 2), ',', -1) as unsigned),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', -1) as unsigned),
		        	';',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 1) as unsigned),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 2), ',', -1) as unsigned),
		        	',',
		        	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', -1) as unsigned)
		        )
		    else
		    	C.PERMUTA
		    end
		as PERMUTA, */

        case
	      when (C.CONTADOR = 2) 
	          and (coalesce(C.ANTERIOR,'') <> '') 
	          and (coalesce(C.AUXILIAR,'') <> '') 
	          and (C.CONT_BLOCOS_AUX <> (LENGTH(C.BLOCO_ATUAL) - LENGTH(REPLACE(C.BLOCO_ATUAL, 'Ж', ''))))
        	  and (C.CONT_BLOCOS_AUX <> C.CONT_BLOCOS) then 
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
										              ((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', 1) as SIGNED) + 1)
										               * ((cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 2), ',', -1) as SIGNED) + 1)
										                 * (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', -1) as SIGNED) + 1)
										                 - cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', -1) as SIGNED)
										                 * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', 2), ',', -1) as SIGNED)
										                 )
										               - cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 2), ';', -1), ',', 2), ',', -1) as SIGNED)
										                * (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', -1), ',', 1) as SIGNED)
										                 * (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.ANTERIOR, ';', 1), ',', -1) as SIGNED) + 1)
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
										 = 0) and (C.CONTADOR < 2) then
										 C.CONTADOR + 1
									else
										C.CONTADOR 
						        end
							else
								C.CONTADOR
					    end
		        	else
			        	C.CONTADOR
			        end
		  when (coalesce(C.AUXILIAR,'') <> '') 
		    and (C.CONTADOR < 2) 
			and (C.CONT_BLOCOS_AUX <> (LENGTH(C.BLOCO_ATUAL) - LENGTH(REPLACE(C.BLOCO_ATUAL, 'Ж', ''))))
			and (C.CONT_BLOCOS <> C.CONT_BLOCOS_AUX)
			and (COALESCE(
			 	 (case
		        	when (C.CONT_BLOCOS_AUX <> (LENGTH(C.BLOCO_ATUAL) - LENGTH(REPLACE(C.BLOCO_ATUAL, 'Ж', ''))))
		        	  and (C.CONT_BLOCOS_AUX <> C.CONT_BLOCOS) 
		        	  and (coalesce(C.AUXILIAR,'') <> '') then
		        		case
		        			when (C.COPRIMO < (select MAX(AA.LINHA) from VW_GetCoprimo AA)) then
		        				(select MIN(BB.LINHA) from VW_GetCoprimo BB where BB.LINHA > 
		        				(case 
						    	  	when not ((CASE 
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
										 = 0) and (C.CONTADOR < 2) then
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
									end))
		        			when (C.COPRIMO = CHAR_LENGTH(C.CHANGED) - 1) then 
		        				1
		        			else
		        				C.COPRIMO
		        		end
		        	else
		        		C.COPRIMO
		        	end)
		        , 1) = 1) then
			 case
				when not ((CASE 
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
					C.CONTADOR + 1
				else 
					C.CONTADOR
				end
		  when (C.CONTADOR = 3) then
	         0
          else
        	 C.CONTADOR
          end
		AS CONTADOR,
		
		case
			when (C.CONTADOR = 3) then 
				0
			when (C.CONTADOR = 2) then 
				C.CONTADOR_2 + 1
			else 
				0
			end
		as CONTADOR_2,
        
        0 AS VIRGULA,
        
        case
        	when ((((LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ',', '')))) + (LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, ';', ''))))
              = (CHAR_LENGTH(C.SENHA)
              + ((LENGTH(C.BLOCO) - LENGTH(REPLACE(C.BLOCO, '89', ''))) / LENGTH('89'))))
              and (coalesce(C.AUX_BLOCO,'') = '') then 
				C.BLOCO
            when (coalesce(C.BLOCO,'') <> '') then 
				C.BLOCO
            else
            	C.AUX_BLOCO
            END	
        as AUX_BLOCO,

        case
	         when (coalesce(C.BLOCO_ATUAL) <> '') and ((LENGTH(C.BLOCO_ATUAL) - LENGTH(REPLACE(C.BLOCO_ATUAL, ';', ''))) = 0) then
	         	REPLACE(C.BLOCO_ATUAL, 'Ж', '')
	         when ((C.AUXILIAR <> C.ANTERIOR) and (coalesce(C.ANTERIOR,'') <> '')) or ((C.CONTADOR = 2) and ((C.CONTADOR_2 = 2))) then
	         	CONCAT(
		        	  SUBSTRING(
					          C.BLOCO_ATUAL, 
					          1, 
					          CHAR_LENGTH(C.BLOCO_ATUAL) - CHAR_LENGTH(SUBSTRING_INDEX(C.BLOCO_ATUAL, 'Ж', -1))
					  )
					  ,SUBSTRING(
			        		 	C.CHANGED
							   ,cast(
								  	MOD(
									  (MOD(
										  (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, 'Ж', -1), ';', 1), ',', 1) as unsigned)
										     * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 1) as unsigned))
										   + (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, 'Ж', -1), ';', 1), ',', 2), ',', -1) as unsigned)
									         * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 2), ',', -1) as unsigned)) 
									       + (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, 'Ж', -1), ';', 1), ',', -1) as unsigned)
									         * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', -1) as unsigned))	
									      ,CHAR_LENGTH(C.CHANGED)
										  ) 
										 + CHAR_LENGTH(C.CHANGED)
									  )
									  ,CHAR_LENGTH(C.CHANGED)
								    )
								  as unsigned) + 1
								 ,1
							)
					,SUBSTRING(
								 C.CHANGED
								,cast(MOD(
										(MOD(
											(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, 'Ж', -1), ';', 1), ',', 1) as unsigned)
									          * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 1) as unsigned))
									        + (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, 'Ж', -1), ';', 1), ',', 2), ',', -1) as unsigned)
									          * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 2), ',', -1) as unsigned))
									        + (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, 'Ж', -1), ';', 1), ',', -1) as unsigned)
										      * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', -1) as unsigned))	  
										    ,CHAR_LENGTH(C.CHANGED)
										 )
										 + CHAR_LENGTH(C.CHANGED))
									  ,CHAR_LENGTH(C.CHANGED)
								    )  
								 as unsigned) + 1
								,1
						)
						,SUBSTRING(
								 C.CHANGED
								,cast(MOD(
										(MOD(
											(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, 'Ж', -1), ';', 1), ',', 1) as unsigned)
									          * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', 1) as unsigned))
									        + (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, 'Ж', -1), ';', 1), ',', 2), ',', -1) as unsigned)
									          * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', 2), ',', -1) as unsigned))
									        + (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, 'Ж', -1), ';', 1), ',', -1) as unsigned)
										      * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', -1) as unsigned))	  
										    ,CHAR_LENGTH(C.CHANGED)
										 )
										 + CHAR_LENGTH(C.CHANGED))
									  ,CHAR_LENGTH(C.CHANGED)
								    )  
								 as unsigned) + 1
								,1
						)
						,'Ж'
						,SUBSTRING(C.BLOCO_ATUAL, 
       						LOCATE(';', C.BLOCO_ATUAL) + 1)		
				)
	        when ((coalesce(C.BLOCO_ATUAL,'') <> '') and ((LENGTH(C.BLOCO_ATUAL) - LENGTH(REPLACE(C.BLOCO_ATUAL, 'Ж', ''))) = 0))
	        	and (C.AUXILIAR = C.ANTERIOR) then
	        	CONCAT(
		        		SUBSTRING(
			        		 C.CHANGED
				            ,CAST(MOD(
						        	(mod(
							        	(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, ';', 1), ',', 1) as unsigned)
							        	* cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 1) as unsigned))
							          + (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, ';', 1), ',', 2), ',', -1) as unsigned)
							          	* cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', 2), ',', -1) as unsigned))
							          + (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, ';', 1), ',', -1) as unsigned)
							          	* cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 1), ',', -1) as unsigned))	
							          ,CHAR_LENGTH(C.CHANGED)
							        )
							        + CHAR_LENGTH(C.CHANGED))
							       ,CHAR_LENGTH(C.CHANGED)
							    ) 
							 AS unsigned) + 1
							,1
						)
						,SUBSTRING(
								 C.CHANGED
								,cast(MOD(
										(MOD(
											(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, ';', 1), ',', 1) as unsigned)
									          * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 1) as unsigned))
									        + (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, ';', 1), ',', 2), ',', -1) as unsigned)
									          * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', 2), ',', -1) as unsigned))
									        + (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, ';', 1), ',', -1) as unsigned)
										      * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', 2), ';', -1), ',', -1) as unsigned))	  
										    ,CHAR_LENGTH(C.CHANGED)
										 )
										 + CHAR_LENGTH(C.CHANGED))
									  ,CHAR_LENGTH(C.CHANGED)
								    )  
								 as unsigned) + 1
								,1
						)
						,SUBSTRING(
								 C.CHANGED
								,cast(MOD(
										(MOD(
											(cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, ';', 1), ',', 1) as unsigned)
									          * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', 1) as unsigned))
									        + (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, ';', 1), ',', 2), ',', -1) as unsigned)
									          * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', 2), ',', -1) as unsigned))
									        + (cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.BLOCO_ATUAL, ';', 1), ',', -1) as unsigned)
										      * cast(SUBSTRING_INDEX(SUBSTRING_INDEX(C.AUXILIAR, ';', -1), ',', -1) as unsigned))	  
										    ,CHAR_LENGTH(C.CHANGED)
										 )
										 + CHAR_LENGTH(C.CHANGED))
									  ,CHAR_LENGTH(C.CHANGED)
								    )  
								 as unsigned) + 1
								,1
						)
						,'Ж'
						,SUBSTRING(C.BLOCO_ATUAL, 
       						LOCATE(';', C.BLOCO_ATUAL) + 1)
					)
        	when (coalesce(C.AUX_BLOCO,'') = coalesce(C.BLOCO,'')) and (coalesce(C.BLOCO_ATUAL,'') = '') then
        		C.AUX_BLOCO
        	else
        		C.BLOCO_ATUAL
        	end
        as BLOCO_ATUAL,

	case 
        when LINHA = 266 and COPRIMO = 1 and CONT_BLOCOS = 0 then 0  -- Primeira passagem
        when LINHA = 266 and COPRIMO = 1 and CONT_BLOCOS = 0 then 1  -- Segunda passagem  
        else 0
    end as ITERACAO_EXTRA,
        
        case 
        	when (coalesce(C.BLOCO_ATUAL,'') <> '') then 
        		C.BLOCO_ATUAL
        	else 
        		''
            end 
        as BLOCO_ANT,
        
        case
        	when (coalesce(C.BLOCO_ATUAL,'') = '') then 
        		0
        	else
        		LENGTH(C.BLOCO_ATUAL) - LENGTH(REPLACE(C.BLOCO_ATUAL, 'Ж', '')) 
            end
        AS CONT_BLOCOS,
        
        case
        	when (coalesce(C.CONT_BLOCOS,0) = 0) then 
        		0
        	else
        		C.CONT_BLOCOS
            end
        AS CONT_BLOCOS_AUX,
      
        0 as DETERMINANTE,
           
        C.MATR_COPRIMO,
        C.GCD,
        
        case 
        	when (C.DIVIDENDO = 0) then 
        		(LOCATE(binary C.CHAR_ATUAL,C.ORIGINAL) - 1)
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
        		mod((LOCATE(binary C.CHAR_ATUAL,C.ORIGINAL) - 1), cast((length(C.CHANGED) / 2) as unsigned))
        	else
        		RESTO
        end RESTO,
        
        LINHA + 1 as LINHA
        
    FROM USUARIO_A AA
    JOIN VW_Criptografia C ON AA.ID = C.ID
    WHERE not ((C.CONT_BLOCOS = 0) and (C.CONT_BLOCOS_AUX <> 0)) 
)
select *
from VW_CRIPTOGRAFIA

/*,
VW_CRIPT_AUX as (
	SELECT ROW_NUMBER() OVER (PARTITION BY id ORDER BY linha DESC) as RN,
		ID, SENHA, BLOCO_ATUAL
	FROM VW_Criptografia
)
select ID, SENHA, BLOCO_ATUAL
from VW_CRIPT_AUX
where RN = 1
order by ID*/