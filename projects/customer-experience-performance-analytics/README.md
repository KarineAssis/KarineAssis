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

## Jornada técnica da solução

```text
Mapeamento das fontes
        ↓
Tratamento e validação no Power Query
        ↓
Modelo dimensional e relacionamentos
        ↓
Medidas DAX
        ↓
Dashboard em Power BI
        ↓
Insights e recomendações
```

### Fontes e conectores

- arquivo Excel com a base logística, importado com `Excel.Workbook` e `File.Contents`;
- arquivos CSV UTF-8 com registros de contato e dimensões auxiliares, importados com `Csv.Document`;
- para um ambiente produtivo, a arquitetura poderia ser adaptada para SQL, data warehouse, lakehouse ou SharePoint, com atualização agendada.

### Tratamento no Power Query

Foram realizadas transformações como:

- correção dos tipos de dados e localidade das datas;
- promoção de cabeçalhos;
- criação da chave técnica `ID_Entrega`;
- cálculo de `Lead_Time_Dias`;
- cálculo de `Desvio_Prazo_Dias`;
- criação do `Status_Validado`;
- verificação da consistência entre o status original e o recalculado;
- padronização dos campos de motivo, canal e satisfação.

### Modelagem dimensional

O modelo utiliza duas tabelas fato:

- `Fato_Entregas`: informações sobre prazo, status e atraso;
- `Fato_Interacoes`: registros de contato e satisfação do cliente.

As dimensões organizam período, motivo, canal, cidade e equipe. Os relacionamentos principais utilizam cardinalidade **um para muitos** e direção de filtro da dimensão para a tabela fato.

A `Dim_Calendario` possui um relacionamento ativo com `Data_Pedido` e relacionamentos inativos com as datas prevista e realizada. As análises por data de entrega utilizam `USERELATIONSHIP` nas medidas DAX.

### Medidas DAX selecionadas

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

As medidas foram criadas para responder dinamicamente aos filtros do relatório. Foram aplicadas boas práticas como `DIVIDE`, `CALCULATE`, organização das medidas em tabela específica e uso de variáveis somente quando aumentam a clareza do cálculo.

[Ver a implementação técnica completa](docs/technical-implementation.md)

## Decisões de visualização

- **cartões:** leitura rápida dos KPIs principais;
- **gráfico de linha:** evolução mensal e identificação de tendências;
- **barras horizontais:** comparação dos principais motivos de contato;
- **colunas comparativas:** diferença de satisfação entre entregas atrasadas e cumpridas;
- **poucos filtros:** navegação simples e apresentação objetiva.

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
- modelo de dados e relacionamentos;
- medidas DAX documentadas;
- dashboard em Power BI;
- três insights principais;
- recomendações de negócio;
- consultas SQL e análise simples em Python;
- premissas e limitações;
- arquivo `.pbix` após a revisão final;
- projeto `.pbip` como evidência adicional da estrutura técnica.

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
- [Implementação técnica da solução](docs/technical-implementation.md)

## Premissas e limitações

- os dados são totalmente sintéticos;
- os resultados não representam uma empresa real;
- a satisfação é baseada apenas nas respostas disponíveis;
- associações entre atraso e satisfação não comprovam causalidade;
- o projeto demonstra método analítico, modelagem, DAX e visualização de dados.
