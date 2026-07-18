# Problema de negócio e metodologia

## Cenário

O case representa uma empresa de logística que precisa melhorar a experiência do cliente.

A operação possui dados de entregas e registros de contato, mas essas informações estão separadas. Isso dificulta entender onde os atrasos acontecem, quais problemas aparecem com maior frequência e como o desempenho logístico afeta a satisfação.

## Problema de negócio

A liderança precisa responder três perguntas:

1. Onde estão concentrados os atrasos?
2. Quais motivos geram mais contatos dos clientes?
3. Entregas atrasadas apresentam menor satisfação?

## Hipóteses analisadas

- atrasos estão concentrados em alguns períodos, cidades ou equipes;
- certos motivos de contato aparecem com maior frequência;
- entregas atrasadas tendem a apresentar menor satisfação.

## Construção da base sintética

Os dados foram gerados programaticamente e não representam uma empresa real.

A base combina:

- informações de pedidos e entregas;
- prazo previsto e data realizada;
- status e dias de atraso;
- registros de contato;
- motivos e canais;
- indicador de satisfação.

Foram usadas regras probabilísticas para criar relações plausíveis entre atraso, contato e satisfação, sem tornar os resultados totalmente previsíveis.

## Etapas do trabalho

1. definição do problema de negócio;
2. auditoria e entendimento da base;
3. tratamento no Power Query;
4. modelagem dimensional;
5. criação das medidas DAX;
6. construção do dashboard;
7. seleção de três insights;
8. recomendações e limitações.

## Princípios de análise

- validar os dados antes de concluir;
- analisar taxas junto com volumes;
- evitar conclusões causais sem evidência;
- manter a apresentação curta e objetiva;
- priorizar clareza, lógica e tomada de decisão.
