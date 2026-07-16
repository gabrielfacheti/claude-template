---
description: Estabelece baselines de modelagem (trivial + regra de negócio + modelo simples) antes de partir para modelo complexo.
argument-hint: [target ou descrição do problema]
---

Estabeleça os baselines para: **$ARGUMENTS**

Use o skill **baseline-model** (ou delegue ao agent **ml-modeler**).

Não pule etapas: **split antes do fit**, pré-processamento dentro de um `Pipeline`
(sem leakage), métrica escolhida pelo custo do erro. Entregue a **tabela comparando
dummy · regra de negócio · modelo simples**, por fatia, deixando claro o número que
o modelo final terá de bater.
