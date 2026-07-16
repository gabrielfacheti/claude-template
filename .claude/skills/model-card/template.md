# Model Card — <nome do modelo>

**Versão:** <v1> · **Data:** <AAAA-MM-DD> · **Autor:** <você> · **Commit:** <hash> · **Seed:** <42>

## 1. Resumo
- **Problema de negócio:** <a decisão que o modelo apoia>
- **Tipo:** <classificação binária | regressão | …>
- **Recomendação:** <usar / usar com ressalvas / não usar ainda>

## 2. Uso pretendido
- **Para quê serve:** <…>
- **Fora de escopo (NÃO usar para):** <…>
- **Usuários / consumidores da predição:** <…>

## 3. Dados
- **Fonte / tabelas:** <…> · **Período:** <…> · **Grão:** <uma linha = …>
- **Tamanho:** <treino / teste> · **Pré-processamento:** <resumo do Pipeline>
- **Vieses conhecidos na amostra:** <…>

## 4. Desempenho
- **Métrica primária:** <ex.: PR-AUC> — **modelo: X** vs. **baseline: Y**
- **Por fatia** (onde o viés aparece):

| Fatia | N | Métrica | vs. baseline |
|---|---|---|---|
| geral |  |  |  |
| <fatia 1> |  |  |  |
| <fatia 2> |  |  |  |

## 5. Limitações & premissas
- <premissa de estabilidade dos dados; risco de distribution shift>
- <features exigidas na inferência e sua disponibilidade>
- <casos em que o modelo erra mais>

## 6. Considerações éticas / fairness
- <desempenho em grupos sensíveis; trade-offs assumidos>
- <dados pessoais / LGPD: como foram tratados>

## 7. Reprodutibilidade & manutenção
- **Como retreinar:** <comando / passos>
- **O que monitorar em produção:** <métricas de modelo, features, distribuição das entradas>
- **Quando reavaliar:** <gatilho de retreino>
