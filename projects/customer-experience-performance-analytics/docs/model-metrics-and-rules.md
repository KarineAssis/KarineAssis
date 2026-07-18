# Modelo e indicadores

## Estrutura do modelo

O modelo conecta o desempenho das entregas com os registros de contato e satisfação dos clientes.

### Fato_Entregas

Contém as informações principais de cada entrega:

- pedido;
- data do pedido;
- prazo previsto;
- data realizada;
- status da entrega;
- lead time;
- dias de atraso.

### Fato_Interacoes

Contém os registros relacionados à experiência do cliente:

- interação;
- pedido relacionado;
- data do contato;
- motivo;
- canal;
- cidade ou equipe;
- resposta de satisfação.

## Dimensões principais

- `Dim_Calendario` — datas, meses e anos;
- `Dim_Motivos` — motivos de contato;
- `Dim_Canal_Atendimento` — canais utilizados;
- `Dim_Equipe_Atendimento` — equipes da operação;
- demais dimensões auxiliares do modelo.

As dimensões filtram as tabelas fato em relacionamentos de um para muitos.

## Indicadores apresentados

### Entregas analisadas

Quantidade total de entregas presentes na base.

### Cumprimento do prazo

Percentual de entregas concluídas no prazo ou antecipadamente.

### Taxa de atraso

Percentual de entregas realizadas depois da data prevista.

### Lead time médio

Tempo médio entre a data do pedido e a realização da entrega.

### Interações de clientes

Quantidade de registros de contato relacionados às entregas.

### Satisfação do cliente

Percentual de respostas classificadas como satisfeitas entre as pesquisas respondidas.

## Análises do dashboard

1. evolução mensal do desempenho das entregas;
2. comparação por cidade, canal ou equipe;
3. principais motivos de contato;
4. satisfação por status da entrega.

Para manter a apresentação objetiva, apenas as três análises mais relevantes serão destacadas no case final.

## Regras de interpretação

- taxas devem ser analisadas junto com volumes;
- pesquisas não respondidas não são tratadas como satisfeitas ou insatisfeitas;
- grupos com baixo volume exigem cautela;
- relação entre atraso e satisfação indica associação, não necessariamente causalidade;
- o dashboard deve apoiar priorização, e não apenas exibir indicadores.
