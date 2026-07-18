# Implementação técnica da solução

Este documento mostra a jornada técnica do case: **fontes de dados → Power Query → modelo dimensional → medidas DAX → dashboard → entrega**.

O objetivo é deixar evidente não apenas o contexto de negócio, mas também como a solução foi construída no Power BI.

## 1. Mapeamento das fontes de dados

O projeto utiliza fontes locais e sintéticas, adequadas para um case de portfólio.

| Fonte | Formato | Conteúdo | Conector utilizado |
|---|---|---|---|
| Base logística | Excel (`.xlsx`) | pedidos, datas, equipes, canais e status de entrega | `Excel.Workbook` + `File.Contents` |
| Base de interações | CSV UTF-8 (`.csv`) | contatos, motivos, canais e satisfação | `Csv.Document` + `File.Contents` |
| Dimensões auxiliares | CSV UTF-8 (`.csv`) | motivos e atributos complementares | `Csv.Document` + `File.Contents` |

### Por que esses conectores foram escolhidos?

- são adequados ao formato real das fontes do exercício;
- permitem importar e transformar os dados diretamente no Power Query;
- mantêm o projeto simples e reproduzível para fins de portfólio.

### Como seria em um ambiente produtivo?

Arquivos locais não são a melhor opção para atualização em tempo real. Em produção, a solução poderia utilizar:

- banco de dados SQL;
- data warehouse ou lakehouse;
- SharePoint ou OneDrive;
- parâmetros de ambiente;
- gateway e atualização agendada no Power BI Service.

A escolha final dependeria do volume, frequência de atualização, segurança e arquitetura disponível.

## 2. Tratamento dos dados no Power Query

### Base de entregas

As principais transformações realizadas foram:

1. importação da planilha `Logistica`;
2. promoção da primeira linha para cabeçalhos;
3. definição dos tipos de dados;
4. conversão das datas usando a localidade `pt-BR`;
5. criação de uma chave técnica `ID_Entrega`;
6. cálculo do lead time;
7. cálculo do desvio entre data prevista e data realizada;
8. validação automática do status da entrega;
9. comparação entre o status original e o status recalculado.

### Colunas criadas

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

### Base de interações

Na base de interações foram aplicadas:

- promoção dos cabeçalhos;
- definição dos tipos de texto, número, data e data/hora;
- configuração UTF-8 para preservar caracteres;
- padronização de canal, motivo e status;
- preparação dos campos utilizados nas análises de satisfação.

## 3. Modelagem de dados

O projeto utiliza um **modelo dimensional em constelação de fatos**, aplicando princípios de star schema.

### Tabelas fato

- `Fato_Entregas`: uma linha por entrega;
- `Fato_Interacoes`: uma linha por registro de contato.

### Dimensões

- `Dim_Calendario`;
- `Dim_Motivos`;
- `Dim_Canal_Atendimento`;
- `Dim_Equipe_Atendimento`;
- dimensões auxiliares do modelo.

### Cardinalidade e direção de filtro

Os relacionamentos principais seguem o padrão:

```text
Dimensão (1) ───────── (*) Tabela fato
```

- cardinalidade **um para muitos**;
- direção de filtro única, da dimensão para a fato;
- ausência de relacionamento muitos para muitos no modelo principal;
- tabelas fato não são conectadas diretamente entre si.

### Relacionamentos de data

A dimensão calendário possui diferentes papéis:

- `Data_Pedido` — relacionamento ativo;
- `Data_Entrega_Realizada` — relacionamento inativo;
- `Data_Entrega_Prevista` — relacionamento inativo;
- `Data_Contato` — relacionamento ativo com a tabela de interações.

Os relacionamentos inativos são acionados nas medidas com `USERELATIONSHIP`, permitindo analisar o mesmo indicador por diferentes perspectivas de data sem duplicar a tabela calendário.

## 4. Medidas DAX

Os KPIs foram criados como **medidas**, e não como colunas calculadas, porque precisam responder dinamicamente aos filtros de período, equipe, canal e demais dimensões.

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

`CALCULATE` modifica o contexto de filtro para considerar somente as entregas classificadas como atrasadas.

### Taxa de atraso

```DAX
Taxa de Atraso =
DIVIDE(
    [Entregas Atrasadas],
    [Total Entregas],
    0
)
```

`DIVIDE` foi utilizado em vez do operador `/` para tratar divisões por zero de forma segura.

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

Essa medida ativa temporariamente o relacionamento entre a data realizada e a dimensão calendário.

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

### Boas práticas aplicadas

- nomes descritivos para medidas e colunas;
- medidas concentradas em uma tabela específica;
- uso de `DIVIDE` para cálculos de taxa;
- uso de `CALCULATE` para alteração do contexto de filtro;
- uso de `USERELATIONSHIP` para análises temporais;
- uso de variáveis apenas quando aumentam a legibilidade de medidas com múltiplas etapas;
- preferência por medidas em vez de colunas calculadas para agregações dinâmicas.

## 5. Construção do dashboard

A página executiva foi desenhada para responder rapidamente às perguntas do negócio.

### Decisões de visualização

| Elemento | Escolha | Justificativa |
|---|---|---|
| KPIs no topo | cartões | leitura rápida dos principais resultados |
| Evolução mensal | gráfico de linha | evidencia tendência, picos e mudanças ao longo do tempo |
| Motivos de contato | barras horizontais | facilita comparar categorias e nomes mais longos |
| Satisfação por status | colunas comparativas | torna visível a diferença entre entregas atrasadas e cumpridas |
| Filtros | poucos e relevantes | evita poluição visual e mantém a análise objetiva |

A hierarquia visual segue a sequência:

```text
Visão geral → evolução → causas principais → impacto na satisfação
```

## 6. Entregáveis técnicos

| Entregável | Finalidade | Status |
|---|---|---|
| Arquivo `.pbix` | produto final para abertura direta no Power BI Desktop | será publicado após a revisão final |
| Projeto `.pbip` | estrutura aberta do relatório e do modelo semântico | preparado para publicação |
| Imagens/PDF | visualização por pessoas sem Power BI Desktop | em preparação |
| Dicionário de dados | descrição dos campos e regras | disponível na estrutura do projeto |
| Documentação técnica | fontes, Power Query, modelo, DAX e design | disponível neste repositório |

## 7. O que este case demonstra

- capacidade de mapear fontes de dados;
- tratamento e validação no Power Query;
- modelagem dimensional;
- compreensão de cardinalidade e direção de filtro;
- criação de medidas DAX;
- seleção de visualizações adequadas;
- tradução de um problema de negócio em um dashboard funcional.

A apresentação executiva continuará curta, com três insights. Esta documentação funciona como a evidência técnica para quem desejar aprofundar a avaliação do projeto.
