-- CASE 03 | ANÁLISE DE MANUTENÇÕES PREVENTIVAS
-- Consultas sobre execução, atraso e pendências das preventivas.

-- 1. Quantidade de preventivas por status
SELECT
    preventive_status,
    COUNT(*) AS total_preventives
FROM maintenance.preventive_maintenance
GROUP BY
    preventive_status
ORDER BY
    total_preventives DESC;

-- 2. Percentual de preventivas por status
SELECT
    preventive_status,
    COUNT(*) AS total_preventives,
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM maintenance.preventive_maintenance
GROUP BY
    preventive_status
ORDER BY
    percentage DESC;

-- 3. Média de dias de atraso das preventivas atrasadas
SELECT
    COUNT(*) AS delayed_preventives,
    ROUND(
        AVG(execution_date - planned_date),
        2
    ) AS average_delay_days
FROM maintenance.preventive_maintenance
WHERE
    preventive_status = 'Atrasada'
    AND execution_date IS NOT NULL;

-- 4. Preventivas pendentes ou canceladas por setor
SELECT
    s.sector_name,
    pm.preventive_status,
    COUNT(*) AS total_preventives
FROM maintenance.preventive_maintenance AS pm
INNER JOIN maintenance.machines AS m
    ON pm.machine_id = m.machine_id
INNER JOIN maintenance.sectors AS s
    ON m.sector_id = s.sector_id
WHERE
    pm.preventive_status IN ('Pendente', 'Cancelada')
GROUP BY
    s.sector_name,
    pm.preventive_status
ORDER BY
    s.sector_name,
    pm.preventive_status;

-- 5. Dez máquinas com mais preventivas atrasadas
SELECT
    m.machine_id,
    m.machine_name,
    m.machine_type,
    s.sector_name,
    COUNT(pm.preventive_id) AS delayed_preventives
FROM maintenance.preventive_maintenance AS pm
INNER JOIN maintenance.machines AS m
    ON pm.machine_id = m.machine_id
INNER JOIN maintenance.sectors AS s
    ON m.sector_id = s.sector_id
WHERE
    pm.preventive_status = 'Atrasada'
GROUP BY
    m.machine_id,
    m.machine_name,
    m.machine_type,
    s.sector_name
ORDER BY
    delayed_preventives DESC,
    m.machine_id
LIMIT 10;
