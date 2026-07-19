-- CASE 03 | VALIDAÇÃO DA CARGA
-- Confere a quantidade de registros importados em cada tabela.

SELECT
    'sectors' AS table_name,
    COUNT(*) AS total_rows
FROM maintenance.sectors

UNION ALL

SELECT
    'machines',
    COUNT(*)
FROM maintenance.machines

UNION ALL

SELECT
    'failure_events',
    COUNT(*)
FROM maintenance.failure_events

UNION ALL

SELECT
    'maintenance_orders',
    COUNT(*)
FROM maintenance.maintenance_orders

UNION ALL

SELECT
    'downtime_events',
    COUNT(*)
FROM maintenance.downtime_events

UNION ALL

SELECT
    'preventive_maintenance',
    COUNT(*)
FROM maintenance.preventive_maintenance

UNION ALL

SELECT
    'production_daily',
    COUNT(*)
FROM maintenance.production_daily

ORDER BY table_name;
