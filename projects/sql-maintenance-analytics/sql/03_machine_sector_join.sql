-- CASE 03 | MÁQUINAS E SETORES
-- Relaciona o cadastro de máquinas ao nome do setor.

SELECT
    m.machine_id,
    m.machine_name,
    m.machine_type,
    s.sector_name,
    m.criticality
FROM maintenance.machines AS m
INNER JOIN maintenance.sectors AS s
    ON m.sector_id = s.sector_id
ORDER BY
    s.sector_name,
    m.machine_id;
