# Router de modelos no template `.claude` — design

**Data:** 2026-10-06 · **Status:** aprovado, implementado

## Problema

O template despacha trabalho sem critério de modelo. Dos 6 agents, três são
`model: sonnet` e três são `model: inherit`. Não existe nenhum agent Haiku — ou
seja, mesmo querendo mandar trabalho barato para um modelo barato, não há para
onde mandar. Na prática, Sonnet faz tarefa mecânica (rodar teste, contar nulo,
achar arquivo) que não exige nada dele.

O risco espelhado é pior: um router ingênuo, que só olha "complexidade
aparente", rebaixa para Haiku justamente as decisões que sustentam o projeto —
grão, split, leakage —, porque todas são curtas de escrever.

## Objetivo

Trabalho barato vai para modelo barato; trabalho caro **nunca** vai para modelo
barato. Opus é o líder que enquadra, decide e orquestra.

## Decisão central: dois eixos, não um

    tier = max(esforço, custo do erro)

- **Esforço** — quanto raciocínio a tarefa exige.
- **Custo do erro** — se errar, o erro aparece na hora ou entra em silêncio no
  entregável?

> Se o erro passa em silêncio para o entregável, não é tarefa de Haiku — por
> mais simples que pareça.

Esse segundo eixo é o que adapta o conceito genérico de router à ciência de
dados. Definir o grão de um join são três linhas e é o erro mais caro do
projeto. Rodar `pytest` e colar a saída é Haiku mesmo numa base complexa,
porque o erro ali aparece na hora.

Alternativas descartadas: tabela estática tarefa→modelo (engana em DS, onde
tarefa curta pode ser decisão cara); e "Haiku sempre coleta, Opus sempre julga"
como regra geral (vira overhead em tarefa pequena — foi mantida só como padrão
de execução dos agents pesados).

## Tiers

| Tier | Natureza | Exemplos |
|---|---|---|
| Haiku | Mecânico, erro visível na hora | buscar símbolo; rodar `ruff`/`pytest` e reportar; fix de lint; shape/dtypes/%nulos/duplicatas; schema do `INFORMATION_SCHEMA`; resumir stacktrace |
| Sonnet | Entender código/dado, resposta verificável | code review de estilo e robustez; teste de função existente; schema `pandera` a partir de regras dadas; reescrever SQL preservando resultado; model card de artefatos prontos |
| Opus | Julgamento, erro caro e silencioso — e orquestração | negócio→ML→métrica; grão; esquema de split; leakage; desenho de A/B; revisão estatística adversarial; leitura por fatia; handoff; arquitetura de pipeline |

## Mecanismo de enforcement

Verificado na documentação do Claude Code antes de implementar. Três
constatações mudaram o desenho inicial:

1. **`PreToolUse` não injeta stdout como contexto.** A doc lista como exceções
   apenas `UserPromptSubmit`, `UserPromptExpansion`, `SessionStart` e
   `PostModelSwitch`. Um hook de pré-despacho que imprime um bloco de texto
   esperando que o modelo leia é um **no-op**: roda, não falha, não faz nada.
2. **Despacho de subagent não é um matcher de `PreToolUse`.** A doc trata
   subagent por `SubagentStart`/`SubagentStop`, com matcher em `agent_type`.
3. **`SubagentStart` não bloqueia** — *"Context only… No blocking or decision
   control"* — e o contexto que injeta vai para o subagent, não para o pai.
   Quando dispara, o modelo já foi escolhido.

Conclusão: **não existe gate de auditoria pré-despacho**. O router se apoia em
duas peças que funcionam de fato:

| Peça | Enforcement |
|---|---|
| Hook `UserPromptSubmit` | Injeta tiers + gates antes de o Claude escolher qualquer coisa. É onde a decisão de roteamento acontece. |
| `model:` no frontmatter do agent | Declarativo e duro. Não depende de hook. |

Hooks de subagent foram descartados: baixo retorno pelo custo de manutenção.

## Classificação de cada mensagem (no hook)

- **A) TRABALHO** — código, SQL, pipeline, revisão, debug → mostra o plano de
  roteamento, despacha, loga `[Route] tarefa → modelo (motivo)`.
- **B) DECISÃO DE DADOS** — grão, split, métrica, leakage, causalidade, desenho
  de experimento → **não delega**. Opus responde; Haiku só coleta fatos.
- **C) CONVERSA** — pergunta rápida, confirmação → responde direto.
- Na dúvida entre A e B → trata como B.

A categoria B é o que impede o router de virar máquina de economizar token às
custas da qualidade.

## Gates de despacho

1. **Modelo** declarado e coerente com o tier.
2. **Aprovação** — óbvio despacha sozinho com log; ambíguo ou subagent Opus
   pergunta antes.
3. **Colisão** — dois agents paralelos no mesmo conjunto de arquivos rodam
   sequencialmente.
4. **Isolamento** — despacho paralelo exige `isolation: "worktree"`.

## Agents

Novos, todos Haiku: `repo-scout` (localiza), `test-runner` (roda e reporta, não
conserta), `data-profiler` (perfil mecânico, **proibido de interpretar**).

Reatribuição: `eda-explorer`, `ml-modeler`, `stats-reviewer` passam de
`inherit` para `opus`; `code-reviewer`, `sql-optimizer`, `data-validator`
seguem `sonnet`. `sql-optimizer` escala para Opus quando a questão for de
grão/fan-out em vez de custo.

**Trade-off aceito:** com `inherit`, abrir a sessão em Sonnet fazia os três
pesados rodarem em Sonnet. Com `opus` fixo, custam Opus sempre. É intencional —
são justamente aqueles onde o erro é caro.

## Padrão coleta → julgamento

Os agents caros delegam a parte mecânica: `eda-explorer` (Opus) chama
`data-profiler` (Haiku) para levantar os números e gasta seu raciocínio
interpretando-os. O barato nunca conclui; o caro nunca conta nulo na mão.

## Arquivos

Criados: `.claude/rules/80-roteamento.md` · `.claude/hooks/routing-reminder.sh`
· `.claude/agents/{repo-scout,test-runner,data-profiler}.md` ·
`.claude/commands/rota.md`

Alterados: `.claude/settings.json` · `CLAUDE.md` · `README.md` · os 6 agents
existentes.

## Verificação

Sem runtime: `bash -n` no hook, execução do hook conferindo a saída, `jq` no
`settings.json`, e checagem de que todo agent tem `model:` explícito.

## Riscos conhecidos

- O hook roda a **cada** mensagem, inclusive "ok". O bloco foi mantido curto
  (~15 linhas) para o router não se pagar em tokens. Variável
  `CLAUDE_ROUTER_OFF=1` desliga sem editar config.
- O router depende de o Claude seguir o texto injetado. Não há mecanismo que
  force a escolha do modelo no despacho — só o `model:` do frontmatter, que
  vale para agents, não para decisões tomadas na sessão principal.
