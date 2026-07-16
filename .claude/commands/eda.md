---
description: Faz uma EDA estruturada e reproduzível de um dataset ou tabela.
argument-hint: [caminho do arquivo ou schema.tabela]
---

Faça a análise exploratória de: **$ARGUMENTS**

Use o skill **eda-report**. Se a exploração for grande ou aberta, delegue ao agent
**eda-explorer**.

Lembretes: confirme o **grão** antes de tudo, rode código sobre o dado real (não
invente estatística) e sinalize explicitamente qualquer risco de **data leakage** ou
viés de amostra. Entregue o notebook reproduzível + o resumo em Markdown.
