---
description: Mostra como uma tarefa seria roteada (categoria, tier, agent) sem executá-la.
argument-hint: [descrição da tarefa]
---

Classifique a seguinte tarefa segundo `80-roteamento.md` — **sem executá-la**:

**$ARGUMENTS**

Responda exatamente nesta forma:

1. **Categoria:** A (trabalho) · B (decisão de dados) · C (conversa) — e por quê.
2. **Esforço** (baixo/médio/alto) e **custo do erro** (aparece na hora / passa
   em silêncio), separadamente.
3. **Tier resultante** = max(esforço, custo do erro), com o modelo.
4. **Agent** que faria o trabalho, se houver um que sirva.
5. **Decomposição**, se couber: que parte dá para rebaixar para Haiku (coleta) e
   que parte precisa ficar em Opus (julgamento).
6. **Gates:** precisaria de aprovação antes? há risco de colisão de arquivos com
   algo em andamento? exigiria `isolation: "worktree"`?

Termine com a linha de log que você emitiria:
`[Route] <tarefa> → <modelo> (<motivo>)`

Não comece a tarefa. Este comando serve para eu conferir e depurar o router.
