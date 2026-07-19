# Dados do Case 03

Os dados deste projeto são **sintéticos** e representam uma indústria têxtil fictícia. Eles foram gerados programaticamente para permitir a prática de SQL em um cenário relacional de manutenção industrial.

## Arquivos publicados

Os cadastros completos estão disponíveis nesta pasta:

- [`01_sectors.csv`](01_sectors.csv) — 4 setores;
- [`02_machines.csv`](02_machines.csv) — 60 máquinas.

As tabelas de maior volume são apresentadas por meio de amostras com 50 registros na pasta [`samples`](samples/):

- `03_failure_events_sample.csv`;
- `04_maintenance_orders_sample.csv`;
- `05_downtime_events_sample.csv`;
- `06_preventive_maintenance_sample.csv`;
- `07_production_daily_sample.csv`.

## Volumes utilizados na análise

| Conjunto | Registros utilizados |
|---|---:|
| Setores | 4 |
| Máquinas | 60 |
| Eventos de falha | 720 |
| Ordens de manutenção | 1.500 |
| Eventos de parada | 600 |
| Manutenções preventivas | 1.400 |
| Produção diária | 43.860 |

As amostras permitem compreender a estrutura das tabelas sem tornar o repositório excessivamente pesado. Os resultados documentados no case foram calculados sobre a base completa importada no PostgreSQL.

## Observações

- Os dados não representam nenhuma empresa real.
- Datas e horários seguem formato ISO.
- Campos vazios nos CSVs representam valores nulos.
- Os arquivos completos permanecem preservados no pacote original do projeto.
