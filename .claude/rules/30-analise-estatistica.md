# Análise & Estatística — rigor

Base: Huyen cap. 4 (dados de treino, amostragem, desbalanceamento) e cap. 9
(teste em produção / experimentação). Objetivo: conclusões que se sustentam.

## EDA com disciplina

- Antes de qualquer gráfico bonito: confirme **grão**, **período**, **missingness**
  (padrão dos NAs — aleatório ou sistemático?) e **distribuições** (cauda, outliers).
- Procure **leakage** já na EDA: alguma feature "boa demais" que na verdade codifica
  o target ou o futuro? (liga com `40-modelagem-ml.md`)
- Cheque **base rates** e **Simpson's paradox**: um agregado pode inverter dentro
  de segmentos.

## Amostragem & viés (Huyen, cap. 4)

- A amostra representa a população da decisão? Cuidado com survivorship,
  selection e sampling bias. Documente como os dados foram coletados/filtrados.
- Desbalanceamento de classe muda métrica e estratégia — trate conscientemente
  (não jogue SMOTE por reflexo; entenda o custo do erro primeiro).

## Correlação ≠ causação

- Sem desenho causal (experimento, quase-experimento), fale em **associação**, não
  em "X causa Y". Liste **confounders** plausíveis. Não sugira ação causal a partir
  de correlação observacional sem ressalva explícita.

## Testes de hipótese

- Declare **H0/H1 antes** de olhar o resultado. Escolha o teste e **cheque as
  premissas** (normalidade, variância, independência).
- Reporte **tamanho de efeito** e **intervalo de confiança**, não só o p-valor. Um
  p<0,05 com efeito irrelevante não é achado de negócio.
- Corrija **múltiplas comparações** (Bonferroni/BH) quando testar muitas hipóteses.

## Experimentação / A-B testing (Huyen, cap. 9)

- Defina **unidade de randomização** (usuário? sessão?) e **poder/tamanho de
  amostra ANTES** de rodar. Fixe a duração.
- Escolha métrica primária + **métricas-guardrail** (o que não pode piorar).
- Evite **peeking** (olhar o p-valor todo dia e parar no primeiro "significativo");
  isso infla falso-positivo. Use análise sequencial se precisar espiar.
- Cheque **SRM** (sample ratio mismatch) — se a divisão 50/50 não bateu, o
  experimento está comprometido. Considere efeito novidade.

## Comunicar incerteza

- Sempre acompanhe estimativas de intervalo/uncertainty. Evite falsa precisão
  ("R$ 1.234.567,89" quando o modelo erra 20%). Explicite premissas e limitações.

## Postura

- Prefira métodos simples e bem entendidos a sofisticação que ninguém consegue
  auditar. Se usar algo avançado, explique o porquê e valide as premissas.
