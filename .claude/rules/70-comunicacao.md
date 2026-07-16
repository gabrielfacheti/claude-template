# Comunicação & entregáveis

Em consultoria, o valor só existe quando o cliente **entende e age**. Base: Huyen
cap. 2 (traduzir negócio↔ML) e Nelson cap. 9 (documentação).

## Estrutura BLUF (conclusão primeiro)

- Comece pela **recomendação/decisão** e o impacto esperado. Método e detalhe vêm
  depois; o mais técnico vai para apêndice.
- Narrativa padrão: **objetivo de negócio → o que fizemos → o que achamos →
  recomendação → riscos e próximos passos.**
- Ajuste a profundidade ao público: executivo quer o "e daí?"; time técnico quer
  premissas e método.

## Honestidade quantitativa

- Comunique **incerteza** (intervalos, cenários). Evite falsa precisão.
- Não afirme **causalidade** sem desenho que a sustente — use "associado a", e
  liste premissas e limitações abertamente. Um entregável que esconde ressalva
  perde credibilidade no primeiro contraexemplo.

## Visualizações

- Todo gráfico: título que afirma a conclusão, eixos rotulados com **unidade**,
  **fonte** e **data**. Sem "chart junk". Reproduzível a partir do código.
- Reaproveite o skill de visualização quando disponível para manter estilo consistente.

## Higiene do que sai para fora

- **Zero PII/segredo** em entregável externo. Anonimize/agrege antes de compartilhar.
  Confirme com o cliente o que pode sair do ambiente dele.

## Documentação que acompanha (Nelson, cap. 9)

- **README** do projeto: o que é, como reproduzir, onde ficam os dados, limitações
  conhecidas.
- **Docstrings** no código; **model card** para modelos (skill `model-card`);
  **log de decisões** no `CLAUDE.md` (seção 8).

## Handoff

- Ao encerrar/transferir, entregue: como criar o ambiente e obter os dados, como
  rodar (`make …`), premissas, limitações e o que monitorar se for para produção.
  Use o comando `/handoff`.
