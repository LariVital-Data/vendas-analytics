CREATE OR REPLACE VIEW sales.fato_vendas AS
SELECT
    fun.visit_id,
    fun.customer_id,
    
    (cus.first_name || ' ' || cus.last_name) AS cliente_nome,
    cus.city AS cliente_cidade,
    cus.state AS cliente_estado,
    cus.income AS cliente_renda,
    age.idade_do_cliente AS cliente_idade,
    gen.gender AS cliente_genero,  
    
    fun.product_id,
    pro.brand AS produto_marca,
    pro.model AS produto_modelo,
    pro.price AS produto_preco,
    
    fun.store_id,
    sto.store_name AS loja_nome,
    
    fun.visit_page_date,
    fun.paid_date,
    fun.add_to_cart_date,
    fun.discount,
    pro.price * (1 + COALESCE(fun.discount,0)) AS valor_liquido,

    EXTRACT(YEAR FROM fun.paid_date) AS ano,
    EXTRACT(MONTH FROM fun.paid_date) AS mes

FROM sales.funnel AS fun
INNER JOIN sales.products AS pro
    ON pro.product_id = fun.product_id
INNER JOIN sales.stores AS sto
    ON sto.store_id = fun.store_id
INNER JOIN sales.customers AS cus
    ON cus.customer_id = fun.customer_id
INNER JOIN temp_tables.customers_age AS age
    ON age.customer_id = cus.customer_id
LEFT JOIN temp_tables.ibge_genders AS gen
    ON TRIM (LOWER(cus.first_name)) = TRIM (LOWER(gen.first_name));

select *  from sales.fato_vendas
select discount from sales.funnel