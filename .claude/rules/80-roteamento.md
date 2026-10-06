# Roteamento de modelos — quem faz o quê

**Opus é o líder.** Ele enquadra o problema, toma as decisões de dados e
orquestra. Sonnet e Haiku são braços para quem ele delega.

Esta rule existe por dois motivos, nessa ordem de importância:

1. Trabalho caro **nunca** deve ser feito por modelo barato.
2. Trabalho barato não deveria ser feito por modelo caro.

## A regra central

    tier = max(esforço, custo do erro)

São dois eixos, não um:

- **Esforço** — quanto raciocínio a tarefa exige.
- **Custo do erro** — se errar, o erro aparece na hora ou entra **em silêncio**
  no entregável?

> **Se o erro passa em silêncio para o entregável, não é tarefa de Haiku — por
> mais simples que pareça.**

Em ciência de dados o segundo eixo manda. Definir o grão de um join são três
linhas de código e é o erro mais caro do projeto. Rodar `pytest` e colar a saída
é trabalho de Haiku mesmo numa base complicada, porque um erro ali aparece na
hora.

## Os três tiers

### Haiku — mecânico, erro visível na hora

Buscar arquivo, símbolo ou uso no repo · rodar `ruff`/`mypy`/`pytest` e reportar
a saída · aplicar fix de lint · listar shape, colunas, dtypes · contar nulos,
duplicatas, cardinalidade · extrair schema do `INFORMATION_SCHEMA` · resumir
stacktrace · docstring de função já escrita · converter formato de arquivo.

Agents: `repo-scout`, `test-runner`, `data-profiler`.

### Sonnet — exige entender o código/dado, resposta verificável

Code review de estilo e robustez · escrever teste para função existente ·
escrever schema `pandera` a partir de regras já definidas · reescrever SQL
preservando o resultado · implementar função bem especificada · montar o model
card a partir de artefatos já produzidos.

Agents: `code-reviewer`, `sql-optimizer`, `data-validator`.

### Opus — julgamento, erro caro e silencioso (e orquestração)

Cadeia negócio → ML → métrica · definir o **grão** · escolher o esquema de
split · caçar **leakage** · desenhar experimento/A-B · revisão estatística
adversarial · interpretar resultado por fatia · decidir arquitetura de pipeline
· escrever o handoff · **e coordenar todo o resto**.

Agents: `eda-explorer`, `ml-modeler`, `stats-reviewer`.

## Classificação de cada pedido

- **A) TRABALHO** — código, SQL, pipeline, revisão, debug, refactor, feature.
  → Diga o plano de roteamento antes de agir, despache, e logue cada despacho:
  `[Route] <tarefa> → <modelo> (<motivo>)`.
- **B) DECISÃO DE DADOS** — grão, split, métrica, leakage, causalidade, desenho
  de experimento, enquadramento do problema.
  → **Não delegue.** Responda em Opus. Pode usar Haiku para *coletar fatos*
  (contagens, schema, amostra), nunca para concluir.
- **C) CONVERSA** — pergunta rápida, confirmação, cumprimento.
  → Responda direto. Sem roteamento, sem tabela.

**Na dúvida entre A e B, trate como B.** Rebaixar uma decisão de dados custa
muito mais caro do que gastar Opus numa tarefa que daria para Sonnet.

## Gates antes de despachar um subagent

1. **Modelo** — o `model` do agent (ou o parâmetro do despacho) bate com o tier
   da tarefa?
2. **Aprovação** — tarefa óbvia (buscar, rodar teste, revisar estilo) despacha
   sozinha. Tarefa ambígua **ou** subagent em Opus: pergunte antes.
3. **Colisão** — dois agents paralelos mexem no mesmo conjunto de arquivos? Se
   sim, rode sequencialmente.
4. **Isolamento** — despacho paralelo exige `isolation: "worktree"`. Agent
   sozinho pode dispensar.

## Escalar e rebaixar

**Escale para Opus** assim que aparecer: dúvida sobre grão, suspeita de
leakage, escolha de métrica, pergunta causal, ou resultado "bom demais".
Não termine a tarefa no tier errado — pare e escale.

**Rebaixe para Haiku** a parte mecânica de uma tarefa cara, em vez de fazer
tudo em Opus. O padrão é **coleta → julgamento**: o barato levanta os números,
o caro os interpreta. `eda-explorer` faz exatamente isso com o `data-profiler`.

O agent barato **nunca conclui**; o agent caro **nunca conta nulo na mão**.

## Sessão principal

O padrão é rodar a sessão principal em **Opus** — é ele quem classifica e
despacha. Vale trocar com `/model` para Sonnet quando a sessão inteira for
execução de um plano já decidido (implementar funções especificadas, escrever
testes, aplicar um refactor combinado). Quando a sessão volta a envolver
decisão de dados, volte para Opus.

## Desligar

O lembrete de roteamento é injetado pelo hook `routing-reminder.sh`. Para
desligá-lo numa sessão, exporte `CLAUDE_ROUTER_OFF=1` antes de abrir o Claude
Code. As atribuições de `model:` nos agents continuam valendo — elas não
dependem do hook.
