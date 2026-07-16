---
name: model-card
description: Documenta um modelo treinado num model card padronizado — uso pretendido, dados, métricas (inclusive por fatia), limitações e considerações de fairness. Use ao finalizar um modelo, antes de entregar ao cliente, ou quando pedirem "documentar o modelo", "model card" ou "ficha do modelo".
---

# Skill: model card

Todo modelo entregue vem com uma ficha que qualquer pessoa (técnica ou não) entende.
Segue `40-modelagem-ml.md` e `70-comunicacao.md` (Huyen, cap. 11; Nelson, cap. 9).

## Como usar

1. Preencha o template em `template.md` (nesta pasta) a partir dos **registros do
   experimento** — não de memória. Puxe métricas do run rastreado (params, seed,
   versão do dado, commit).
2. Inclua **métricas por fatia**, não só o agregado — é onde o viés aparece.
3. Seja honesto nas **limitações** e nas condições em que o modelo **não** deve ser
   usado. Isso protege o cliente e a consultoria.
4. Salve como `reports/model_card.md` e versione junto com o modelo.

## Campos que não podem faltar

- **Uso pretendido** e **fora de escopo** (onde não usar).
- **Dados de treino:** fonte, período, grão, pré-processamento, vieses conhecidos.
- **Métricas:** agregadas **e por fatia**, sempre comparadas ao **baseline**.
- **Limitações & premissas:** incluindo risco de distribution shift e o que
  monitorar em produção.
- **Considerações éticas / fairness:** desempenho em grupos sensíveis, trade-offs.
- **Reprodutibilidade:** commit, seed, versão do dado, como retreinar.
