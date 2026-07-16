---
name: baseline-model
description: Estabelece baselines honestos antes de qualquer modelo complexo — classe majoritária / heurística de negócio + modelo simples, com split correto e sem leakage. Use ao começar a modelar ou quando pedirem "baseline", "modelo simples", "ponto de partida" ou "benchmark inicial".
---

# Skill: baseline de modelagem

Antes de gradient boosting ou rede neural: **prove que o simples não basta.** Segue
`40-modelagem-ml.md`. O número do baseline é o que todo modelo futuro precisa bater.

## Passos

1. **Enquadre:** target, métrica (pelo custo do erro) e a **regra de negócio atual**
   — ela é o baseline mais importante a superar.
2. **Split antes de tudo** (temporal / GroupKFold / StratifiedKFold conforme o dado).
3. **Baselines, em ordem:**
   - trivial (`DummyClassifier`/`DummyRegressor`: majoritário, média);
   - **heurística de negócio** (regra atual do cliente);
   - modelo linear/árvore simples **dentro de um `Pipeline`**.
4. **Avalie** contra a métrica escolhida e **por fatias** de negócio.
5. Registre params, métrica, versão do dado, seed.

## Esqueleto

```python
from sklearn.model_selection import train_test_split
from sklearn.pipeline import Pipeline
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.linear_model import LogisticRegression
from sklearn.dummy import DummyClassifier
from src.config import SEED

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, stratify=y, random_state=SEED
)

dummy = DummyClassifier(strategy="most_frequent").fit(X_train, y_train)

pre = ColumnTransformer([
    ("num", StandardScaler(), num_cols),
    ("cat", OneHotEncoder(handle_unknown="ignore"), cat_cols),
])
simple = Pipeline([("pre", pre),
                   ("clf", LogisticRegression(max_iter=1000, random_state=SEED))])
simple.fit(X_train, y_train)
```

## Saída

Uma **tabela** comparando: dummy · regra de negócio · modelo simples — na métrica
escolhida e por fatia. Deixe explícito o número que o modelo final terá que bater.
Nada de partir para modelo complexo sem essa tabela na mão.
