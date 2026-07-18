# Modelo, métricas e regras analíticas

## Estrutura do modelo

O modelo combina desempenho operacional e experiência do cliente por meio de duas tabelas fato.

### Fato_Entregas

Representa cada entrega e contém informações como:

- pedido;
- data do pedido;
- prazo previsto;
- data realizada;
- status da entrega;
- lead time;
- desvio do prazo.

### Fato_Interacoes

Representa cada contato de atendimento e contém:

- interação e jornada;
- pedido relacionado;
- data e hora do contato;
- LOB, canal e motivo;
- agente e equipe;
- AHT;
- FCR;
- recontato;
- escalonamento;
- QA;
- resposta de pesquisa;
- CSAT e DSAT.

## Dimensões

- `Dim_Calendario` — período e atributos temporais;
- `Dim_Agentes` — agentes fictícios;
- `Dim_Motivos` — motivos de contato;
- `Dim_LOB` — Customer, Rider e Merchant;
- `Dim_Canal_Atendimento` — Chat, Voz e E-mail;
- `Dim_Equipe_Atendimento` — equipes fictícias.

As dimensões filtram as tabelas fato em relacionamentos de um para muitos.

## Indicadores principais

### CSAT

Percentual de respostas com nota considerada satisfeita sobre o total de pesquisas respondidas.

### DSAT

Percentual de respostas consideradas insatisfeitas sobre o total de pesquisas respondidas.

### FCR

Percentual de jornadas resolvidas no primeiro contato.

### AHT

Tempo médio de atendimento. Deve ser interpretado junto com complexidade, FCR, recontato e QA.

### Taxa de recontato

Percentual de jornadas que exigiram novo contato para o mesmo problema.

### Taxa de escalonamento

Percentual de interações encaminhadas para um nível adicional de suporte.

### QA médio

Indicador médio de qualidade do atendimento.

## Medidas de diagnóstico

- Gap de CSAT por atraso;
- CSAT de pedidos atrasados;
- CSAT de pedidos cumpridos;
- respostas DSAT por motivo;
- participação no DSAT total;
- interações por jornada;
- volume mínimo para ranking.

## Score de performance

O score combina quatro dimensões:

| Componente | Peso |
|---|---:|
| CSAT | 35% |
| FCR | 30% |
| QA | 20% |
| Redução de recontatos | 15% |

O AHT não entra diretamente no score. Ele permanece como indicador de diagnóstico para evitar que um atendimento curto seja interpretado automaticamente como uma boa experiência.

## Elegibilidade para ranking

O agente precisa atingir um volume mínimo de interações e pesquisas respondidas. Esse critério evita comparações frágeis entre agentes com bases muito diferentes.

## Segmentação por quartil

- `Q1` — referência de performance;
- `Q2` — performance consistente;
- `Q3` — atenção e acompanhamento;
- `Q4` — prioridade de desenvolvimento.

O quartil é uma ferramenta de segmentação, não uma conclusão isolada. A leitura final deve considerar LOB, motivo, complexidade e volume.

## Regras de interpretação

1. CSAT e DSAT usam apenas pesquisas respondidas.
2. Ausência de resposta não é tratada como satisfação ou insatisfação.
3. Taxas são acompanhadas por volumes absolutos.
4. AHT alto não significa necessariamente baixa performance.
5. Correlação entre atraso e satisfação não prova causalidade.
6. Rankings exigem critérios mínimos de comparabilidade.
7. Recomendações devem priorizar impacto, recorrência e capacidade de ação.
