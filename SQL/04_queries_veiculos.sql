-- (Query 5) Classificação dos veículos visitados
-- Colunas: classificação do veículo, veículos visitados (#)
-- Regra de negócio: Veículos novos tem até 2 anos e seminovos acima de 2 anos

with veiculos_classificados as (
	SELECT
	pro.product_id,
	pro.model,
	pro.model_year::int as ano_modelo,
	fun.visit_page_date,
 EXTRACT(YEAR FROM fun.visit_page_date) - pro.model_year::int AS idade_veiculo,	
 	CASE
		WHEN EXTRACT(YEAR FROM fun.visit_page_date) - pro.model_year::int <=2 THEN 'Novo'
		ELSE 'Seminovo'
	END AS classificacao_veiculo
from sales.funnel as fun
join sales.products as pro
	on fun.product_id = pro.product_id
)
SELECT
	classificacao_veiculo,
	 COUNT(*) AS veiculos_visitados
FROM veiculos_classificados
group BY classificacao_veiculo

-- (Query 6) Idade dos veículos visitados
-- Colunas: Idade do veículo, veículos visitados (%), ordem

WITH idade_veiculo AS ( 
	SELECT
		pro.product_id,
		pro.model,
		pro.model_year::int,
		fun.visit_page_date,
		EXTRACT(YEAR FROM fun.visit_page_date) - pro.model_year::int,
		CASE
			WHEN EXTRACT(YEAR FROM fun.visit_page_date) - pro.model_year::int <= 2 THEN 'até 2 anos'
			WHEN EXTRACT(YEAR FROM fun.visit_page_date) - pro.model_year::int <= 4 THEN 'de 2-4 anos'
			WHEN EXTRACT(YEAR FROM fun.visit_page_date) - pro.model_year::int <= 6 THEN 'de 4-6 anos'
			WHEN EXTRACT(YEAR FROM fun.visit_page_date) - pro.model_year::int <= 8 THEN 'de 6-8 anos'
			WHEN EXTRACT(YEAR FROM fun.visit_page_date) - pro.model_year::int <= 10 THEN 'de 8-10 anos'
			ELSE '+10 anos'
		end AS idade_do_veiculo,
		CASE
			WHEN EXTRACT(YEAR FROM fun.visit_page_date) - pro.model_year::int <= 2 THEN '1'
			WHEN EXTRACT(YEAR FROM fun.visit_page_date) - pro.model_year::int <= 4 THEN '2'
			WHEN EXTRACT(YEAR FROM fun.visit_page_date) - pro.model_year::int <= 6 THEN '3'
			WHEN EXTRACT(YEAR FROM fun.visit_page_date) - pro.model_year::int <= 8 THEN '4'
			WHEN EXTRACT(YEAR FROM fun.visit_page_date) - pro.model_year::int <= 10 THEN '5'
			ELSE '6'
		end AS ordem
FROM sales.funnel as fun
JOIN sales.products as pro
	ON fun.product_id = pro.product_id
)

SELECT 
	idade_do_veiculo,
	ROUND( COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 0 
	)AS "veiculos_visitados (%)",
	ordem
FROM idade_veiculo
GROUP BY idade_do_veiculo, ordem
ORDER BY ordem ;
	
-- (Query 7) Veículos mais visitados por marca
-- Colunas: brand, model, visitas (#)

SELECT
	pro.brand as marca,
	pro.model as modelo,
	count(fun.visit_page_date) as visitas
from sales.products as pro
join sales.funnel as fun
	ON pro.product_id = fun.product_id
group by pro.brand, pro.model
order by pro.brand, pro.model, visitas desc;
		