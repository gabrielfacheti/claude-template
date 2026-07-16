---
description: Monta o documento de handoff do projeto para o cliente ou para o próximo time.
---

Monte o documento de **handoff** do projeto, seguindo `70-comunicacao.md`.

Reúna e organize:

1. **Objetivo** do projeto e principais resultados (BLUF — conclusão primeiro).
2. **Como reproduzir:** criar o ambiente (`uv sync`), obter os dados (fonte +
   snapshot), e rodar (`make …`).
3. **Onde estão as coisas:** dados, código, modelo, relatórios.
4. **Premissas e limitações** conhecidas.
5. **O que monitorar** se for para produção (distribution shift, features, métricas).
6. **Decisões-chave** (puxe da seção 8 do `CLAUDE.md`).

Verifique que **nenhum segredo ou PII** vá no documento. Salve em `reports/handoff.md`.
