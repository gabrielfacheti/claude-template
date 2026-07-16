---
name: project-scaffold
description: Cria a estrutura padrão de um novo projeto de ciência de dados — layout src/, data/ imutável, notebooks/, tests/, pyproject com uv, Makefile e pre-commit. Use ao iniciar um projeto novo de consultoria ou quando pedirem para "montar o projeto", "estruturar o repositório", "criar o esqueleto" ou "setup inicial".
---

# Skill: estruturar um novo projeto

Objetivo: em minutos, deixar o projeto reprodutível e no padrão do time. Segue
`50-reprodutibilidade.md` e `60-git-workflow.md`.

## Estrutura alvo

```
<projeto>/
├── CLAUDE.md                 # copiado do template; editar a seção do projeto
├── .claude/                  # copiado do template (rules, agents, skills, commands)
├── README.md                 # como reproduzir (o mais importante)
├── pyproject.toml            # deps + config de ruff/mypy (uv)
├── Makefile                  # alvos: setup, data, features, train, report, test, lint
├── .gitignore                # já incluso no template
├── .pre-commit-config.yaml   # ruff, nbstripout, detect-secrets
├── .env.example              # nomes das variáveis (SEM valores)
├── config/
│   └── config.yaml           # parâmetros do projeto + SEED
├── data/
│   ├── raw/        (.gitkeep) # IMUTÁVEL, read-only, não versionado
│   ├── interim/    (.gitkeep)
│   └── processed/  (.gitkeep)
├── notebooks/                # 01_eda.ipynb, 02_baseline.ipynb … (orquestram)
├── src/
│   ├── __init__.py
│   ├── config.py             # carrega config + expõe SEED
│   ├── data/                 # ingestão e limpeza
│   ├── features/             # engenharia de features
│   ├── models/               # treino e avaliação
│   └── validation/           # schemas pandera
├── reports/
│   └── figures/
└── tests/
    └── test_*.py
```

## Passos

1. Confirme o **nome do projeto** e para onde criar.
2. Crie a árvore acima. Ponha `.gitkeep` nas pastas de dados vazias.
3. Semeie os arquivos-chave (stubs abaixo).
4. Rode `git init`, `uv sync`, `pre-commit install`.
5. Lembre o usuário de **editar as seções `[EDITAR POR PROJETO]` do `CLAUDE.md`**.

## Stubs mínimos

**`config/config.yaml`**
```yaml
seed: 42
paths:
  raw: data/raw
  processed: data/processed
target: null        # nome da coluna alvo (preencher)
```

**`src/config.py`**
```python
from pathlib import Path
import yaml

PROJECT_ROOT = Path(__file__).resolve().parents[1]
CFG = yaml.safe_load((PROJECT_ROOT / "config" / "config.yaml").read_text())
SEED: int = CFG["seed"]
```

**`Makefile`** (alvos que tornam o projeto reproduzível com um comando)
```makefile
setup:   ; uv sync && pre-commit install
lint:    ; uv run ruff check . && uv run ruff format --check .
test:    ; uv run pytest -q
data:    ; uv run python -m src.data.build
features:; uv run python -m src.features.build
train:   ; uv run python -m src.models.train
report:  ; uv run jupyter nbconvert --execute notebooks/*.ipynb --to html --output-dir reports
```

**`pyproject.toml`** — deps + versão do Python. Configure o ruff com
`line-length = 100` para casar com `10-python.md` (o default do ruff é 88).

**`.pre-commit-config.yaml`** — ruff, `nbstripout`, `detect-secrets` e hooks básicos
(ver `60-git-workflow.md`).

**`.env.example`** — só os **nomes** das variáveis (ex.: `SNOWFLAKE_ACCOUNT=`,
`WAREHOUSE_URL=`). O `.env` real fica no `.gitignore`.

> Regra: `data/raw/` é somente leitura. Nunca escreva nem versione dado bruto —
> ele é reconstruído a partir da fonte registrada no `CLAUDE.md`.
