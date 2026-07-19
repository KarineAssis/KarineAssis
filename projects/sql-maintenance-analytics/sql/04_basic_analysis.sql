-- CASE 03 | ANÁLISES BÁSICAS
-- Consultas iniciais sobre o cadastro das máquinas.

-- 1. Quantidade de máquinas por setor
SELECT
    s.sector_name,
    COUNT(*) AS total_machines
FROM maintenance.machines AS m
INNER JOIN maintenance.sectors AS s
    ON m.sector_id = s.sector_id
GROUP BY
    s.sector_name
ORDER BY
    total_machines DESC;

-- 2. Quantidade de máquinas por criticidade
SELECT
    criticality,
    COUNT(*) AS total_machines
FROM maintenance.machines
GROUP BY
    criticality
ORDER BY
    criticality;

-- 3. Quantidade de máquinas por setor e criticidade
SELECT
    s.sector_name,
    m.criticality,
    COUNT(*) AS total_machines
FROM maintenance.machines AS m
INNER JOIN maintenance.sectors AS s
    ON m.sector_id = s.sector_id
GROUP BY
    s.sector_name,
    m.criticality
ORDER BY
    s.sector_name,
    m.criticality;

-- 4. Dez máquinas mais antigas
SELECT
    m.machine_id,
    m.machine_name,
    m.machine_type,
    s.sector_name,
    m.installation_date,
    m.criticality
FROM maintenance.machines AS m
INNER JOIN maintenance.sectors AS s
    ON m.sector_id = s.sector_id
ORDER BY
    m.installation_date ASC
LIMIT 10;
