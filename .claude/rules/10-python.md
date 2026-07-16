# Python — padrões de código

Base: Nelson, caps. 1–8 (bom código, performance, estruturas de dados, erros/logging,
formatação/linting/types, testes, refatoração).

## Estilo & ferramentas

- **`ruff`** para lint **e** format (substitui black+flake8+isort). Rode
  `ruff check --fix .` e `ruff format .` antes de commitar.
- **PEP 8**, linha ≤ 100 colunas. Nomes descritivos; `snake_case` para
  funções/variáveis, `CapWords` para classes.
- **Type hints** em funções que saem do notebook; cheque com `mypy`. Tipos são
  documentação executável. (Nelson, cap. 6)
- **Docstrings** (estilo NumPy ou Google) em toda função pública: o que faz,
  parâmetros, retorno. (Nelson, cap. 9)

## Estrutura

- Layout `src/`: código reutilizável em módulos importáveis; notebooks só orquestram.
- Funções **curtas e com uma responsabilidade**; prefira funções puras (sem efeito
  colateral) — são testáveis e reaproveitáveis. (Nelson, cap. 4 e 8)
- Sem "número mágico" nem caminho hardcoded: parâmetros em config; caminhos com
  `pathlib.Path`, relativos à raiz do projeto.

## pandas / polars

- **Nunca** confie em indexação encadeada (`df[cond][col] = …`) — use `.loc`.
  Cuidado com `SettingWithCopyWarning`: é sinal de bug, não de ruído.
- Prefira **method chaining** (`.assign`, `.pipe`, `.query`) a reatribuições
  passo a passo; evita estados intermediários e facilita ler o pipeline.
- **Vetorize**: evite `for`/`iterrows`; use operações de coluna. Se precisar
  iterar muito, questione a modelagem. (Nelson, cap. 2–3)
- Defina **dtypes** explicitamente; use `category` para cardinalidade baixa e
  downcast numérico para economizar memória em dados grandes.
- Evite `inplace=True`: atrapalha o method chaining e raramente dá o ganho de
  memória que se imagina.
- Em dados grandes, considere **polars** (lazy) ou processar em chunks.

## Erros & logging

- **Logging, não `print`.** Configure o módulo `logging` (nível, formato); `print`
  só em scripts triviais. (Nelson, cap. 5)
- Falhe cedo e alto: valide entradas no começo da função e levante exceções
  **específicas** (`ValueError`, `KeyError`), não `except:` genérico que engole erro.
- Mensagem de erro diz **o que** deu errado e **como** corrigir.

## Testes (Nelson, cap. 7)

- **`pytest`** com `fixtures` e dados de teste pequenos e versionados.
- Teste a **lógica** (funções de transformação) e os **dados**:
  - **`pandera`** para schema/contratos de DataFrame (tipos, ranges, nullability,
    unicidade).
  - **`pydantic`** para validar configs e payloads de entrada.
- Pipelines de dados: teste de regressão (mesma entrada → mesma saída) e checagens
  de invariantes (nº de linhas, soma, grão).

## Performance (medir antes de otimizar)

- Perfile antes de acelerar: `%timeit`, `cProfile`, `memory_profiler`. Não otimize
  no escuro; a intuição sobre gargalo costuma errar. (Nelson, cap. 2)
- Escolha a estrutura de dados certa (`set` p/ pertencimento, `dict` p/ lookup) —
  Big O importa. (Nelson, cap. 3)

## Aleatoriedade & segredos

- Toda fonte de aleatoriedade recebe `random_state`/`seed` a partir da constante
  central do projeto (ver `50-reprodutibilidade.md`).
- **Nenhum segredo no código.** Credenciais vêm de variáveis de ambiente/`.env`
  (que está no `.gitignore`). (Nelson, cap. 13)
