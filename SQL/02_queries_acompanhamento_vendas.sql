-- Receita, leads, ticket-médio
WITH
leads AS (
    SELECT 
        DATE_TRUNC('month', visit_page_date)::date AS mes,
        COUNT(DISTINCT customer_id) AS total_leads
    FROM sales.fato_vendas
    GROUP BY 1
),
vendas AS (
    SELECT
        DATE_TRUNC('month', paid_date)::date AS mes,
        COUNT(DISTINCT visit_id) AS total_vendas,
        SUM(valor_liquido) AS receita
    FROM sales.fato_vendas
    WHERE paid_date IS NOT NULL
    GROUP BY 1
)
SELECT
    TO_CHAR(l.mes, 'YYYY-MM') AS "Mês",
    l.total_leads AS "Leads (#)",
    v.total_vendas AS "Vendas (#)",

    -- Receita formatada em milhares com R$
    'R$ ' || TO_CHAR(ROUND(v.receita / 1000, 1), 'FM999G999G999D0') AS "Receita (mil R$)",

    -- Conversão formatada em %
    TO_CHAR(ROUND((v.total_vendas::numeric / NULLIF(l.total_leads, 0)) * 100, 1), 'FM999D0') || '%' AS "Conversão (%)",

    -- Ticket médio formatado com R$
    'R$ ' || TO_CHAR(ROUND(v.receita / NULLIF(v.total_vendas, 0) / 1000, 1), 'FM999G999G999D0') AS "Ticket Médio (mil R$)"
FROM leads l
LEFT JOIN vendas v ON l.mes = v.mes
ORDER BY l.mes;

-- (Query 2) Estados que mais  venderam 
SELECT 
	'Brasil' AS país,
	cliente_estado as estado,
	COUNT(DISTINCT visit_id) AS "vendas (#)"
FROM sales.fato_vendas
WHERE paid_date IS NOT NULL 
	and paid_date between '2021-08-01' and '2021-08-31' -- seleciona o ultimo mês
GROUP BY país, estado
ORDER BY "vendas (#)" desc
LIMIT 5;

-- (Query 3): Top cinco marcas mais vendidas no mês
select
	produto_marca as marca,
	count(paid_date) as vendas
from sales.fato_vendas
Where paid_date is not null 
	and paid_date between '2021-08-01' and '2021-08-31'
group by produto_marca
order by vendas desc
limit 5;

-- (Query 04): Top cinco Lojas que mais venderam no mês

select
	loja_nome as loja,
	count(paid_date) as vendas
from sales.fato_vendas
Where paid_date is not null 
	and paid_date between '2021-08-01' and '2021-08-31'
group by loja_nome
order by vendas desc
limit 5;

--(query 05): Dias da semana com maior número de visitas no site

select
	EXTRACT(DOW FROM visit_page_date) AS dia_semana,
case 
	when EXTRACT(DOW FROM visit_page_date)=0 then 'Domingo'
	when EXTRACT(DOW FROM visit_page_date)=1 then 'Segunda-Feira'
	when EXTRACT(DOW FROM visit_page_date)=2 then 'Terça-Feira'
	when EXTRACT(DOW FROM visit_page_date)=3 then 'Quarta-Feira' 
	when EXTRACT(DOW FROM visit_page_date)=4 then 'Quinta-Feira'
	when EXTRACT(DOW FROM visit_page_date)=5 then 'Sexta-Feira'
	when EXTRACT(DOW FROM visit_page_date)=6 then 'Sábado'
	else null end as "dia da semana",
	count(visit_page_date) as visitas
from sales.fato_vendas
Where visit_page_date between '2021-08-01' and '2021-08-31'
group by dia_semana
order by dia_semana;

