# ADR-0002 — Gestão de segredos e exposição via TCP proxy

- **Status:** Aceito
- **Data:** Fase 3
- **Decisores:** Equipe Tech Challenge

## Contexto
O Postgres gerenciado do Railway:
1. Expõe um endpoint **interno** (`postgres.railway.internal`) acessível apenas de dentro do Railway. App e Lambda rodam **localmente** (LocalStack / K8s local) e precisam de acesso **externo**.
2. Gera a **senha** automaticamente (template). Precisávamos definir como versionar a conexão sem vazar segredo.
3. O provider Terraform comunitário retorna **`tcpProxies Not Authorized`** ao ler o recurso de TCP proxy com token de conta.

## Decisão
1. **Exposição externa:** criar um **TCP proxy** (porta 5432 → `gondola.proxy.rlwy.net:11177`) via CLI/API do Railway, **fora** do Terraform, e referenciá-lo como **variáveis** (`postgres_proxy_domain`, `postgres_proxy_port`) nos outputs. O `railway_service` (Postgres) continua **gerenciado/importado** pelo Terraform.
2. **Segredos:** a **senha nunca é versionada nem exposta** nos outputs. Os outputs entregam *templates* de connection string com o placeholder `${PGPASSWORD}`; a senha é injetada em **runtime** via variável de ambiente / secret (`PGPASSWORD`) — no K8s como Secret, na Lambda como variável, no GitHub Actions como Secret.

## Justificativa
- Mantém o **banco gerenciado pelo Terraform** (import do service) sem esbarrar na limitação de autorização do recurso `railway_tcp_proxy`.
- Segue a boa prática de **não commitar segredos**; a connection string versionada é um *template* inofensivo.
- O proxy é estável (domínio/porta fixos); tratá-lo como variável é aceitável para o escopo do desafio.

## Consequências
- **Positivas:** zero segredo no git; Terraform ainda gerencia o recurso principal (Postgres); outputs prontos para os outros repos.
- **Negativas:** o TCP proxy não é gerenciado por Terraform (criado uma vez via API). Se o domínio/porta mudarem, atualizar as variáveis. Documentado e reproduzível via script.
