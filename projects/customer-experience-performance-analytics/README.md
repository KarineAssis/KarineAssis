# Logistics Customer Experience Analytics

**Case 02 — Análise de desempenho logístico e experiência do cliente**

<div align="center">
  <img src="../../assets/customer-experience-performance-preview.svg" alt="Logistics Customer Experience Analytics" width="100%">
</div>

> Projeto em desenvolvimento. Todos os dados são sintéticos e foram criados para fins educacionais e de portfólio.

## Contexto do problema

Uma empresa de logística está enfrentando atrasos nas entregas e aumento nas reclamações dos clientes.

Os dados existem em fontes diferentes, dificultando uma visão clara sobre:

- onde os atrasos estão concentrados;
- quais motivos aparecem com maior frequência;
- como o desempenho da entrega afeta a satisfação;
- quais pontos devem ser priorizados pela gestão.

## Pergunta de negócio

> Onde estão concentrados os atrasos e como o desempenho das entregas afeta a experiência do cliente?

## Objetivo do projeto

Construir uma análise em Power BI capaz de:

1. acompanhar o desempenho das entregas;
2. relacionar atrasos com satisfação e motivos de contato;
3. transformar os resultados em três insights e recomendações objetivas.

## Escopo da base sintética

O modelo contém:

- **53.770 entregas**;
- **16.318 interações de clientes**;
- datas de pedido, previsão e entrega;
- status da entrega e dias de atraso;
- canal e motivo do contato;
- indicador de satisfação;
- informações de cidade, equipe e período.

A base foi gerada programaticamente para criar um cenário plausível de análise, sem representar uma empresa real.

## Indicadores principais

| Indicador | Resultado preliminar |
|---|---:|
| Entregas analisadas | 53.770 |
| Cumprimento do prazo | 87,02% |
| Taxa de atraso | 12,98% |
| Satisfação do cliente | 64,02% |

## Ferramentas e abordagem

- **Excel:** auditoria inicial dos dados;
- **Power Query:** limpeza, padronização e transformação;
- **Modelo dimensional:** relacionamento entre entregas, interações, calendário, motivos e canais;
- **DAX:** criação dos indicadores;
- **Power BI:** dashboard e comunicação dos resultados;
- **SQL e Python:** análises complementares planejadas.

## Estrutura do modelo

O projeto utiliza duas tabelas principais:

- `Fato_Entregas`: informações sobre prazo, status e atraso;
- `Fato_Interacoes`: registros de contato e satisfação do cliente.

As dimensões organizam período, motivo, canal, cidade e equipe, permitindo filtrar e comparar os resultados.

## Escopo do dashboard

A apresentação será curta e focada em três análises:

1. evolução do desempenho das entregas;
2. principais motivos de contato dos clientes;
3. relação entre atraso e satisfação.

O objetivo é demonstrar conhecimento técnico sem tornar o case excessivamente longo ou especializado.

## Entregáveis

- problema de negócio;
- base sintética e dicionário de dados;
- tratamento no Power Query;
- modelo de dados;
- medidas DAX;
- dashboard em Power BI;
- três insights principais;
- recomendações de negócio;
- consultas SQL e análise simples em Python;
- premissas e limitações.

## Próximas etapas

- concluir a página executiva do dashboard;
- validar os indicadores finais;
- selecionar três insights principais;
- elaborar recomendações objetivas;
- adicionar SQL e Python ao repositório;
- publicar as imagens finais do dashboard.

## Documentação complementar

- [Problema de negócio e metodologia](docs/business-problem-and-methodology.md)
- [Modelo e indicadores](docs/model-metrics-and-rules.md)

## Premissas e limitações

- os dados são totalmente sintéticos;
- os resultados não representam uma empresa real;
- a satisfação é baseada apenas nas respostas disponíveis;
- associações entre atraso e satisfação não comprovam causalidade;
- o projeto demonstra método analítico, modelagem e visualização de dados.
