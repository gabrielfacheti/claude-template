# Template `.claude` para Ciência de Dados

Um kit padrão para trabalhar do mesmo jeito em projetos diferentes. A cada projeto
novo você copia esta pasta, **edita só o `CLAUDE.md`**, e o resto (padrões de código,
estatística, ML, git, agents, skills) já vem pronto.

Método ancorado em dois livros: **Chip Huyen — _Designing Machine Learning Systems_**
(ciclo de vida e produção) e **Catherine Nelson — _Software Engineering for Data
Scientists_** (artesanato de software aplicado à DS).

---

## Começo rápido

1. Copie `CLAUDE.md`, `.gitignore` e a pasta `.claude/` para a raiz do projeto.
   (O `CLAUDE.md` fica na **raiz**; todo o resto dentro de `.claude/`.)
2. Abra o `CLAUDE.md` e preencha as seções marcadas **`[EDITAR POR PROJETO]`**
   (projeto & negócio, dados, ambiente, definição de pronto).
3. `/novo-projeto <nome>` para criar a estrutura de pastas do repositório.
4. Trabalhe: `/eda` → `/baseline` → iterar → `/revisar` → `/model-card` → `/handoff`.

## Modelo mental

| Peça | O que é | Muda por projeto? |
|---|---|---|
| **`CLAUDE.md`** | Memória do projeto: contexto de negócio, dados, ambiente. | **Sim** — é o que você edita. |
| **`rules/`** | Padrões de como trabalhamos (código, SQL, estatística, ML, git). | Não (compartilhado). |
| **`agents/`** | Subagentes especialistas que o Claude delega sozinho. | Não. |
| **`skills/`** | Procedimentos que o Claude carrega sob demanda p/ uma tarefa. | Não. |
| **`commands/`** | Atalhos `/comando` que você dispara. | Não. |
| **`settings.json`** | Permissões, ambiente e registro dos hooks. | Raramente. |
| **`hooks/`** | Scripts que o Claude Code roda em eventos da sessão. | Não. |

> **Rules vs. agents vs. skills** (a dúvida comum):
> *rule* é uma **norma sempre ativa** (carregada via `@import` no `CLAUDE.md`);
> *skill* é um **como-fazer** que entra em cena quando a tarefa casa com a descrição;
> *agent* é um **quem-faz** — uma persona com ferramentas próprias, que o Claude
> aciona para um trabalho focado (ex.: revisar código, caçar erro estatístico).

## Estrutura

```
.claude/
├── README.md                 # este arquivo
├── settings.json             # permissões + env (PYTHONHASHSEED)
├── settings.local.json.example  # copie p/ settings.local.json (pessoal, git-ignored)
├── rules/                    # 9 normas sempre ativas
├── hooks/                    # routing-reminder.sh (injeta o router a cada turno)
├── agents/                   # 9 subagentes (3 haiku · 3 sonnet · 3 opus)
├── skills/                   # 6 skills (+ template de model card)
└── commands/                 # 7 slash commands
```

## Rules (normas)

| Arquivo | Cobre |
|---|---|
| `00-principios.md` | Processo iterativo, requisitos de um bom sistema, negócio→ML, "comece simples". |
| `10-python.md` | ruff, types, pandas sem armadilha, logging, testes (pandera/pydantic), performance. |
| `20-sql-warehouse.md` | CTEs, grão & fan-out, NULL, custo, dbt (staging→marts, testes). |
| `30-analise-estatistica.md` | EDA, amostragem/viés, testes de hipótese, A/B, causalidade. |
| `40-modelagem-ml.md` | Split antes do fit, **data leakage**, Pipeline, baseline, avaliação por fatia. |
| `50-reprodutibilidade.md` | Ambiente travado, seeds, `raw` imutável, pipeline determinístico. |
| `60-git-workflow.md` | Commits, PRs, pre-commit, o que nunca versionar. |
| `70-comunicacao.md` | BLUF, incerteza, visualização, documentação, handoff. |
| `80-roteamento.md` | **Router de modelos:** tiers, custo do erro, gates de despacho. |

## Agents (subagentes)

| Agent | Tier | Quando o Claude aciona |
|---|---|---|
| `repo-scout` | haiku | Achar arquivo, símbolo ou uso no repo. |
| `test-runner` | haiku | Rodar ruff/mypy/pytest e devolver a saída real. |
| `data-profiler` | haiku | Levantar os números de um dataset (não interpreta). |
| `code-reviewer` | sonnet | Revisar Python/SQL antes de commitar. |
| `sql-optimizer` | sonnet | Corrigir e baratear SQL/dbt. |
| `data-validator` | sonnet | Criar/rodar validações (pandera) numa fonte. |
| `eda-explorer` | opus | Interpretar um dataset novo (grão, leakage, viés). |
| `ml-modeler` | opus | Construir/iterar um pipeline de modelagem correto. |
| `stats-reviewer` | opus | Revisar análise/experimento de forma adversarial. |

## Skills

| Skill | Dispara em |
|---|---|
| `project-scaffold` | "montar o projeto", "estrutura inicial". |
| `eda-report` | "fazer EDA", "explorar os dados". |
| `baseline-model` | "baseline", "modelo simples". |
| `experiment-design` | "teste A/B", "tamanho de amostra". |
| `model-card` | "documentar o modelo", "model card". |
| `data-quality-check` | "validar os dados", "contrato de dados". |

## Commands

`/novo-projeto` · `/eda` · `/baseline` · `/revisar` · `/model-card` · `/handoff` · `/rota`

## O router de modelos

O trabalho não precisa todo do modelo mais caro — mas a parte que decide o
projeto não pode cair no mais barato. O template roteia por **dois eixos**:

    tier = max(esforço, custo do erro)

> Se o erro passa **em silêncio** para o entregável, não é tarefa de Haiku —
> por mais simples que pareça.

É o eixo que importa em dados. Definir o grão de um join são três linhas de
código e é o erro mais caro do projeto; rodar `pytest` e colar a saída é Haiku
mesmo numa base complicada, porque ali o erro aparece na hora.

| Tier | Natureza | Exemplos |
|---|---|---|
| **Haiku** | Mecânico, erro visível na hora | buscar símbolo, rodar teste, contar nulo, extrair schema |
| **Sonnet** | Entender código/dado, resposta verificável | code review, escrever teste, schema pandera, reescrever SQL |
| **Opus** | Julgamento + orquestração | grão, split, leakage, métrica, A/B, handoff |

**Opus é sempre o líder:** ele classifica, decide e despacha. Os agents caros
delegam a parte mecânica — o `eda-explorer` manda o `data-profiler` levantar os
números e gasta o próprio raciocínio interpretando-os. O barato nunca conclui;
o caro nunca conta nulo na mão.

**Como é aplicado.** Duas peças, as duas que funcionam de fato:

- `hooks/routing-reminder.sh`, um hook de `UserPromptSubmit`, injeta a regra
  antes de cada turno. (Só alguns eventos têm o stdout injetado no contexto;
  em `PreToolUse` ele vai para o log de debug e o modelo nunca lê — um hook de
  pré-despacho ali seria um no-op silencioso.)
- `model:` no frontmatter de cada agent, que é declarativo e não depende de hook.

`/rota <tarefa>` mostra a classificação e o despacho **sem executar**, para
conferir o router.

**Para desligar numa sessão:** `export CLAUDE_ROUTER_OFF=1` antes de abrir o
Claude Code. As atribuições de `model:` continuam valendo.

**Trade-off:** `eda-explorer`, `ml-modeler` e `stats-reviewer` eram `inherit` e
agora são `opus` fixo. Antes, abrir a sessão em Sonnet os fazia rodar em Sonnet;
agora custam Opus sempre. É intencional — são justamente aqueles onde o erro é
caro e silencioso.

## Checklist por projeto novo

- [ ] Copiei `CLAUDE.md` + `.gitignore` + `.claude/` para o repo.
- [ ] Preenchi as seções `[EDITAR POR PROJETO]` do `CLAUDE.md`.
- [ ] Comentei no `CLAUDE.md` as rules que **não** se aplicam a este projeto.
- [ ] Rodei `/novo-projeto` e `uv sync && pre-commit install`.
- [ ] Confirmei o **grão** dos dados e a cadeia **negócio → ML → métrica**.
- [ ] Dei `chmod +x .claude/hooks/*.sh` (o bit de execução não sobrevive a cópia
      entre Windows e WSL).

## Personalizar (e controlar custo de contexto)

Todas as 8 rules são importadas no fim do `CLAUDE.md`. Elas são carregadas em toda
sessão — o que é ótimo para consistência, mas custa contexto. Para um projeto que,
por exemplo, não tem ML, **apague** a linha `@.claude/rules/40-…` (ou envolva o
caminho em crase para virar código e não ser importado). Comentário HTML `<!-- -->`
não garante desativar a import. É assim que você mantém o padrão sem pagar por tudo
em todo projeto.

Para preferências pessoais (permissões extras, diretórios adicionais), copie
`settings.local.json.example` para `settings.local.json` — ele é ignorado pelo git e
não afeta o time.

## Ferramentas assumidas

O template pressupõe `uv`, `ruff`, `pytest` (+`pandera`/`pydantic`), `mypy` e
`pre-commit`. Nada é obrigatório para o Claude Code funcionar — mas os comandos e
skills ficam mais fluidos com eles instalados. Ajuste o stack no `CLAUDE.md` se o
seu projeto divergir.

## Referências

- Chip Huyen, _Designing Machine Learning Systems_ / _Projetando Sistemas de Machine Learning_ (O'Reilly / Alta Books, 2022).
- Catherine Nelson, _Software Engineering for Data Scientists_ / _Engenharia de Software para Cientistas de Dados_ (O'Reilly / Novatec, 2024).
