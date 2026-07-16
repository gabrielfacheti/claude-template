---
description: Cria a estrutura padrão de um novo projeto de DS e prepara o ambiente reprodutível.
argument-hint: [nome-do-projeto]
---

Use o skill **project-scaffold** para criar a estrutura de um novo projeto chamado
"$ARGUMENTS" (se vazio, pergunte o nome).

Depois de criar a árvore de pastas e os stubs:

1. Rode `git init` (se ainda não for repositório).
2. Rode `uv sync` e `pre-commit install`.
3. Liste o que foi criado.
4. **Lembre o usuário de editar as seções `[EDITAR POR PROJETO]` do `CLAUDE.md`**
   (projeto & negócio, dados, definição de pronto) antes de começar.
