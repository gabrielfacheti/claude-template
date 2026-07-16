# Reprodutibilidade & ambiente

"Roda só na minha máquina" não é entregável. Base: Nelson cap. 10 (versionamento,
dependências, empacotamento) + a exigência de confiabilidade da Huyen (cap. 2).

## Ambiente travado

- **`uv`** (ou `poetry`) com **lockfile commitado**. Dependências pinadas; nada de
  `pip install` avulso sem registrar no projeto.
- Python version declarada (`.python-version` / `pyproject.toml`).
- Ninguém instala pacote "na mão" no ambiente compartilhado sem atualizar o lock.

## Seeds centralizadas

- Uma constante **`SEED`** no config do projeto. Propague para `numpy`
  (`np.random.default_rng(SEED)`), `random`, `PYTHONHASHSEED` e todo `random_state`
  do sklearn. Resultado estocástico sem seed é bug de reprodutibilidade.

## Dados: raw é imutável

- `data/raw/` é **somente leitura** — nunca sobrescreva a fonte. O fluxo é
  `raw → interim → processed` via **script versionado**, não edição manual.
- Registre a **proveniência**: query de origem, data do snapshot, contagem de
  linhas e (quando fizer sentido) hash do arquivo. Assim dá para provar de onde
  veio cada número.

## Pipeline determinístico

- Do dado bruto ao resultado, tudo sai de código: um comando reconstrói o output.
  Prefira um **`Makefile`** (ou task runner) com alvos `data`, `features`, `train`,
  `report`.
- Parâmetros em **arquivo de config** (não espalhados como constantes no meio do
  código). Caminhos via `pathlib`, relativos à raiz — nunca `/home/gabriel/...`.

## Notebooks reproduzíveis

- Notebook numerado e nomeado (`01_eda.ipynb`, `02_baseline.ipynb`). Lógica pesada
  mora em `src/` e é **importada**; o notebook orquestra e conta a história.
- **Limpe os outputs antes de commitar** (`nbstripout` no pre-commit) ou versione
  com `jupytext`. Diff de notebook com output binário é impossível de revisar.

## Checagem rápida ("passaria no teste do colega?")

Outra pessoa clona o repo e consegue, só com o README: criar o ambiente, obter os
dados, e rodar `make report` para reproduzir o entregável. Se não, falta
reprodutibilidade.
