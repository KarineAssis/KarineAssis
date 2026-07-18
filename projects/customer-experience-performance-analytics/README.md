# Logistics Customer Experience Analytics

**Case 02 — Análise de desempenho logístico e experiência do cliente**

<div align="center">
  <img src="../../assets/customer-experience-performance-preview.svg" alt="Logistics Customer Experience Analytics" width="100%">
</div>

> Projeto em desenvolvimento. Todos os dados são sintéticos e foram criados para fins educacionais.

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

## Como construí a solução

Depois de definir o problema, comecei mapeando as fontes disponíveis. A base logística estava em Excel e reunia pedidos, datas, equipes, canais e status de entrega. Os registros de contato e as dimensões auxiliares estavam em arquivos CSV.

```text
Fontes de dados
      ↓
Tratamento no Power Query
      ↓
Modelo dimensional
      ↓
Medidas DAX
      ↓
Dashboard em Power BI
```

### Tratamento no Power Query

Na base de entregas, corrigi os tipos e a localidade das datas, criei uma chave técnica e calculei o lead time e o desvio entre a data prevista e a data realizada.

A partir desse desvio, criei um status validado:

```powerquery
Status_Validado =
if [Desvio_Prazo_Dias] < 0 then "Antecipado"
else if [Desvio_Prazo_Dias] = 0 then "No Prazo"
else "Atrasado"
```

Também comparei o status original com o status recalculado para identificar possíveis inconsistências. Na base de interações, padronizei os campos de data, canal, motivo e satisfação.

### Modelagem dos dados

Com as bases tratadas, organizei o modelo com duas tabelas fato:

- `Fato_Entregas`: informações sobre prazo, status e atraso;
- `Fato_Interacoes`: registros de contato e satisfação do cliente.

As dimensões organizam calendário, motivo, canal, cidade e equipe. Os relacionamentos principais utilizam cardinalidade **um para muitos**, com direção de filtro da dimensão para a tabela fato.

A `Dim_Calendario` possui um relacionamento ativo com `Data_Pedido` e relacionamentos inativos com as datas prevista e realizada. Quando precisei analisar a entrega pela data em que ela realmente ocorreu, usei `USERELATIONSHIP` nas medidas.

### Medidas DAX

Com o modelo pronto, criei as medidas que alimentam o dashboard.

```DAX
Entregas Atrasadas =
CALCULATE(
    [Total Entregas],
    Fato_Entregas[Status_Validado] = "Atrasado"
)
```

```DAX
Taxa de Atraso =
DIVIDE(
    [Entregas Atrasadas],
    [Total Entregas],
    0
)
```

```DAX
Total Entregas Realizadas =
CALCULATE(
    [Total Entregas],
    USERELATIONSHIP(
        Fato_Entregas[Data_Entrega_Realizada],
        Dim_Calendario[Data]
    )
)
```

[Ver a construção técnica completa](docs/technical-implementation.md)

## Construção do dashboard

Organizei a página para contar a história dos dados em uma sequência simples:

1. visão geral dos indicadores;
2. evolução mensal dos atrasos;
3. principais motivos de contato;
4. comparação da satisfação por situação da entrega.

Os cartões apresentam os KPIs principais. O gráfico de linha mostra a evolução no tempo. As barras horizontais facilitam a comparação dos motivos, e as colunas comparativas mostram a diferença de satisfação entre entregas atrasadas e cumpridas.

## Escopo da apresentação

A apresentação final será curta e concentrada em três análises:

1. evolução do desempenho das entregas;
2. principais motivos de contato dos clientes;
3. relação entre atraso e satisfação.

## Entregáveis

- problema de negócio;
- base sintética e dicionário de dados;
- tratamento no Power Query;
- modelo de dados e relacionamentos;
- medidas DAX documentadas;
- dashboard em Power BI;
- três insights principais;
- recomendações de negócio;
- consultas SQL e análise simples em Python;
- premissas e limitações;
- arquivo `.pbix` após a revisão final;
- projeto `.pbip` com a estrutura do relatório e do modelo.

## Próximas etapas

- concluir a página executiva do dashboard;
- validar os indicadores finais;
- selecionar três insights principais;
- elaborar recomendações objetivas;
- salvar e publicar o arquivo `.pbix`;
- adicionar SQL e Python ao repositório;
- publicar as imagens finais do dashboard.

## Documentação complementar

- [Problema de negócio e metodologia](docs/business-problem-and-methodology.md)
- [Modelo e indicadores](docs/model-metrics-and-rules.md)
- [Como construí a solução](docs/technical-implementation.md)

## Premissas e limitações

- os dados são totalmente sintéticos;
- os resultados não representam uma empresa real;
- a satisfação é baseada apenas nas respostas disponíveis;
- associações entre atraso e satisfação não comprovam causalidade;
- o projeto demonstra método analítico, modelagem e visualização de dados.
