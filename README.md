# 📊 Projeto de Análise de Vendas

Este projeto tem como objetivo analisar o desempenho de vendas com base em uma base de dados relacional, permitindo identificar padrões de consumo, veículos mais visitados e comportamento dos leads ao longo do funil de conversão.

---

## 🧠 Objetivos do Projeto

- Criar uma **view consolidada de vendas** para simplificar consultas e análises.
- Identificar os **veículos mais visitados por marca e modelo**.
- Classificar os veículos por **faixa de idade (novo ou seminovo)**.
- Explorar métricas de **engajamento e conversão** dentro do funil de vendas.

---

## 📂 Estrutura do Projeto
```
vendas-analytics/
├─ 📂sql/
│ ├─🧩 01_view_fato_vendas.sql # Criação da view principal consolidando dados de vendas
│ ├─📊 02_queries_etapa1.sql # Consultas iniciais (exploração, classificação e métricas)
│ ├─📈 03_queries_etapa2.sql # Consultas avançadas (segmentações e análises complementares)
├─📄 docs/
│ ├─🖼️ prints/ # Capturas de tela dos resultados e gráficos 
└─🧾 README.md # Documentação principal do projeto
```

## 🧩 Tecnologias Utilizadas

- **PostgreSQL** – consultas SQL e criação de views
- **DBeaver** – ferramenta de conexão e análise do banco
- **Git & GitHub** – versionamento e publicação do projeto

---
## 🗂️ Estrutura da Base
A base utilizada contém tabelas relacionadas a clientes, produtos, lojas e funil de vendas:

* **sales.customers** → informações demográficas e socioeconômicas dos clientes

* **sales.products** → dados dos veículos (marca, modelo, ano, preço)

* **sales.stores** → informações das lojas

* **sales.funnel** → histórico de visitas, carrinhos e pagamentos

* **temp_tables.customers_age / ibge_genders** → enriquecimento de dados
---
## 🧩 Criação da View `sales.fato_vendas`
A view consolida as principais tabelas do banco para facilitar análises, unificando:

* Identificação do cliente, produto, loja e datas de interação

* Informações demográficas (idade, gênero, renda, status profissional)

* Cálculo de valor líquido da venda

* Campos derivados: ano e mês de pagamento

Essa estrutura foi projetada para consultas analíticas e geração de dashboards futuros.
## 🧾 Exemplos de Consultas

### 🔹 View principal
```sql
CREATE OR REPLACE VIEW sales.view_fato_vendas AS
SELECT
    fun.visit_id,
    fun.visit_page_date,
    pro.product_id,
    pro.brand,
    pro.model,
    pro.model_year::int AS ano_modelo,
    cli.customer_id,
    cli.gender,
    cli.region
FROM sales.funnel AS fun
JOIN sales.products AS pro ON fun.product_id = pro.product_id
JOIN sales.customers AS cli ON fun.customer_id = cli.customer_id;
```

### 🔹 Veículos mais visitados por marca
```sql
SELECT
    pro.brand AS marca,
    pro.model AS modelo,
    COUNT(fun.visit_page_date) AS visitas
FROM sales.products AS pro
JOIN sales.funnel AS fun ON pro.product_id = fun.product_id
GROUP BY pro.brand, pro.model
ORDER BY pro.brand, visitas DESC;
```
## 📈 Principais Insights Obtidos

* A maior concentração de visitas está em modelos das marcas `**FIAT**` e `**CHEVROLET**`.

* Veículos com **mais de 2 anos de idade** representam a maior parcela das buscas (“seminovos”).

* Há maior taxa de engajamento de clientes do gênero **feminino**, embora o **ticket médio masculino seja superior**.

* A faixa **20-40** concentra a maior parte dos leads: (10.926 leads).

* **CLT** domina em volume (65%), mas tem **renda média mais baixa**, em **Empresários e estudantes** têm menor volume, mas **renda média alta**

## 👩‍💻 Autora

Larissa Vital Caetano Pareira

📍 Projeto desenvolvido como parte de estudos em SQL e Análise de Dados.

## 📚 Documentação Complementar

- [🖼️ Prints de Resultados](docs/prints/)


### 🔗 **Conecte-se comigo no [LinkedIn](https://www.linkedin.com/in/larissavital/)!**

## 🧩 Base do Projeto

Este repositório foi construído a partir do modelo de base de dados e estrutura do curso  
**“SQL para Análise de Dados: Do básico ao avançado”** — *Midori Toyota*.  
Foram incluídas análises complementares de perfil de cliente, ticket médio e classificação de veículos.

## 🗂️ Licença
Este projeto é de uso educacional e pode ser livremente consultado e adaptado, desde que citada a fonte.