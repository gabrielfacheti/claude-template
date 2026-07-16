---
name: eda-report
description: Gera um relatório de EDA estruturado e reproduzível sobre um dataset — grão, qualidade, missingness, distribuições, correlações e alertas de data leakage. Use quando pedirem para "fazer EDA", "explorar os dados", "analisar o dataset", "entender a base" ou "análise exploratória".
---

# Skill: relatório de EDA

Produz uma EDA que **informa decisão**, não só desenha gráfico. Segue
`30-analise-estatistica.md`. Para uma varredura autônoma mais profunda, delegue ao
agent `eda-explorer`.

## Princípios

- **Rode código sobre o dado real.** Nunca escreva estatística de memória.
- **Grão primeiro:** "uma linha = o quê?". Confirme antes de tudo.
- **Procure leakage** desde já: feature "boa demais" que codifica o target/futuro.

## Roteiro

1. **Carregar & fotografar:** shape, dtypes, memória, `head()`.
2. **Grão & unicidade:** a chave candidata é única? duplicatas?
3. **Qualidade:** `df.isna().mean()` por coluna; padrão dos NAs; valores impossíveis;
   cardinalidade das categóricas.
4. **Distribuições:** `describe()` + caudas nas numéricas; top valores nas
   categóricas; cobertura temporal (gaps) se houver data.
5. **Relação com o target** (se existir): sinal/força de cada feature; **cheque
   leakage**.
6. **Correlações** relevantes (sem confundir com causalidade).

## Esqueleto de código

```python
import pandas as pd
df = pd.read_parquet("data/raw/....parquet")   # ajuste a fonte

print(df.shape, "\n", df.dtypes)
print("dup na chave:", df.duplicated(subset=["<chave>"]).sum())
na = df.isna().mean().sort_values(ascending=False)
print(na[na > 0])
display(df.describe(include="all").T)
```

## Saída

- Notebook `notebooks/01_eda.ipynb` (reproduzível) **e** um resumo em Markdown:
  - **Resumo** (o que é, grão, período, saúde) · **tabela de qualidade** ·
    **🚩 riscos** (leakage, viés, grão) · **perguntas em aberto** · **próximos passos**.
- Salve figuras em `reports/figures/` com título afirmativo, eixos rotulados e fonte.
