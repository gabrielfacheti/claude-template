---
description: Revisa o código alterado (Python/SQL) com foco em correção, data leakage, testes e estilo.
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(ruff:*), Bash(pytest:*), Task
---

Contexto — arquivos alterados:

!`git status --short`

Revise as mudanças acima delegando ao agent **code-reviewer**. Para queries ou
modelos dbt, use também o agent **sql-optimizer**.

Priorize, nesta ordem: **correção & data leakage** → robustez → reprodutibilidade →
testes → estilo. Devolva os achados como **🔴 corrija antes de commitar / 🟡 melhore
/ 🟢 nit**, com arquivo:linha e a correção sugerida.
