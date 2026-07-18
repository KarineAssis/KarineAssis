# Customer Experience Performance Analytics

**Case 02 — Análise integrada de experiência do cliente, eficiência operacional e desempenho de atendimento**

<div align="center">
  <img src="../../assets/customer-experience-performance-preview.svg" alt="Customer Experience Performance Analytics" width="100%">
</div>

> Projeto em desenvolvimento. Os dados são totalmente sintéticos e foram criados para fins educacionais e de portfólio, sem uso de informações confidenciais.

## Contexto do problema

Uma operação de delivery pode apresentar bom desempenho agregado e, ainda assim, esconder diferenças relevantes entre motivos de contato, canais, equipes, agentes e situações de entrega.

A liderança acompanha indicadores como CSAT, DSAT, AHT e FCR, mas precisa entender **o que está por trás dos resultados**:

- quais fatores estão mais associados à insatisfação;
- como atrasos na entrega afetam a experiência;
- quais motivos combinam alto volume e baixa resolução;
- onde estão concentrados os recontatos e escalonamentos;
- quais equipes e agentes precisam de atenção prioritária.

## Pergunta de negócio

> Como combinar dados operacionais e dados de atendimento para identificar os principais drivers da insatisfação e melhorar simultaneamente experiência, eficiência e resolução?

## Objetivo do projeto

Construir uma análise de ponta a ponta capaz de:

1. consolidar indicadores de experiência e eficiência;
2. conectar desempenho da entrega à percepção do cliente;
3. identificar drivers de CSAT e DSAT;
4. comparar motivos, canais, equipes e agentes;
5. segmentar performance por quartis;
6. transformar os achados em recomendações de negócio.

## Escopo da base sintética

O modelo atual contém:

- **16.318 interações de atendimento**;
- **10.574 jornadas**;
- linhas de negócio Customer, Rider e Merchant;
- canais Chat, Voz e E-mail;
- motivos de contato, equipes e agentes fictícios;
- campos de AHT, FCR, recontato, escalonamento, QA, CSAT e DSAT;
- vínculo com informações operacionais de entrega.

A base foi gerada programaticamente por regras probabilísticas. Atraso, baixa resolução, recontato, escalonamento e maior complexidade tendem a reduzir a satisfação, mas sem produzir resultados totalmente determinísticos.

## Indicadores preliminares

| Indicador | Resultado atual |
|---|---:|
| Total de interações | 16.318 |
| Total de jornadas | 10.574 |
| CSAT | 64,02% |
| DSAT | 9,90% |
| FCR | 57,76% |
| AHT médio | 12,09 min |
| Taxa de recontato | 42,24% |
| Taxa de escalonamento | 22,44% |
| QA médio | 83,95 |

Os resultados acima são preliminares e serão consolidados após a etapa final de validação e análise.

## Abordagem analítica

**Problema de negócio → base sintética → auditoria → Power Query → modelo dimensional → medidas DAX → dashboard → drivers de experiência → quartis → insights → recomendações**

## Arquitetura do modelo

O projeto utiliza duas tabelas fato:

- `Fato_Entregas`: desempenho operacional da entrega;
- `Fato_Interacoes`: contatos de atendimento e indicadores de experiência.

Dimensões principais:

- `Dim_Calendario`;
- `Dim_Agentes`;
- `Dim_Motivos`;
- `Dim_LOB`;
- `Dim_Canal_Atendimento`;
- `Dim_Equipe_Atendimento`.

Essa estrutura permite analisar experiência e eficiência por período, motivo, canal, equipe, agente e situação operacional.

## Tratamento e transformação no Power Query

As etapas incluem:

- definição correta dos tipos de dados;
- validação de chaves e identificadores;
- padronização de categorias;
- tratamento de campos de pesquisa não respondida;
- criação de atributos temporais;
- preparação das tabelas fato e dimensão;
- validação entre dados operacionais e dados de experiência.

## Principais medidas DAX

O modelo já contém medidas para:

- Total de Interações;
- Total de Jornadas;
- Pesquisas Respondidas;
- Taxa de Resposta;
- CSAT;
- DSAT;
- AHT Médio;
- FCR;
- Taxa de Recontato;
- Taxa de Escalonamento;
- QA Médio;
- Gap de CSAT por atraso;
- Score de Performance;
- Ranking de Performance;
- Quartil e Segmento de Performance;
- Participação no DSAT.

## Escopo do dashboard

A apresentação será intencionalmente enxuta.

### Indicadores principais

`CSAT` · `DSAT` · `FCR` · `AHT` · `Recontato`

### Análises principais

1. evolução dos indicadores;
2. principais drivers de DSAT;
3. impacto do atraso na satisfação;
4. segmentação de performance por quartil.

A profundidade técnica ficará documentada no repositório, evitando uma apresentação longa ou cansativa.

## Ranking e segmentação por quartil

O score de performance considera:

- 35% CSAT;
- 30% FCR;
- 20% QA;
- 15% redução de recontatos.

O AHT é mantido como indicador de diagnóstico, mas não entra diretamente no score para evitar premiar atendimentos curtos sem considerar qualidade ou resolução.

Agentes só entram no ranking quando atendem a critérios mínimos de volume e pesquisas respondidas. A classificação será apresentada como:

- `Q1` — referência de performance;
- `Q2` — performance consistente;
- `Q3` — atenção e acompanhamento;
- `Q4` — prioridade de desenvolvimento.

## Entregáveis do repositório

- problema de negócio;
- base sintética;
- dicionário de dados;
- limpeza e transformação no Power Query;
- modelo de dados;
- medidas DAX;
- dashboard em Power BI;
- análise de CSAT, DSAT, AHT e FCR;
- ranking e segmentação por quartil;
- cinco insights principais;
- recomendações de negócio;
- consultas SQL;
- análise exploratória simples em Python;
- premissas e limitações.

## Próximas etapas

- concluir a página executiva de Customer Experience;
- analisar drivers por motivo, canal e LOB;
- validar o impacto do atraso sobre CSAT e DSAT;
- consolidar cinco insights principais;
- produzir recomendações de negócio;
- adicionar consultas SQL;
- adicionar análise exploratória em Python;
- publicar capturas finais do dashboard.

## Documentação complementar

- [Problema de negócio e metodologia](docs/business-problem-and-methodology.md)
- [Modelo, métricas e regras analíticas](docs/model-metrics-and-rules.md)

## Premissas e limitações

- todos os dados são sintéticos;
- nomes, agentes, equipes e resultados não representam uma empresa real;
- correlações foram introduzidas por regras probabilísticas;
- pesquisa não respondida pode gerar viés de resposta;
- correlação não significa causalidade;
- agentes com baixo volume não devem ser comparados diretamente;
- o case demonstra método analítico e não desempenho real de uma organização.
