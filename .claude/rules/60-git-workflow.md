# Git & GitHub — fluxo de trabalho

Base: Nelson cap. 10 (version control, dependências, empacotamento), cap. 12
(automação: pre-commit, GitHub Actions) e cap. 13 (segurança).

## Commits

- Pequenos e **atômicos**: um commit = uma mudança lógica. Facilita revisão e
  reverter.
- Mensagem no **imperativo** e explicando o *porquê*, não só o *o quê*.
  Convenção sugerida (Conventional Commits): `feat:`, `fix:`, `refactor:`,
  `docs:`, `test:`, `chore:`.
- Não misture reformatação em massa com mudança de lógica no mesmo commit.

## Branches & PRs

- `main` protegida e sempre "verde". Trabalho em branch curto: `feat/…`, `fix/…`,
  `exp/…` (experimento).
- Abra **PR** com contexto: objetivo, o que muda, como testar. **Revise seu próprio
  diff antes** de pedir review. Code review é rede de segurança, não formalidade.
- Não reescreva histórico compartilhado (`push --force` em branch de outros = não).

## O que NUNCA entra no git

- **Segredos** (senha, token, chave, `.env`), **dados do cliente** e **PII**. Uma
  vez vazado, rotacione a credencial — remover o commit não basta. (Nelson, cap. 13)
- Dados brutos/pesados, saídas de notebook, artefatos de modelo, ambientes virtuais
  → tudo no `.gitignore` (já incluso no template).

## Automação (pre-commit)

Configure `pre-commit` para rodar automaticamente em cada commit:

- `ruff` (lint + format),
- `nbstripout` (limpa output de notebook),
- `detect-secrets` / `gitleaks` (barra credencial vazando),
- checagens básicas (`end-of-file-fixer`, `trailing-whitespace`, `check-added-large-files`).

Opcional: **GitHub Actions** rodando `ruff` + `pytest` no PR. (Nelson, cap. 12)

## Versionar o entregável

- Marque com **tag/release** a versão que foi apresentada ao cliente
  (`v1-diagnostico`, `v2-modelo-final`). Assim dá para voltar exatamente ao que
  foi entregue.
