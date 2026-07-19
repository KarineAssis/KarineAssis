-- CASE 03 | RESUMO DOS PRINCIPAIS RESULTADOS
-- Consultas selecionadas para a apresentação final do projeto.


-- 1. Falhas por setor

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


-- 2. Categorias de falha mais frequentes

SELECT
    failure_category,
    COUNT(*) AS total_failures
FROM maintenance.failure_events
GROUP BY
    failure_category
ORDER BY
    total_failures DESC;


-- 3. Cinco máquinas com maior número de falhas

SELECT
    m.machine_id,
    m.machine_name,
    m.machine_type,
    s.sector_name,
    COUNT(f.failure_id) AS total_failures
FROM maintenance.failure_events AS f
INNER JOIN maintenance.machines AS m
    ON f.machine_id = m.machine_id
INNER JOIN maintenance.sectors AS s
    ON m.sector_id = s.sector_id
GROUP BY
    m.machine_id,
    m.machine_name,
    m.machine_type,
    s.sector_name
ORDER BY
    total_failures DESC
LIMIT 5;


-- 4. Custos por tipo de manutenção

SELECT
    maintenance_type,
    COUNT(*) AS total_orders,
    ROUND(
        SUM(labor_cost + parts_cost),
        2
    ) AS total_maintenance_cost
FROM maintenance.maintenance_orders
GROUP BY
    maintenance_type
ORDER BY
    total_maintenance_cost DESC;


-- 5. Situação das manutenções preventivas

SELECT
    preventive_status,
    COUNT(*) AS total_preventives
FROM maintenance.preventive_maintenance
GROUP BY
    preventive_status
ORDER BY
    total_preventives DESC;


-- 6. Produção e refugo por setor

SELECT
    s.sector_name,
    ROUND(SUM(p.production_qty), 2) AS total_production,
    ROUND(SUM(p.scrap_qty), 2) AS total_scrap
FROM maintenance.production_daily AS p
INNER JOIN maintenance.machines AS m
    ON p.machine_id = m.machine_id
INNER JOIN maintenance.sectors AS s
    ON m.sector_id = s.sector_id
GROUP BY
    s.sector_name
ORDER BY
    total_production DESC;
