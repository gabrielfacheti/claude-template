---
description: Gera o model card do modelo treinado a partir dos registros do experimento.
argument-hint: [nome do modelo]
---

Gere o model card para o modelo: **$ARGUMENTS**

Use o skill **model-card**, preenchendo o template a partir dos **registros do
experimento** (params, métricas, seed, versão do dado, commit) — não de memória.

Inclua obrigatoriamente **métricas por fatia** (não só o agregado), a comparação com
o **baseline**, as **limitações** e as **considerações de fairness**. Salve em
`reports/model_card.md`.
