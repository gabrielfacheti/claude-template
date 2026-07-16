# SQL & Data Warehouse — padrões

Vale para Snowflake, BigQuery, Redshift, Postgres e modelos dbt. Base conceitual:
Huyen, cap. 3 (fundamentos de engenharia de dados: warehouse vs. lake, batch vs.
stream, OLTP vs. OLAP).

## Legibilidade

- **CTEs em vez de subqueries aninhadas.** Uma CTE por passo lógico, com nome que
  explica a intenção (`stg_orders`, `orders_deduped`, `customer_daily`).
- Palavras-chave em MAIÚSCULO, identificadores em minúsculo; indente consistente.
- **Nada de `SELECT *`** em modelo final ou entregável — liste colunas. `SELECT *`
  só na exploração.

## Correção (onde moram os bugs)

- **Grão primeiro:** antes de qualquer join, saiba "uma linha = o quê" nos dois
  lados. Depois de join, **cheque duplicação** (contagem antes/depois; a chave é
  única mesmo?).
- Joins sempre com `ON` explícito e condição completa; atenção a fan-out (1:N que
  vira N linhas indevidas).
- **NULL** quebra igualdade e agregação silenciosamente: trate com `COALESCE`,
  `IS [NOT] NULL`, e cuidado em `NOT IN`.
- Datas: cuidado com timezone e bordas (`>= início AND < fim`, meia-aberto).
- **Dedup/ranking** com window functions (`ROW_NUMBER() OVER (PARTITION BY … ORDER BY …)`).

## Custo & performance

- Filtre cedo; aproveite **partition/cluster pruning** (não aplique função na
  coluna de partição — mata o pruning).
- Em BigQuery, olhe **bytes escaneados**; em Snowflake, dimensione o warehouse ao
  trabalho. Use `LIMIT`/`TABLESAMPLE` enquanto explora.
- Materialize passos caros reutilizados; não recompute a mesma CTE pesada N vezes.

## Contra o "achismo" de schema

- **Nunca invente nomes de coluna/tabela.** Consulte `INFORMATION_SCHEMA` /
  `information_schema.columns` ou peça o dicionário. Confirme tipos e cardinalidade
  antes de escrever a query final.

## dbt (quando o projeto usar)

- Camadas: **staging** (1:1 com a fonte, renomeia/limpa) → **intermediate**
  (lógica) → **marts** (pronto p/ consumo). Nunca pule direto da fonte pro mart.
- Use `ref()` e `source()`; nada de tabela hardcoded.
- **Testes** em todo modelo: `unique`, `not_null`, `relationships`, `accepted_values`.
  Contrato de dados > confiança cega. (espelha Nelson, cap. 7)
- Modelos **idempotentes**; incremental quando o volume pedir, com chave de
  atualização clara.
- Documente colunas no `schema.yml` — vira o dicionário de dados vivo.

## Reprodutibilidade

- Parametrize janelas de data (não deixe `CURRENT_DATE` solto em modelo que precisa
  ser re-executável); registre o snapshot usado no entregável.
- Toda tabela derivada nasce de SQL versionado, não de edição manual.
