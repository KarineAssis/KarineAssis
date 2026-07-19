-- CASE 03 | ANÁLISE DE FALHAS
-- Consultas sobre quantidade, categoria e severidade das falhas.

-- 1. Quantidade de falhas por setor
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

-- 2. Quantidade de falhas por categoria
SELECT
    failure_category,
    COUNT(*) AS total_failures
FROM maintenance.failure_events
GROUP BY
    failure_category
ORDER BY
    total_failures DESC;

-- 3. Dez máquinas com mais falhas
SELECT
    m.machine_id,
    m.machine_name,
    m.machine_type,
    s.sector_name,
    m.criticality,
    COUNT(f.failure_id) AS total_failures
FROM maintenance.machines AS m
INNER JOIN maintenance.sectors AS s
    ON m.sector_id = s.sector_id
LEFT JOIN maintenance.failure_events AS f
    ON m.machine_id = f.machine_id
GROUP BY
    m.machine_id,
    m.machine_name,
    m.machine_type,
    s.sector_name,
    m.criticality
ORDER BY
    total_failures DESC
LIMIT 10;

-- 4. Severidade média das falhas por setor
SELECT
    s.sector_name,
    COUNT(f.failure_id) AS total_failures,
    ROUND(AVG(f.severity), 2) AS average_severity
FROM maintenance.failure_events AS f
INNER JOIN maintenance.machines AS m
    ON f.machine_id = m.machine_id
INNER JOIN maintenance.sectors AS s
    ON m.sector_id = s.sector_id
GROUP BY
    s.sector_name
ORDER BY
    average_severity DESC;
