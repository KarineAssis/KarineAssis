-- CASE 03 | ETAPA 2
-- Banco: textile_maintenance
-- Criação do schema e das sete tabelas do projeto.

CREATE SCHEMA IF NOT EXISTS maintenance;

DROP TABLE IF EXISTS maintenance.production_daily CASCADE;
DROP TABLE IF EXISTS maintenance.preventive_maintenance CASCADE;
DROP TABLE IF EXISTS maintenance.downtime_events CASCADE;
DROP TABLE IF EXISTS maintenance.maintenance_orders CASCADE;
DROP TABLE IF EXISTS maintenance.failure_events CASCADE;
DROP TABLE IF EXISTS maintenance.machines CASCADE;
DROP TABLE IF EXISTS maintenance.sectors CASCADE;

CREATE TABLE maintenance.sectors (
    sector_id SMALLINT PRIMARY KEY,
    sector_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE maintenance.machines (
    machine_id VARCHAR(10) PRIMARY KEY,
    sector_id SMALLINT NOT NULL,
    machine_name VARCHAR(100) NOT NULL,
    machine_type VARCHAR(80) NOT NULL,
    installation_date DATE NOT NULL,
    criticality CHAR(1) NOT NULL,
    machine_status VARCHAR(20) NOT NULL,

    CONSTRAINT fk_machines_sector
        FOREIGN KEY (sector_id)
        REFERENCES maintenance.sectors (sector_id),

    CONSTRAINT chk_machines_criticality
        CHECK (criticality IN ('A', 'B', 'C')),

    CONSTRAINT chk_machines_status
        CHECK (machine_status IN ('Ativa', 'Inativa'))
);

CREATE TABLE maintenance.failure_events (
    failure_id BIGINT PRIMARY KEY,
    machine_id VARCHAR(10) NOT NULL,
    failure_datetime TIMESTAMP NOT NULL,
    failure_category VARCHAR(40) NOT NULL,
    component VARCHAR(100) NOT NULL,
    severity SMALLINT NOT NULL,
    failure_description VARCHAR(250) NOT NULL,

    CONSTRAINT fk_failures_machine
        FOREIGN KEY (machine_id)
        REFERENCES maintenance.machines (machine_id),

    CONSTRAINT chk_failure_severity
        CHECK (severity BETWEEN 1 AND 5)
);

CREATE TABLE maintenance.maintenance_orders (
    order_id BIGINT PRIMARY KEY,
    machine_id VARCHAR(10) NOT NULL,
    failure_id BIGINT,
    maintenance_type VARCHAR(20) NOT NULL,
    priority VARCHAR(20) NOT NULL,
    opened_at TIMESTAMP NOT NULL,
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    order_status VARCHAR(20) NOT NULL,
    labor_cost NUMERIC(12,2) NOT NULL DEFAULT 0,
    parts_cost NUMERIC(12,2) NOT NULL DEFAULT 0,

    CONSTRAINT fk_orders_machine
        FOREIGN KEY (machine_id)
        REFERENCES maintenance.machines (machine_id),

    CONSTRAINT fk_orders_failure
        FOREIGN KEY (failure_id)
        REFERENCES maintenance.failure_events (failure_id),

    CONSTRAINT chk_orders_type
        CHECK (maintenance_type IN ('Preventiva', 'Corretiva', 'Preditiva')),

    CONSTRAINT chk_orders_priority
        CHECK (priority IN ('Baixa', 'Média', 'Alta', 'Emergencial')),

    CONSTRAINT chk_orders_status
        CHECK (order_status IN ('Aberta', 'Em andamento', 'Concluída')),

    CONSTRAINT chk_orders_costs
        CHECK (labor_cost >= 0 AND parts_cost >= 0),

    CONSTRAINT chk_orders_dates
        CHECK (
            (started_at IS NULL OR started_at >= opened_at)
            AND
            (completed_at IS NULL OR (started_at IS NOT NULL AND completed_at >= started_at))
        )
);

CREATE TABLE maintenance.downtime_events (
    downtime_id BIGINT PRIMARY KEY,
    machine_id VARCHAR(10) NOT NULL,
    failure_id BIGINT,
    downtime_start TIMESTAMP NOT NULL,
    downtime_end TIMESTAMP NOT NULL,
    planned_flag BOOLEAN NOT NULL,
    downtime_reason VARCHAR(250) NOT NULL,

    CONSTRAINT fk_downtime_machine
        FOREIGN KEY (machine_id)
        REFERENCES maintenance.machines (machine_id),

    CONSTRAINT fk_downtime_failure
        FOREIGN KEY (failure_id)
        REFERENCES maintenance.failure_events (failure_id),

    CONSTRAINT chk_downtime_dates
        CHECK (downtime_end > downtime_start)
);

CREATE TABLE maintenance.preventive_maintenance (
    preventive_id BIGINT PRIMARY KEY,
    machine_id VARCHAR(10) NOT NULL,
    activity_name VARCHAR(180) NOT NULL,
    planned_date DATE NOT NULL,
    execution_date DATE,
    preventive_status VARCHAR(20) NOT NULL,

    CONSTRAINT fk_preventive_machine
        FOREIGN KEY (machine_id)
        REFERENCES maintenance.machines (machine_id),

    CONSTRAINT chk_preventive_status
        CHECK (preventive_status IN ('No prazo', 'Atrasada', 'Pendente', 'Cancelada')),

    CONSTRAINT chk_preventive_dates
        CHECK (
            execution_date IS NULL
            OR execution_date >= DATE '2024-01-01'
        )
);

CREATE TABLE maintenance.production_daily (
    production_date DATE NOT NULL,
    machine_id VARCHAR(10) NOT NULL,
    scheduled_hours NUMERIC(5,2) NOT NULL,
    operating_hours NUMERIC(5,2) NOT NULL,
    production_qty NUMERIC(14,2) NOT NULL,
    scrap_qty NUMERIC(14,2) NOT NULL,

    CONSTRAINT pk_production_daily
        PRIMARY KEY (production_date, machine_id),

    CONSTRAINT fk_production_machine
        FOREIGN KEY (machine_id)
        REFERENCES maintenance.machines (machine_id),

    CONSTRAINT chk_production_hours
        CHECK (
            scheduled_hours BETWEEN 0 AND 24
            AND operating_hours BETWEEN 0 AND scheduled_hours
        ),

    CONSTRAINT chk_production_values
        CHECK (production_qty >= 0 AND scrap_qty >= 0)
);

CREATE INDEX idx_failures_machine_datetime
    ON maintenance.failure_events (machine_id, failure_datetime);

CREATE INDEX idx_orders_machine_opened
    ON maintenance.maintenance_orders (machine_id, opened_at);

CREATE INDEX idx_downtime_machine_start
    ON maintenance.downtime_events (machine_id, downtime_start);

CREATE INDEX idx_preventive_machine_date
    ON maintenance.preventive_maintenance (machine_id, planned_date);

CREATE INDEX idx_production_machine_date
    ON maintenance.production_daily (machine_id, production_date);
