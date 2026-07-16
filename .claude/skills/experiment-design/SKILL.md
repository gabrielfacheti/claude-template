---
name: experiment-design
description: Desenha um experimento ou teste A/B rigoroso — hipótese, unidade de randomização, métrica primária + guardrails, cálculo de tamanho de amostra e poder, e plano de análise, cobrindo as armadilhas (peeking, SRM, múltiplas comparações, efeito novidade). Use quando pedirem "teste A/B", "experimento", "desenhar um teste", "tamanho de amostra" ou "power analysis".
---

# Skill: desenho de experimento / A-B test

Um experimento se ganha ou se perde **no desenho**, antes de coletar o primeiro
dado. Segue `30-analise-estatistica.md` (e Huyen, cap. 9).

## Defina ANTES de rodar

1. **Hipótese:** H0 e H1 explícitas, com direção e efeito mínimo de interesse (MDE)
   que justifique a ação de negócio.
2. **Unidade de randomização:** usuário, sessão, loja? (deve casar com a unidade da
   decisão e evitar contaminação entre grupos).
3. **Métricas:** primária (uma) + **guardrails** (o que não pode piorar) + métricas
   secundárias.
4. **Tamanho de amostra & poder:** calcule antes; fixe a duração (cubra ciclos
   semanais/sazonais).
5. **Plano de análise:** teste, correção de múltiplas comparações, como tratar
   outliers — tudo decidido antes de ver o resultado.

## Cálculo de amostra (exemplo, proporção)

```python
from statsmodels.stats.power import NormalIndPower
from statsmodels.stats.proportion import proportion_effectsize

effect = proportion_effectsize(0.10, 0.12)   # baseline 10% -> MDE 12%
n = NormalIndPower().solve_power(effect_size=effect, alpha=0.05, power=0.8,
                                 ratio=1, alternative="two-sided")
print(f"n por grupo ≈ {n:,.0f}")
```

## Armadilhas (checklist)

- **Peeking:** não pare no primeiro "significativo"; ou use análise sequencial.
- **SRM (sample ratio mismatch):** confira se a divisão planejada bateu; se não, o
  experimento está comprometido.
- **Efeito novidade / aprendizado:** ganhos iniciais podem sumir.
- **Múltiplas comparações:** corrija (Bonferroni/BH) se testar várias métricas.
- **Causalidade:** só afirme com randomização válida; sem ela, é quase-experimento.

## Saída

Um **documento de desenho** (1 página): hipótese, unidade, métricas, n/poder,
duração, plano de análise e riscos. Depois do teste, o **relatório**: efeito,
intervalo de confiança, guardrails, e recomendação de negócio com ressalvas.
