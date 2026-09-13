# ADR-0001 — Banco de dados gerenciado: PostgreSQL no Railway

- **Status:** Aceito
- **Data:** Fase 3
- **Decisores:** Equipe Tech Challenge

## Contexto
A Fase 3 exige um **banco de dados gerenciado** provisionado por **Terraform**, num repositório separado. Na Fase 2 o Postgres rodava **dentro do cluster Kubernetes** (auto-gerenciado), o que não atende "gerenciado". Precisávamos de um Postgres gerenciado de verdade, **sem custo** e provisionável por IaC.

## Opções consideradas
1. **AWS RDS / Aurora** — gerenciado real, free tier 12 meses, mas exige cartão de crédito e risco de cobrança. API Gateway/Lambda já seriam simulados via LocalStack (que **não** tem RDS funcional no tier Community).
2. **LocalStack RDS (mock)** — grátis e local, mas o `aws_db_instance` é **decorativo**: não serve queries reais. Não é "gerenciado" de fato.
3. **Neon / Supabase** — Postgres gerenciado grátis, providers Terraform disponíveis.
4. **Railway Postgres** — Postgres gerenciado com free tier, CLI + API + provider Terraform comunitário; a equipe já possui conta configurada.

## Decisão
Adotar **Railway Postgres** (PostgreSQL 18 gerenciado), provisionado/gerenciado via Terraform (provider `terraform-community-providers/railway`). A app e a Lambda consomem a connection string exposta como output.

## Justificativa
- É **gerenciado de verdade** (backup, volume persistente, operação pelo provedor) — diferente do mock do LocalStack.
- **Sem custo** (free tier) e **sem cartão** — alinhado ao objetivo "local/free simulando cloud".
- **Portável**: connection string e modelo idênticos a RDS/Aurora; migração futura para AWS é trivial.
- A equipe já tem o ecossistema Railway configurado (CLI logado).

## Consequências
- **Positivas:** requisito "banco gerenciado via Terraform" cumprido de forma real e gratuita.
- **Negativas / limitações:**
  - O service Postgres é criado pelo **template oficial** do Railway; o Terraform o **importa** e gerencia (ver ADR-0002 para o tratamento do TCP proxy e dos segredos).
  - Free tier do Railway tem crédito/limite de uso — não manter 24/7 sem necessidade.
