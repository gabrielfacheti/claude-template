---
name: data-quality-check
description: Roda uma checagem de qualidade de dados e cria contratos com pandera sobre a fonte real — nulos, duplicatas, grão, ranges válidos, tipos e consistência. Use ao ingerir uma fonte nova, antes de treinar um modelo, ou quando pedirem "validar os dados", "checar qualidade", "schema de validação" ou "contrato de dados".
---

# Skill: checagem de qualidade de dados

Transforma suposições sobre o dado em **contrato executável** que falha alto quando
a fonte muda. Segue a seção de testes de `10-python.md` e a disciplina de grão de
`20-sql-warehouse.md`. Para uma passada autônoma, delegue ao agent `data-validator`.

## Passos

1. Levante o **grão** esperado e as regras de cada coluna (com o time ou inferindo
   da EDA — depois confirmando).
2. Escreva um **schema `pandera`** codificando tipos, nullability, unicidade da
   chave, ranges/`isin` e relações entre colunas.
3. **Rode** sobre os dados reais e reporte violações (não presuma que passou).
4. Plugue a validação na **ingestão** e **antes do treino** para falhar cedo.

## Esqueleto (pandera)

```python
import pandera.pandas as pa

schema = pa.DataFrameSchema(
    {
        "customer_id": pa.Column(int, nullable=False, unique=True),
        "signup_date": pa.Column("datetime64[ns]", nullable=False),
        "plan":        pa.Column(str, pa.Check.isin(["free", "pro", "enterprise"])),
        "mrr":         pa.Column(float, pa.Check.ge(0), nullable=False),
        "churned":     pa.Column(int, pa.Check.isin([0, 1])),
    },
    strict=False,   # True: reprova colunas inesperadas
    coerce=True,
)

validated = schema.validate(df, lazy=True)  # lazy=True: coleta TODAS as falhas
```

## Saída

- Schema versionável em `src/validation/schemas.py`.
- **Relatório de violações:** o que falhou, quantas linhas, exemplos e causa provável
  (fonte mudou? grão quebrou? bug no ETL?).
- Recomendação de quais checagens viram teste no CI.
