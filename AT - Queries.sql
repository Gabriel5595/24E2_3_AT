USE MODELAGEM_AT;

/*QUERY 1
Escreva uma query que utilize INNER JOIN para recuperar todos os telefones de uma empresa específica com uma classificação superior a 4.*/
SELECT mobile_phone_price.NAME, mobile_phone_price.RATING, COMPANIES.COMPANY_NAME
FROM mobile_phone_price
INNER JOIN COMPANIES ON mobile_phone_price.COMPANY_ID = COMPANIES.COMPANY_ID
WHERE COMPANIES.COMPANY_NAME = 'Samsung'
AND mobile_phone_price.RATING > 4;

/*QUERY 2
Escreva uma query que utilize LEFT JOIN para listar todos os telefones e suas respectivas empresas, incluindo telefones que não possuem uma empresa associada.*/
SELECT mobile_phone_price.NAME, COMPANIES.COMPANY_NAME
FROM mobile_phone_price
LEFT JOIN COMPANIES ON mobile_phone_price.COMPANY_ID = COMPANIES.COMPANY_ID;

/*QUERY 3
Escreva uma query que agrupe os dados para mostrar a média de especificações dos telefones por empresa.*/
SELECT COMPANIES.COMPANY_NAME,
       AVG(SPECS.SPEC_SCORE) AS AVG_SPEC_SCORE
FROM mobile_phone_price
JOIN SPECS ON mobile_phone_price.SPEC_ID = SPECS.SPEC_ID
JOIN COMPANIES ON mobile_phone_price.COMPANY_ID = COMPANIES.COMPANY_ID
GROUP BY COMPANIES.COMPANY_NAME;
