-- CASE 03 | ANÁLISE DAS ORDENS DE MANUTENÇÃO
-- Consultas sobre tipos, status e custos das ordens.

-- 1. Quantidade de ordens por tipo de manutenção
SELECT
    maintenance_type,
    COUNT(*) AS total_orders
FROM maintenance.maintenance_orders
GROUP BY
    maintenance_type
ORDER BY
    total_orders DESC;

-- 2. Quantidade de ordens por status
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM maintenance.maintenance_orders
GROUP BY
    order_status
ORDER BY
    total_orders DESC;

-- 3. Custo total por tipo de manutenção
SELECT
    maintenance_type,
    COUNT(*) AS total_orders,
    ROUND(SUM(labor_cost), 2) AS total_labor_cost,
    ROUND(SUM(parts_cost), 2) AS total_parts_cost,
    ROUND(SUM(labor_cost + parts_cost), 2) AS total_maintenance_cost
FROM maintenance.maintenance_orders
GROUP BY
    maintenance_type
ORDER BY
    total_maintenance_cost DESC;

-- 4. Dez máquinas com maior custo de manutenção
SELECT
    m.machine_id,
    m.machine_name,
    m.machine_type,
    s.sector_name,
    COUNT(mo.order_id) AS total_orders,
    ROUND(SUM(mo.labor_cost + mo.parts_cost), 2) AS total_maintenance_cost
FROM maintenance.maintenance_orders AS mo
INNER JOIN maintenance.machines AS m
    ON mo.machine_id = m.machine_id
INNER JOIN maintenance.sectors AS s
    ON m.sector_id = s.sector_id
GROUP BY
    m.machine_id,
    m.machine_name,
    m.machine_type,
    s.sector_name
ORDER BY
    total_maintenance_cost DESC
LIMIT 10;
