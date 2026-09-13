# ---------------------------------------------------------------------------
# fiap-infra-db — Banco de dados gerenciado (Railway Postgres) via Terraform
# ---------------------------------------------------------------------------
# O service Postgres e o projeto fiap-fase3 sao provisionados pelo template
# oficial de Postgres do Railway (imagem ghcr.io/railwayapp-templates/postgres-ssl:18,
# com volume persistente de 5 GB). O Terraform aqui GERENCIA o service Postgres
# (importado) e expoe a connection string como output para os demais repos
# (fiap-app e fiap-auth-lambda).
#
# NOTA (ver ADR-0002): a leitura do TCP proxy via provider community retorna
# "tcpProxies Not Authorized" com o token de conta. O proxy publico e, portanto,
# criado fora do Terraform (CLI/API) e seus dados entram como variaveis
# (proxy_domain / proxy_port). O endpoint interno nao depende de proxy.
# ---------------------------------------------------------------------------

# Service Postgres gerenciado (importado — criado pelo template Railway).
resource "railway_service" "postgres" {
  name       = "Postgres"
  project_id = var.project_id

  source_image = "ghcr.io/railwayapp-templates/postgres-ssl:18"

  volume = {
    name       = "postgres-volume"
    mount_path = "/var/lib/postgresql/data"
  }

  lifecycle {
    ignore_changes = [source_image, regions]
  }
}
