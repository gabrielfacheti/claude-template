# Princípios — como pensamos um projeto de dados

Base: Huyen, _Designing ML Systems_ (visão de sistema/produto) + Nelson,
_Software Engineering for Data Scientists_ (artesanato de código). Estes são os
princípios que valem para **qualquer** projeto.

## O projeto é iterativo, não uma esteira

Enquadrar o problema → engenharia de dados → desenvolver modelo/análise →
avaliar → aprender e voltar. Espere revisitar etapas anteriores; descobrir na
avaliação que o dado está errado é normal, não é fracasso. (Huyen, cap. 1)

## Requisitos de um bom sistema (adaptados p/ consultoria)

Mesmo numa análise pontual, mire nestes quatro (Huyen, cap. 2):

- **Confiável (reliable):** roda de novo e dá o mesmo resultado; falha de forma
  visível, nunca silenciosa.
- **Escalável (scalable):** aguenta mais dados/mais projetos sem reescrever tudo.
- **Manutenível (maintainable):** outra pessoa (ou você em 3 meses) entende e
  altera sem medo.
- **Adaptável (adaptable):** muda de premissa/feature sem quebrar o resto.

## Negócio primeiro, modelo depois

Sempre exista a cadeia **objetivo de negócio → objetivo de ML/análise → métrica**.
Se você não consegue escrevê-la, o problema ainda não está enquadrado — pare e
enquadre antes de codar. A métrica que decide o sucesso é a de negócio; as de
modelo são proxies. (Huyen, cap. 2)

## Comece simples (e prove que precisa de mais)

Baseline antes de modelo sofisticado; SQL/pandas legível antes de otimizar.
Complexidade só entra quando um baseline honesto mostra que ela vale a pena.
"Make it work, make it right, make it fast" — nessa ordem. (Huyen cap. 6; Nelson cap. 1–2)

## Dado é a parte difícil

A maior parte dos erros vem de dados (grão errado, join que duplica, leakage,
amostra enviesada), não do algoritmo. Desconfie do dado antes de desconfiar do
modelo. Garbage in, garbage out.

## O que é "bom código" (Nelson, cap. 1)

Simples, modular, legível, documentado, robusto e testado. Notebook é para
explorar; lógica que se repete ou que entra no entregável vira função testável
em `src/`. DRY: não copie-e-cole a mesma transformação em três células.

## Decisões viram registro

Toda escolha não-óbvia (descartar uma feature, trocar a métrica, filtrar um
segmento) é registrada — na seção 8 do `CLAUDE.md` ou no PR. Isso evita "por que
mesmo a gente fez isso?" três semanas depois.

## Responsabilidade & sigilo (essencial em consultoria)

Dados do cliente são confidenciais e frequentemente têm PII/LGPD. Nunca cole
segredo ou dado pessoal em código, prompt ou entregável. Avalie viés do modelo
em fatias sensíveis e explicite trade-offs de fairness quando houver. (Huyen, cap. 11)

## Postura do assistente

- Antes de propor solução, confirme o **grão** dos dados e a **cadeia de objetivo**.
- Ao escrever código novo, prefira a opção mais simples que atende ao requisito.
- Ao sugerir um modelo, sempre pergunte/registre: qual é o **baseline** e como
  evitamos **leakage**?
- Diga quando não souber; não invente schema, número ou resultado.
