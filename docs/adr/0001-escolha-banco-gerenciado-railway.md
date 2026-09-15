# ADR-0001 — Banco de dados gerenciado: PostgreSQL no Railway

- **Status:** Aceito
- **Data:** Fase 3
- **Decisores:** Equipe Tech Challenge

## Contexto
A Fase 3 exige um **banco de dados gerenciado** provisionado por **Terraform**, num repositório separado. Na Fase 2 o Postgres rodava **dentro do cluster Kubernetes** (auto-gerenciado), o que não atende "gerenciado". Precisávamos de um Postgres gerenciado de verdade, **sem custo** e provisionável por IaC.

## Opções consideradas
1. **AWS RDS / Aurora** — gerenciado real, free tier 12 meses, mas exige cartão de crédito e risco de cobrança.
2. **Postgres dentro do cluster (auto-gerenciado)** — grátis e local, mas **não** é um banco gerenciado (sem backup/operação pelo provedor) — não atende ao requisito.
3. **Neon / Supabase** — Postgres gerenciado grátis, providers Terraform disponíveis.
4. **Railway Postgres** — Postgres gerenciado com free tier, CLI + API + provider Terraform comunitário; a equipe já possui conta configurada.

## Decisão
Adotar **Railway Postgres** (PostgreSQL 18 gerenciado), provisionado/gerenciado via Terraform (provider `terraform-community-providers/railway`). A app (.NET) e o serviço de autenticação (Bun) consomem a connection string exposta como output.

## Justificativa
- É **gerenciado de verdade** (backup, volume persistente, operação pelo provedor) — diferente de um Postgres auto-hospedado no cluster.
- **Sem custo** (free tier) e **sem cartão** — alinhado ao objetivo de usar nuvem real sem custo relevante.
- **Portável**: connection string e modelo idênticos a RDS/Aurora; migração futura para AWS é trivial.
- A equipe já tem o ecossistema Railway configurado (CLI logado).

## Consequências
- **Positivas:** requisito "banco gerenciado via Terraform" cumprido de forma real e gratuita.
- **Negativas / limitações:**
  - O service Postgres é criado pelo **template oficial** do Railway; o Terraform o **importa** e gerencia (ver ADR-0002 para o tratamento do TCP proxy e dos segredos).
  - Free tier do Railway tem crédito/limite de uso — não manter 24/7 sem necessidade.
