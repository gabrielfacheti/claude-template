#!/usr/bin/env bash
# Hook de UserPromptSubmit — injeta a regra de roteamento antes de cada turno.
#
# Por que UserPromptSubmit e não PreToolUse: só alguns eventos têm o stdout
# injetado no contexto do Claude (UserPromptSubmit, UserPromptExpansion,
# SessionStart, PostModelSwitch). Em PreToolUse o stdout vai para o log de
# debug e o modelo nunca lê — um hook de pré-despacho ali é um no-op silencioso.
#
# Detalhe da rule completa: .claude/rules/80-roteamento.md
# Para desligar numa sessão:  export CLAUDE_ROUTER_OFF=1

set -uo pipefail   # sem -e de propósito: um teste que falha não pode matar o hook

# Escape hatch. Usa if em vez de "[ ... ] && exit 0" porque a forma com && 
# retorna status 1 quando o teste é falso, o que vira "erro de hook" no log.
if [ "${CLAUDE_ROUTER_OFF:-0}" = "1" ]; then
  exit 0
fi

# Em UserPromptSubmit, este stdout entra no contexto do Claude como system
# reminder. Mantido curto porque roda a CADA mensagem — inclusive "ok".
cat <<'EOF'
<roteamento>
Antes de responder, classifique esta mensagem:

A) TRABALHO (código, SQL, pipeline, revisão, debug, refactor)
   → Diga o plano de roteamento antes de agir. Logue cada despacho:
     [Route] <tarefa> → <modelo> (<motivo>)
B) DECISÃO DE DADOS (grão, split, métrica, leakage, causalidade, experimento)
   → NÃO delegue a decisão. Responda em Opus; use Haiku só para coletar fatos.
C) CONVERSA (pergunta rápida, confirmação) → responda direto, sem roteamento.
Na dúvida entre A e B, trate como B.

Tier = max(esforço, custo do erro). Se o erro passa EM SILÊNCIO para o
entregável, não é tarefa de Haiku — por mais simples que pareça.
  Haiku  mecânico, erro visível na hora (buscar, rodar teste, contar nulo)
  Sonnet entender código/dado, resposta verificável (review, teste, SQL)
  Opus   julgamento + orquestração (grão, split, leakage, métrica, handoff)

Opus é sempre o líder. Paralelo exige isolation: "worktree" e nenhum
sobreposição de arquivos entre agents.
</roteamento>
EOF
