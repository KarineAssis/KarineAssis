-- CASE 03 | ANÁLISE DE PARADAS
-- Consultas sobre quantidade e duração das paradas de máquinas.

-- 1. Quantidade de paradas planejadas e não planejadas
SELECT
    CASE
        WHEN planned_flag = TRUE THEN 'Planejada'
        ELSE 'Não planejada'
    END AS downtime_type,
    COUNT(*) AS total_downtimes
FROM maintenance.downtime_events
GROUP BY
    planned_flag
ORDER BY
    total_downtimes DESC;

-- 2. Horas totais de parada planejada e não planejada
SELECT
    CASE
        WHEN planned_flag = TRUE THEN 'Planejada'
        ELSE 'Não planejada'
    END AS downtime_type,
    ROUND(
        (
            SUM(
                EXTRACT(
                    EPOCH FROM (downtime_end - downtime_start)
                )
            ) / 3600
        )::NUMERIC,
        2
    ) AS total_downtime_hours
FROM maintenance.downtime_events
GROUP BY
    planned_flag
ORDER BY
    total_downtime_hours DESC;

-- 3. Horas de parada por setor
SELECT
    s.sector_name,
    ROUND(
        (
            SUM(
                EXTRACT(
                    EPOCH FROM (d.downtime_end - d.downtime_start)
                )
            ) / 3600
        )::NUMERIC,
        2
    ) AS total_downtime_hours
FROM maintenance.downtime_events AS d
INNER JOIN maintenance.machines AS m
    ON d.machine_id = m.machine_id
INNER JOIN maintenance.sectors AS s
    ON m.sector_id = s.sector_id
GROUP BY
    s.sector_name
ORDER BY
    total_downtime_hours DESC;

-- 4. Dez máquinas com mais horas de parada
SELECT
    m.machine_id,
    m.machine_name,
    m.machine_type,
    s.sector_name,
    COUNT(d.downtime_id) AS total_downtimes,
    ROUND(
        (
            SUM(
                EXTRACT(
                    EPOCH FROM (d.downtime_end - d.downtime_start)
                )
            ) / 3600
        )::NUMERIC,
        2
    ) AS total_downtime_hours
FROM maintenance.downtime_events AS d
INNER JOIN maintenance.machines AS m
    ON d.machine_id = m.machine_id
INNER JOIN maintenance.sectors AS s
    ON m.sector_id = s.sector_id
GROUP BY
    m.machine_id,
    m.machine_name,
    m.machine_type,
    s.sector_name
ORDER BY
    total_downtime_hours DESC
LIMIT 10;
