WITH RECURSIVE 
VW_Criptografia AS (
    SELECT 
        AA.ID,
        AA.SENHA,
        cast('' AS CHAR(85)) CRYPT,
        cast('' AS CHAR(85)) AS DIV_CRYPT,
        cast('' AS CHAR(85)) AS ENCRYPTED,
        SUBSTRING(AA.SENHA, 1, 1) AS CHAR_ATUAL,
        1 AS POSICAO,
        LENGTH(AA.SENHA) AS POS_AUX,
        '!#$%&''()*+,-./0123456789:;<=>?@abcdefghijklmnopqrstuvwxyz[]^_`ABCDEFGHIJKLMNOPQRSTUVWXYZ\Б' AS ORIGINAL,
        'Üúùø÷öõôóòñðïîíìëêéèçæåäãâáàßÝÛÚÙØ×ÖÕÔÓÒÑÐÏÎÍÌËÊÉÈÇÆÅÄÃÂÁÀ¿¾½¼»º¹¸·¶µ´³²±°¯®Д¬«ª©¨§¦¥¤£¡ГБ' AS CHANGED,
        '' AS BLOCO,
        1 AS COPRIMO,
        '18,11,12;13,14,15;2,16,17' AS MATRIZ,
        '19,12,13;14,15,16;3,17,18' AS RESERVA,
        '18,11,12;13,14,15;2,16,17' AS AUXILIAR,
        '18,11,12;13,14,15;2,16,17' AS ANTERIOR,
        0 AS CONTADOR,
        0 AS VIRGULA,
        cast('' AS CHAR(85)) AS AUX_BLOCO,
        cast('' AS CHAR(85)) AS BLOCO_ATUAL,
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
        	when (length(C.CRYPT) < LENGTH(C.SENHA)) then
        		/*CONCAT(
		            C.CRYPT,
		            SUBSTRING(
		                C.CHANGED,
		                MOD(
		                    18 * (LOCATE(C.CHAR_ATUAL,C.ORIGINAL) - 1) + 20,
		                    LENGTH(C.CHANGED)
		                ),
		                1
		            )
		        ) */
        		/*MOD(
                    18 * (LOCATE(C.CHAR_ATUAL,C.ORIGINAL) - 1) + 20,
                    LENGTH(C.CHANGED) - 1
                )*/ mod(18 * (LOCATE(C.CHAR_ATUAL,C.ORIGINAL) - 1) + 20, ((LENGTH(C.CHANGED) / 2) - 1))
		    else
		    	CRYPT
            end
        AS CRYPT,
        
       CASE WHEN MOD(LENGTH(C.SENHA), 2) <> 0 then
       		''
		   /*CONCAT(
		        SUBSTRING(
		            C.CRYPT, 
		            TRUNCATE(LENGTH(C.SENHA) / 2, 0) + 2, 
		            LENGTH(C.SENHA) - TRUNCATE(LENGTH(C.SENHA) / 2, 0) + 2
		        ),
		        SUBSTRING(C.CRYPT, (TRUNCATE(LENGTH(C.SENHA) / 2, 0) + 1), 1),
		        SUBSTRING(C.CRYPT, 1, TRUNCATE(LENGTH(C.SENHA) / 2, 0))
		    )*/ 
		ELSE
		    /*CONCAT(
		        SUBSTRING(
		            C.CRYPT, 
		            TRUNCATE(LENGTH(C.SENHA) / 2, 0) + 1, 
		            LENGTH(C.SENHA) - TRUNCATE(LENGTH(C.SENHA) / 2, 0) + 1
		        ),
		        SUBSTRING(C.CRYPT, 1, TRUNCATE(LENGTH(C.SENHA) / 2, 0))
		    )*/ ''
		END AS  DIV_CRYPT,
         
        /*CASE WHEN (LENGTH(CRYPT) = LENGTH(SENHA) AND (POSICAO <= (LENGTH(SENHA) * 2) + 2) THEN 
		    CONCAT(ENCRYPTED, SUBSTRING(DIV_CRYPT, POS_AUX + 1, 1))
		ELSE
		    ENCRYPTED
		END AS*/ '' ENCRYPTED,

        SUBSTRING(C.SENHA, C.POSICAO, 1) AS CHAR_ATUAL,
        C.POSICAO + 1,
        0 AS POS_AUX,
        C.ORIGINAL,
        C.CHANGED,
        '' AS BLOCO,
        1 AS COPRIMO,
        C.MATRIZ,
        C.RESERVA,
        C.MATRIZ AS AUXILIAR,
        C.AUXILIAR AS ANTERIOR,
        0 AS CONTADOR,
        0 AS VIRGULA,
        '' AS AUX_BLOCO,
        '' AS BLOCO_ATUAL,
        0 AS CONT_BLOCOS,
        C.DETERMINANTE,
        C.MATR_COPRIMO,
        C.GCD,
        C.DIVIDENDO,
        C.DIVISOR,
        C.RESTO
    FROM USUARIO_A AA
    JOIN VW_Criptografia C ON AA.ID = C.ID
    WHERE C.POSICAO <= (LENGTH(AA.SENHA) * 3) 
)
SELECT * 
FROM VW_Criptografia;