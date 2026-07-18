# Como construí a solução

O ponto de partida foi um problema simples: uma empresa de logística tinha dados sobre pedidos, entregas e contatos de clientes, mas essas informações estavam separadas. Antes de construir qualquer visual, eu precisava organizar as fontes, tratar os dados e criar um modelo que permitisse acompanhar o desempenho das entregas e relacioná-lo à satisfação do cliente.

## 1. Mapeamento das fontes

Comecei identificando quais informações estavam disponíveis e em qual formato.

| Fonte | Formato | Conteúdo | Conector utilizado |
|---|---|---|---|
| Base logística | Excel (`.xlsx`) | pedidos, datas, equipes, canais e status de entrega | `Excel.Workbook` + `File.Contents` |
| Base de interações | CSV UTF-8 (`.csv`) | contatos, motivos, canais e satisfação | `Csv.Document` + `File.Contents` |
| Dimensões auxiliares | CSV UTF-8 (`.csv`) | motivos e atributos complementares | `Csv.Document` + `File.Contents` |

Essa primeira leitura mostrou que a base logística seria a principal fonte para acompanhar prazo, atraso e lead time, enquanto os registros de contato complementariam a análise com informações sobre os motivos relatados e a satisfação dos clientes.

## 2. Tratamento dos dados no Power Query

Com as fontes mapeadas, passei para a etapa de limpeza e transformação.

### Base de entregas

Na base logística, organizei a sequência de tratamento da seguinte forma:

1. importação da planilha `Logistica`;
2. promoção da primeira linha para cabeçalhos;
3. definição dos tipos de dados;
4. conversão das datas usando a localidade `pt-BR`;
5. criação de uma chave técnica `ID_Entrega`;
6. cálculo do lead time;
7. cálculo do desvio entre a data prevista e a data realizada;
8. validação automática do status da entrega;
9. comparação entre o status original e o status recalculado.

Durante esse processo, criei colunas que permitiram transformar as datas em informações úteis para análise.

```powerquery
Lead_Time_Dias = Duration.Days([Data_Entrega_Realizada] - [Data_Pedido])
```

```powerquery
Desvio_Prazo_Dias = Duration.Days([Data_Entrega_Realizada] - [Data_Entrega_Prevista])
```

```powerquery
Status_Validado =
if [Desvio_Prazo_Dias] < 0 then "Antecipado"
else if [Desvio_Prazo_Dias] = 0 then "No Prazo"
else "Atrasado"
```

```powerquery
Status_Consistente =
if [Status_Entrega] = [Status_Validado] then "Sim" else "Não"
```

A criação do `Status_Validado` foi importante porque passou a classificar cada entrega com base nas datas, sem depender apenas do status informado originalmente.

### Base de interações

Na base de interações, fiz a promoção dos cabeçalhos, defini os tipos de texto, número, data e data/hora, configurei a leitura em UTF-8 e padronizei os campos de canal, motivo e satisfação.

Depois do tratamento, as duas bases estavam prontas para serem conectadas no modelo.

## 3. Construção do modelo de dados

Na etapa seguinte, organizei o modelo com duas tabelas fato:

- `Fato_Entregas`: uma linha por entrega;
- `Fato_Interacoes`: uma linha por registro de contato.

As tabelas de dimensão passaram a organizar os filtros usados no relatório:

- `Dim_Calendario`;
- `Dim_Motivos`;
- `Dim_Canal_Atendimento`;
- `Dim_Equipe_Atendimento`;
- dimensões auxiliares do modelo.

Os relacionamentos principais seguem o padrão:

```text
Dimensão (1) ───────── (*) Tabela fato
```

A cardinalidade é um para muitos, com direção de filtro da dimensão para a tabela fato. As tabelas fato não foram conectadas diretamente entre si.

### Relacionamentos de data

A mesma entrega possui diferentes datas importantes. Por isso, a `Dim_Calendario` foi relacionada com:

- `Data_Pedido` — relacionamento ativo;
- `Data_Entrega_Realizada` — relacionamento inativo;
- `Data_Entrega_Prevista` — relacionamento inativo;
- `Data_Contato` — relacionamento ativo com a tabela de interações.

Para analisar entregas pela data realizada ou prevista, utilizei `USERELATIONSHIP` dentro das medidas.

## 4. Criação das medidas DAX

Com o modelo pronto, criei medidas para responder às perguntas do projeto e reagir aos filtros do relatório.

### Total de entregas

```DAX
Total Entregas =
COUNTROWS(Fato_Entregas)
```

### Entregas atrasadas

```DAX
Entregas Atrasadas =
CALCULATE(
    [Total Entregas],
    Fato_Entregas[Status_Validado] = "Atrasado"
)
```

Nesta medida, `CALCULATE` altera o contexto para considerar apenas as entregas classificadas como atrasadas.

### Taxa de atraso

```DAX
Taxa de Atraso =
DIVIDE(
    [Entregas Atrasadas],
    [Total Entregas],
    0
)
```

### Taxa de cumprimento do prazo

```DAX
Taxa de Cumprimento =
DIVIDE(
    [Entregas Antecipadas] + [Entregas no Prazo],
    [Total Entregas],
    0
)
```

### Lead time médio

```DAX
Lead Time Médio =
AVERAGE(Fato_Entregas[Lead_Time_Dias])
```

### Entregas por data realizada

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

Essa medida permite analisar o volume pela data em que a entrega realmente aconteceu.

### Satisfação do cliente

```DAX
Satisfação do Cliente =
DIVIDE(
    SUM(Fato_Interacoes[CSAT_Flag]),
    [Pesquisas Respondidas],
    0
)
```

A medida considera somente as pesquisas respondidas no denominador.

## 5. Construção do dashboard

Depois de validar os cálculos, organizei a página executiva para conduzir a leitura em uma sequência simples.

No topo, coloquei os principais indicadores para oferecer uma visão geral rápida. Em seguida, usei um gráfico de linha para mostrar a evolução mensal da taxa de atraso. Os motivos de contato foram apresentados em barras horizontais, facilitando a comparação entre categorias. Por fim, a satisfação foi comparada por situação da entrega para mostrar a diferença entre pedidos atrasados e cumpridos.

| Elemento da página | Tipo de visual | Função no dashboard |
|---|---|---|
| Indicadores principais | Cartões | Resumir o cenário geral |
| Evolução da taxa de atraso | Gráfico de linha | Mostrar tendências e períodos críticos |
| Principais motivos de contato | Gráfico de barras horizontais | Comparar as categorias mais frequentes |
| Satisfação por situação da entrega | Gráfico de colunas | Comparar entregas atrasadas e cumpridas |
| Filtros de análise | Segmentadores | Permitir recortes relevantes sem poluir a página |

A leitura do dashboard segue esta ordem:

```text
Visão geral → evolução dos atrasos → motivos de contato → impacto na satisfação
```

## 6. Arquivos do projeto

| Entregável | Finalidade | Status |
|---|---|---|
| Arquivo `.pbix` | abertura direta no Power BI Desktop | será publicado após a revisão final |
| Projeto `.pbip` | estrutura do relatório e do modelo semântico | preparado para publicação |
| Imagens/PDF | visualização do dashboard sem Power BI Desktop | em preparação |
| Dicionário de dados | explicar o significado de cada campo, seu tipo e sua regra de uso | será adicionado ao repositório |
| Documentação técnica | registrar as etapas de construção da solução | disponível neste repositório |
