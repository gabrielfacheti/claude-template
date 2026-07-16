# Modelagem de ML — padrões

Base: Huyen cap. 5 (feature engineering, **data leakage**), cap. 6 (desenvolvimento
e avaliação offline, baselines, avaliação além da métrica), cap. 8 (distribution
shift) e cap. 9 (teste em produção).

## Split antes de tudo

- Separe **train/validation/test antes** de olhar estatística, escalar ou imputar.
  Qualquer `fit` acontece **só no train**.
- Escolha o split conforme o dado:
  - temporal → **split por tempo** (treina no passado, testa no futuro);
  - entidades repetidas (mesmo cliente em várias linhas) → **GroupKFold** para não
    vazar a mesma entidade entre treino e teste;
  - caso geral → **StratifiedKFold**.
- O **test set é tocado uma vez**, no fim. Se você olhou várias vezes, ele virou
  validation.

## Data leakage — o erro nº 1 (Huyen, cap. 5)

- Nada do **futuro** nem do **target** entra nas features.
- Transformações (scaling, encoding, imputação, seleção de feature) são **ajustadas
  no train** e aplicadas no resto — use `Pipeline`/`ColumnTransformer` do sklearn
  para garantir isso automaticamente e evitar **train-serving skew**.
- Cuidado com features que só existem *depois* do evento que você quer prever.

## Pipeline > passos soltos

- Empacote pré-processamento + modelo num **`sklearn.Pipeline`**. Benefícios: sem
  leakage no CV, mesma transformação no treino e na inferência, um objeto para
  serializar.
- Cross-validation sempre **sobre o pipeline inteiro**, nunca só o estimador.

## Baseline primeiro (Huyen, cap. 6)

- Antes de qualquer modelo, estabeleça o baseline: aleatório, classe majoritária,
  **heurística/regra de negócio atual** e um modelo simples (logistic/linear/árvore).
- O entregável **compara explicitamente** com o baseline. Modelo que não bate a
  regra de negócio atual não vai para produção.

## Métrica alinhada ao negócio

- Escolha a métrica pelo **custo do erro**, não pelo default. Acurácia mente em
  base desbalanceada; pense recall/precision/F/PR-AUC, MAE/MAPE, ou métrica
  monetária. Se probabilidade importa, **calibre** e verifique.

## Avaliação além do número agregado (Huyen, cap. 6)

- **Slice-based evaluation:** meça por fatias que importam ao negócio (região, novo
  vs. recorrente, faixa de valor). Uma média boa esconde subgrupo ruim.
- **Perturbação e invariância:** o modelo é estável a pequenas mudanças? Muda o que
  não deveria mudar a predição?
- **Análise de erro:** olhe os casos errados; costumam revelar leakage, dado sujo
  ou feature faltante.

## Rastreabilidade do experimento

- Registre por rodada: parâmetros, métricas, **versão do dado**, **commit do
  código** e seed. MLflow, ou uma simples tabela/CSV de runs — mas registre.
- Resultado no entregável tem que ser **reproduzível** a partir do run registrado.

## Pense na produção, mesmo numa análise

- As features estão **disponíveis no momento da inferência**? (senão, é leakage
  disfarçado).
- Explicite premissa de estabilidade dos dados e o risco de **distribution shift**;
  sugira o que monitorar se o modelo for para produção. (Huyen, cap. 8)

## Manutenibilidade & responsabilidade

- Prefira o modelo mais **simples/interpretável** que atinge a barra. Interpretabilidade
  é feature, não luxo, em consultoria.
- Avalie **viés** nas fatias sensíveis e explicite trade-offs de fairness. (Huyen, cap. 11)
- Todo modelo entregue vem com **model card** (use o skill `model-card`).
