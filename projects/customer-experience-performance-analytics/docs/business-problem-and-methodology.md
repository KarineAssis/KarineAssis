# Problema de negócio e metodologia

## Cenário

O case representa uma operação de delivery com três públicos principais:

- **Customer** — clientes que realizam pedidos;
- **Rider** — entregadores;
- **Merchant** — restaurantes e estabelecimentos parceiros.

A operação recebe contatos por Chat, Voz e E-mail. Cada interação pode envolver motivos, níveis de complexidade e impactos diferentes sobre satisfação, resolução e eficiência.

## Problema de negócio

A leitura isolada de indicadores agregados não informa onde agir primeiro.

Um CSAT baixo pode estar associado a atraso na entrega, baixa resolução, recontato, escalonamento ou complexidade do motivo. Da mesma forma, um AHT alto pode representar ineficiência ou simplesmente um caso mais complexo.

A liderança precisa de uma visão integrada para responder:

1. Quais motivos concentram maior volume de DSAT?
2. Qual é o impacto do atraso na satisfação?
3. Quais LOBs, canais e equipes apresentam maior risco?
4. Onde FCR baixo e recontato alto acontecem simultaneamente?
5. Quais agentes devem ser reconhecidos, acompanhados ou desenvolvidos?

## Hipóteses analíticas

O projeto testará as seguintes hipóteses:

- pedidos atrasados apresentam CSAT menor;
- baixa resolução no primeiro contato aumenta recontato e DSAT;
- escalonamentos estão associados a maior complexidade e menor satisfação;
- AHT deve ser interpretado junto com FCR e qualidade;
- motivos com alto volume e impacto moderado podem ser mais prioritários que motivos raros com taxas extremas.

## Construção da base sintética

Os dados foram gerados programaticamente, sem copiar registros reais.

As regras probabilísticas foram definidas para criar relações plausíveis:

- atraso aumenta a probabilidade de insatisfação;
- FCR baixo aumenta a probabilidade de recontato;
- escalonamento e complexidade tendem a elevar AHT;
- pesquisas respondidas representam apenas parte das interações;
- agentes e equipes possuem variação controlada de performance.

O objetivo não é reproduzir uma empresa específica, mas criar um ambiente analítico coerente para demonstrar método, modelagem e tomada de decisão.

## Princípios metodológicos

### Evidência antes da conclusão

Nenhum insight será publicado sem validação dos dados e das regras de cálculo.

### Taxa e impacto absoluto

Taxas elevadas em grupos pequenos serão interpretadas com cautela. A priorização combinará proporção, volume e relevância operacional.

### Qualidade antes de velocidade

AHT não será tratado como meta isolada. Reduzir tempo sem preservar resolução e qualidade pode piorar a experiência.

### Comparabilidade mínima

Ranking e quartis exigem volume mínimo de interações e pesquisas respondidas.

### Transparência

Resultados, premissas e limitações serão documentados. O case não atribuirá causalidade quando houver apenas associação.

## Etapas do trabalho

1. definição do problema de negócio;
2. geração e auditoria da base sintética;
3. dicionário e regras de dados;
4. tratamento no Power Query;
5. modelagem dimensional;
6. criação das medidas DAX;
7. análise exploratória;
8. dashboard executivo;
9. cinco insights principais;
10. recomendações e limitações.
