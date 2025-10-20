-- Número de clientes por gênero
SELECT 
	cliente_genero as "gênero",
 	TO_CHAR(COUNT(DISTINCT customer_id), 'FM999G999G999') AS "clientes (#)"
FROM sales.fato_vendas
GROUP BY cliente_genero
ORDER BY COUNT(DISTINCT customer_id) DESC;

-- Ticket médio por genero
select
	cliente_genero as "gênero",
	--'R$ ' || TO_CHAR(ROUND(SUM(valor_liquido)/1000, 1), 'FM999G999G999D0') AS "receita (R$)",
	'R$ ' || TO_CHAR(ROUND(SUM(valor_liquido) / COUNT(DISTINCT customer_id), 2), 'FM999G999G999D0') AS "ticket_médio (R$)"
from sales.fato_vendas
GROUP BY cliente_genero

-- filtro de compra por genero
select
	cliente_genero as "gênero",
	count(distinct customer_id) as clientes_compraram
from sales.fato_vendas
where paid_date is not null
group by cliente_genero

-- Faixa etária x Leads
select
	case 
		when cliente_idade < 20 then '0-20'
		when cliente_idade < 40 then '20-40'
		when cliente_idade < 60 then '40-60'
		when cliente_idade < 80 then '60-80'
		else '80+'
	end as faixa_etaria,
		ROUND( 
			count(distinct customer_id) * 100.0 / SUM(COUNT(DISTINCT customer_id)) OVER(), 
		0
	) as "leads(%)"
from sales.fato_vendas
group by faixa_etaria
order by count(distinct customer_id) * 100.0 / SUM(COUNT(DISTINCT customer_id)) OVER()

-- Faixa etaria x Leads x genero x ticket médio
SELECT
    CASE 
        WHEN cliente_idade < 20 THEN '0-20'
        WHEN cliente_idade < 40 THEN '20-40'
        WHEN cliente_idade < 60 THEN '40-60'
        WHEN cliente_idade < 80 THEN '60-80'
        ELSE '80+'
    END AS faixa_etaria,
    cliente_genero,
    COUNT(DISTINCT customer_id) AS total_leads,
    ROUND(
        COUNT(DISTINCT customer_id) * 100.0 
        / SUM(COUNT(DISTINCT customer_id)) OVER (), 
        1
    ) AS perc_faixa,
	'R$ ' || TO_CHAR(
		(SUM(valor_liquido)) / COUNT(DISTINCT visit_id), 
		'FM999G999G999D0' 
		)AS "Ticket Médio (R$)"
FROM sales.fato_vendas
GROUP BY faixa_etaria, cliente_genero
ORDER BY faixa_etaria, cliente_genero;

-- Faixa salarial dos leads

select 
	case
		when cliente_renda < 5000 then '0-5000'
		when cliente_renda < 10000 then '5000-10000'
		when cliente_renda < 15000 then '10000-15000'
		when cliente_renda < 20000 then '15000-20000'
		else '+20000'
	end as faixa_salarial,

	'R$ ' || TO_CHAR(
		(SUM(valor_liquido)) / COUNT(DISTINCT visit_id), 
		'FM999G999G999D0' 
		)AS "Ticket Médio (R$)",
	
	ROUND( 
			count(distinct customer_id) * 100.0 / SUM(COUNT(DISTINCT customer_id)) OVER(), 
		0
	) as "leads(%)"
	
from sales.fato_vendas
GROUP BY faixa_salarial
ORDER BY faixa_salarial desc
   
-- Faixa salarial x leads x ticket médio
WITH faixa_salarial AS (
    SELECT
        customer_id,
        visit_id,
        valor_liquido,
        CASE
            WHEN cliente_renda < 5000 THEN '0-5000'
            WHEN cliente_renda < 10000 THEN '5000-10000'
            WHEN cliente_renda < 15000 THEN '10000-15000'
            WHEN cliente_renda < 20000 THEN '15000-20000'
            ELSE '+20000'
        END AS faixa_salarial
    FROM sales.fato_vendas
)

SELECT
    faixa_salarial,
    'R$ ' || TO_CHAR(
        SUM(valor_liquido) / COUNT(DISTINCT visit_id),
        'FM999G999G999D0'
    ) AS "Ticket Médio (R$)",
    ROUND(
        COUNT(DISTINCT customer_id) * 100.0 / SUM(COUNT(DISTINCT customer_id)) OVER(),
        0
    ) AS "leads(%)"
FROM faixa_salarial
GROUP BY faixa_salarial
ORDER BY 
    CASE faixa_salarial
        WHEN '0-5000' THEN 1
        WHEN '5000-10000' THEN 2
        WHEN '10000-15000' THEN 3
        WHEN '15000-20000' THEN 4
        WHEN '+20000' THEN 5
    END;

