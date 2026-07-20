# SQL Maintenance Analytics

**Case 03 — SQL aplicado à análise de manutenção industrial**

<div align="center">
  <img src="../../assets/sql-maintenance-analytics-preview.svg" alt="SQL Maintenance Analytics" width="100%">
</div>

## O problema

Uma indústria têxtil fictícia precisava organizar seus dados de manutenção e identificar onde estavam concentradas as principais falhas, os maiores custos e as oportunidades de melhoria no plano preventivo.

A análise reuniu informações de quatro setores produtivos — **Fiação, Tecelagem, Tingimento e Acabamento** — em um banco de dados relacional no PostgreSQL.

> **Pergunta central:** Como os dados de máquinas, falhas, ordens de manutenção, paradas, preventivas e produção podem apoiar a priorização das ações de manutenção?

## Escopo dos dados

A base representa dois anos de operação, entre janeiro de 2024 e dezembro de 2025.

- **4** setores produtivos;
- **60** máquinas cadastradas;
- **720** eventos de falha;
- **1.500** ordens de manutenção;
- **600** eventos de parada;
- **1.400** registros de manutenção preventiva;
- **43.860** registros de produção diária;
- **48.144 registros no total**.

Os dados são **sintéticos** e não representam uma empresa real. A base foi gerada programaticamente para fins educacionais, respeitando relações coerentes entre máquinas, falhas, ordens, paradas, preventivas e produção.

## Estrutura do banco

O banco `textile_maintenance` foi criado no PostgreSQL e organizado no esquema `maintenance`.

- `sectors` — cadastro dos setores produtivos;
- `machines` — cadastro das máquinas;
- `failure_events` — histórico de falhas;
- `maintenance_orders` — ordens preventivas, corretivas e preditivas;
- `downtime_events` — paradas planejadas e não planejadas;
- `preventive_maintenance` — planejamento e execução das preventivas;
- `production_daily` — produção, horas operacionais e refugo.

### Relacionamentos entre as tabelas

```text
sectors (1) ────< machines
machines (1) ────< failure_events
machines (1) ────< maintenance_orders
machines (1) ────< downtime_events
machines (1) ────< preventive_maintenance
machines (1) ────< production_daily
failure_events (1) ────< maintenance_orders
failure_events (1) ────< downtime_events
```

## Construção técnica

O projeto foi desenvolvido em cinco etapas:

1. organização dos arquivos CSV;
2. criação do banco e das tabelas no PostgreSQL;
3. importação dos dados por meio do pgAdmin;
4. validação das quantidades e dos relacionamentos;
5. desenvolvimento das consultas de análise.

Os principais recursos utilizados foram:

```sql
SELECT
FROM
WHERE
ORDER BY
LIMIT
COUNT
SUM
AVG
ROUND
GROUP BY
INNER JOIN
LEFT JOIN
CASE
NULLIF
```

### Exemplo de consulta

```sql
SELECT
    s.sector_name,
    COUNT(f.failure_id) AS total_failures
FROM maintenance.failure_events AS f
INNER JOIN maintenance.machines AS m
    ON f.machine_id = m.machine_id
INNER JOIN maintenance.sectors AS s
    ON m.sector_id = s.sector_id
GROUP BY
    s.sector_name
ORDER BY
    total_failures DESC;
```

## Principais resultados

Os resultados abaixo foram obtidos a partir das consultas executadas no PostgreSQL por meio do pgAdmin. Os scripts SQL originais permanecem disponíveis na pasta [`sql`](sql/).

### Falhas por setor

<div align="center">
  <img src="assets/pgadmin-failures-by-sector-full.jpg" alt="Resultado completo da consulta de falhas por setor no pgAdmin" width="504">
</div>

A **Tecelagem** apresentou o maior volume absoluto de falhas. O resultado deve ser interpretado em conjunto com a quantidade de máquinas, pois esse também é o setor com mais equipamentos na base.

### Categorias de falha mais frequentes

<div align="center">
  <img src="assets/pgadmin-failure-categories-real.svg" alt="Resultado da consulta de categorias de falha no pgAdmin" width="282">
</div>

As falhas mecânicas e elétricas concentraram a maior parte das ocorrências.

### Máquinas com mais falhas

<div align="center">
  <img src="assets/pgadmin-top-machines-real.svg" alt="Resultado da consulta de máquinas com mais falhas no pgAdmin" width="846">
</div>

A `TEC-020` destacou-se como candidata prioritária para a investigação de causas recorrentes e a revisão do plano preventivo.

### Custos por tipo de manutenção

<div align="center">
  <img src="assets/pgadmin-maintenance-costs-real.svg" alt="Resultado da consulta de custos por tipo de manutenção no pgAdmin" width="484">
</div>

A manutenção corretiva apresentou o maior volume de ordens e o maior custo acumulado.

### Situação das preventivas

<div align="center">
  <img src="assets/pgadmin-preventive-status-real.svg" alt="Resultado da consulta de situação das preventivas no pgAdmin" width="395">
</div>

A maior parte das atividades foi executada no prazo. Entretanto, 263 preventivas estavam atrasadas, pendentes ou canceladas.

### Produção e refugo

<div align="center">
  <img src="assets/pgadmin-production-scrap-real.svg" alt="Resultado da consulta de produção e refugo no pgAdmin" width="436">
</div>

A Tecelagem apresentou a maior produção acumulada e também o maior volume absoluto de refugo. Para uma avaliação mais precisa, o refugo deve ser analisado proporcionalmente ao volume produzido por setor.

## Recomendações

- Priorizar a investigação da Urdideira `TEC-020` e das demais máquinas com alta recorrência de falhas.
- Aprofundar a análise das causas das falhas mecânicas e elétricas.
- Acompanhar o custo das ordens corretivas e os equipamentos que mais contribuem para esse valor.
- Atuar sobre as preventivas atrasadas e pendentes.
- Avaliar o refugo proporcionalmente ao volume produzido por setor.

## Arquivos do projeto

### Scripts SQL

1. [`01_create_tables.sql`](sql/01_create_tables.sql) — criação do esquema, das tabelas, das restrições e dos índices;
2. [`02_validate_data.sql`](sql/02_validate_data.sql) — validação das quantidades importadas;
3. [`03_machine_sector_join.sql`](sql/03_machine_sector_join.sql) — relacionamento entre máquinas e setores;
4. [`04_basic_analysis.sql`](sql/04_basic_analysis.sql) — análises iniciais do cadastro de máquinas;
5. [`05_failure_analysis.sql`](sql/05_failure_analysis.sql) — análise de falhas e severidade;
6. [`06_maintenance_orders_analysis.sql`](sql/06_maintenance_orders_analysis.sql) — ordens e custos de manutenção;
7. [`07_downtime_analysis.sql`](sql/07_downtime_analysis.sql) — paradas e horas de indisponibilidade;
8. [`08_preventive_maintenance_analysis.sql`](sql/08_preventive_maintenance_analysis.sql) — execução e pendências das preventivas;
9. [`09_production_analysis.sql`](sql/09_production_analysis.sql) — produção, horas operacionais e refugo;
10. [`10_project_summary.sql`](sql/10_project_summary.sql) — consultas utilizadas para consolidar os principais resultados.

### Dados

- [`data/README.md`](data/README.md) — documentação da base e dos volumes utilizados;
- [`01_sectors.csv`](data/01_sectors.csv) — cadastro completo dos setores;
- [`02_machines.csv`](data/02_machines.csv) — cadastro completo das máquinas;
- [`data/samples`](data/samples/) — amostras das tabelas de maior volume.

Os resultados apresentados foram calculados sobre a base completa importada no PostgreSQL. As amostras publicadas permitem visualizar a estrutura dos dados sem tornar o repositório excessivamente pesado.

## Limitações e próximos passos

Nesta versão, o projeto não calcula indicadores como MTTR, MTBF e disponibilidade. Essas métricas poderão ser incorporadas em uma evolução futura, junto com análises mensais, um dashboard em Power BI e dados de sensores para manutenção preditiva.

## Tecnologias

`SQL` · `PostgreSQL` · `pgAdmin` · `CSV`
