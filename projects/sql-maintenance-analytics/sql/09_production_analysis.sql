-- CASE 03 | ANÁLISE DE PRODUÇÃO
-- Consultas sobre produção, horas operacionais e refugo.

-- 1. Produção total por setor
SELECT
    s.sector_name,
    ROUND(SUM(p.production_qty), 2) AS total_production
FROM maintenance.production_daily AS p
INNER JOIN maintenance.machines AS m
    ON p.machine_id = m.machine_id
INNER JOIN maintenance.sectors AS s
    ON m.sector_id = s.sector_id
GROUP BY
    s.sector_name
ORDER BY
    total_production DESC;

-- 2. Produção e refugo por setor
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

-- 3. Percentual de refugo por setor
SELECT
    s.sector_name,
    ROUND(SUM(p.production_qty), 2) AS total_production,
    ROUND(SUM(p.scrap_qty), 2) AS total_scrap,
    ROUND(
        SUM(p.scrap_qty) * 100.0
        / NULLIF(SUM(p.production_qty), 0),
        2
    ) AS scrap_percentage
FROM maintenance.production_daily AS p
INNER JOIN maintenance.machines AS m
    ON p.machine_id = m.machine_id
INNER JOIN maintenance.sectors AS s
    ON m.sector_id = s.sector_id
GROUP BY
    s.sector_name
ORDER BY
    scrap_percentage DESC;

-- 4. Média diária de horas operacionais por setor
SELECT
    s.sector_name,
    ROUND(
        AVG(p.operating_hours),
        2
    ) AS average_operating_hours
FROM maintenance.production_daily AS p
INNER JOIN maintenance.machines AS m
    ON p.machine_id = m.machine_id
INNER JOIN maintenance.sectors AS s
    ON m.sector_id = s.sector_id
GROUP BY
    s.sector_name
ORDER BY
    average_operating_hours DESC;

-- 5. Dez máquinas com maior produção acumulada
SELECT
    m.machine_id,
    m.machine_name,
    m.machine_type,
    s.sector_name,
    ROUND(
        SUM(p.production_qty),
        2
    ) AS total_production
FROM maintenance.production_daily AS p
INNER JOIN maintenance.machines AS m
    ON p.machine_id = m.machine_id
INNER JOIN maintenance.sectors AS s
    ON m.sector_id = s.sector_id
GROUP BY
    m.machine_id,
    m.machine_name,
    m.machine_type,
    s.sector_name
ORDER BY
    total_production DESC
LIMIT 10;
