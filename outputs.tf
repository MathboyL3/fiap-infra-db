# ---------------------------------------------------------------------------
# Outputs consumidos pelos repos fiap-app e fiap-auth-lambda.
# A SENHA nao e exposta aqui de proposito: ela e injetada em runtime via
# secret/variavel de ambiente (PGPASSWORD) — ver README e ADR-0002.
# ---------------------------------------------------------------------------

output "postgres_service_id" {
  description = "Identificador do service Postgres gerenciado."
  value       = railway_service.postgres.id
}

output "postgres_host" {
  description = "Host publico do Postgres (via TCP proxy do Railway)."
  value       = var.postgres_proxy_domain
}

output "postgres_port" {
  description = "Porta publica do Postgres (via TCP proxy do Railway)."
  value       = var.postgres_proxy_port
}

output "postgres_internal_host" {
  description = "Host interno do Postgres (para workloads dentro do Railway)."
  value       = "postgres.railway.internal"
}

output "postgres_database" {
  description = "Nome do banco padrao."
  value       = "railway"
}

output "postgres_username" {
  description = "Usuario do banco."
  value       = "postgres"
}

# Connection string SEM a senha (a senha entra via env PGPASSWORD em runtime).
output "dotnet_connection_string_template" {
  description = "Template de ConnectionStrings:Postgres (.NET/Npgsql). Injete a senha via env."
  value = format(
    "Host=%s;Port=%d;Database=railway;Username=postgres;Password=$${PGPASSWORD};SSL Mode=Prefer;Trust Server Certificate=true",
    var.postgres_proxy_domain,
    var.postgres_proxy_port,
  )
}

output "database_url_template" {
  description = "Template de DATABASE_URL (libpq/node). Injete a senha via env PGPASSWORD."
  value = format(
    "postgresql://postgres:$${PGPASSWORD}@%s:%d/railway",
    var.postgres_proxy_domain,
    var.postgres_proxy_port,
  )
}
