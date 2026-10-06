# CLAUDE.md — Contexto do projeto

> **Como usar:** este arquivo é a memória do projeto para o Claude Code. A cada
> novo projeto de consultoria, **você só edita as seções `[EDITAR POR PROJETO]`**
> abaixo. Tudo que é padrão (estilo de código, estatística, ML, git) mora em
> `.claude/rules/` e é importado no final — não precisa mexer.
>
> Regra de ouro: se uma informação vale para **todos** os projetos, ela vai para
> uma *rule*. Se vale só para **este** projeto, ela fica aqui.

---

## 1. Projeto & negócio  `[EDITAR POR PROJETO]`

- **Cliente / setor:** _<ex.: Varejo — rede de farmácias>_
- **Nome do projeto:** _<ex.: churn-assinatura-2026>_
- **Objetivo de NEGÓCIO:** _<a decisão que o cliente quer tomar, em 1 frase>_
- **Objetivo de ML (ou de análise):** _<como traduzimos o negócio em métrica/modelo>_
- **Pergunta central / decisão que destrava:** _<o que muda na vida do cliente com a resposta>_
- **Stakeholders:** _<quem recebe o entregável e qual o nível técnico deles>_
- **Prazo / marcos:** _<datas e checkpoints>_
- **Fora de escopo:** _<o que explicitamente NÃO vamos fazer nesta fase>_

> Ancoragem (Huyen, cap. 2): sempre conecte **objetivo de negócio → objetivo de
> ML → métrica**. Se não dá para escrever essa cadeia, o projeto ainda não está
> enquadrado. Prefira uma métrica de negócio (receita, custo, retenção) como
> estrela-guia e métricas de modelo como proxy.

## 2. Dados  `[EDITAR POR PROJETO]`

- **Fontes / tabelas principais:** _<schema.tabela, warehouse, ou caminho dos arquivos>_
- **Grão (grain):** _<uma linha = ?>_
- **Período disponível:** _<de … até …>_
- **Volume aproximado:** _<nº de linhas / tamanho>_
- **Sensibilidade / PII:** _<há dados pessoais? LGPD? o que NÃO pode sair do ambiente do cliente>_
- **Como acessar:** _<credenciais em .env, VPN, service account — NUNCA colar segredo aqui>_
- **Dicionário de dados:** _<link ou caminho>_
- **Fatias (slices) que importam:** _<segmentos críticos p/ avaliar o modelo: região, novo vs. recorrente, etc.>_

## 3. Ambiente & stack  `[EDITAR POR PROJETO se divergir do padrão]`

- **Python:** 3.11+ · gerenciador de ambiente: `uv` (fallback: `poetry`)
- **Libs núcleo:** `pandas`/`polars`, `numpy`, `scikit-learn`, `statsmodels`, `matplotlib`/`seaborn`
- **Qualidade:** `ruff` (lint+format), `mypy` (types), `pytest` + `pandera`/`pydantic` (validação de dados)
- **SQL / warehouse:** _<Snowflake | BigQuery | Redshift | Postgres | dbt>_
- **Como rodar o projeto:**
  ```bash
  uv sync                 # instala o ambiente a partir do lockfile
  uv run pytest -q        # roda os testes
  uv run ruff check .     # lint
  ```
- **Comandos que o Claude PODE rodar sem perguntar:** ver `.claude/settings.json`.

## 4. Definição de "pronto" & entregáveis  `[EDITAR POR PROJETO]`

- **Entregável final:** _<notebook-relatório | deck | dashboard | modelo em produção | API>_
- **Critério de aceite:** _<a métrica-alvo e o baseline que ela precisa bater>_
- **Baseline obrigatório:** _<heurística/regra de negócio atual que o modelo TEM que superar>_
- **Reprodutibilidade:** qualquer resultado no entregável precisa sair de `uv run …`
  a partir de código versionado (nada de "roda só na minha máquina").

---

## 5. Como trabalhamos (padrões — não editar por projeto)

Princípios rápidos; o detalhe está nas *rules* importadas abaixo.

1. **Comece simples.** Baseline antes de modelo complexo; SQL/pandas legível antes
   de otimização. (Huyen, cap. 6 · Nelson, cap. 1)
2. **Processo iterativo, não linear.** Enquadrar → dados → modelo → avaliar →
   (voltar). Espere revisitar etapas anteriores. (Huyen, cap. 1–2)
3. **Notebook para explorar, módulo para valer.** Lógica que vai se repetir sai do
   notebook e vira função testável em `src/`. (Nelson, cap. 8)
4. **Data leakage é o inimigo nº 1.** Split antes de qualquer `fit`; nada do futuro
   ou do target vaza para as features. (Huyen, cap. 5)
5. **Todo resultado é reprodutível e versionado.** Seed fixa, ambiente travado,
   dados rastreáveis. (Nelson, cap. 10)
6. **Explique a decisão, não só o número.** O cliente precisa entender o "e daí?".
   (Huyen, cap. 2 · Nelson, cap. 9)
7. **Cada tarefa no seu tier.** Opus lidera e decide; Sonnet executa o que é
   verificável; Haiku faz o mecânico. O critério não é só esforço — é também o
   **custo do erro**: se ele passa em silêncio para o entregável, não é tarefa
   de modelo barato. Ver `80-roteamento.md`.

### Fluxo padrão de um projeto

Use o comando `/novo-projeto` para criar a estrutura de pastas. Depois, o caminho
típico é: `/eda` → definir baseline com `/baseline` → iterar modelo → `/revisar`
antes de entregar → `/model-card` para documentar → `/handoff` para o cliente.
Em dúvida sobre quem deveria fazer uma tarefa, `/rota <tarefa>` mostra a
classificação e o despacho sem executar nada.

---

## 6. Regras importadas

> Estas linhas `@…` carregam as *rules* compartilhadas. Para um projeto mais leve,
> **apague** a linha (ou envolva o caminho em crase, ex.: `` `@.claude/rules/40-modelagem-ml.md` ``)
> das que não se aplicam — assim a import não é carregada e você reduz o custo de
> contexto sem perder o padrão. (Comentário HTML `<!-- -->` não garante desativar a import.)

@.claude/rules/00-principios.md
@.claude/rules/10-python.md
@.claude/rules/20-sql-warehouse.md
@.claude/rules/30-analise-estatistica.md
@.claude/rules/40-modelagem-ml.md
@.claude/rules/50-reprodutibilidade.md
@.claude/rules/60-git-workflow.md
@.claude/rules/70-comunicacao.md
@.claude/rules/80-roteamento.md

---

## 7. Referências de método

- **Chip Huyen — _Designing Machine Learning Systems_ / _Projetando Sistemas de Machine Learning_** (O'Reilly/Alta Books). Ciclo de vida, requisitos de um bom sistema, avaliação, distribution shift, monitoramento.
- **Catherine Nelson — _Software Engineering for Data Scientists_ / _Engenharia de Software para Cientistas de Dados_** (O'Reilly/Novatec). Bom código, testes, logging, empacotamento, do notebook ao sistema.

## 8. Decisões & glossário do projeto  `[EDITAR POR PROJETO]`

> Registre aqui decisões não-óbvias ("por que descartamos a feature X", "por que
> a métrica é recall e não acurácia"). Isso evita retrabalho e vira memória viva.

- _<data — decisão — motivo>_
