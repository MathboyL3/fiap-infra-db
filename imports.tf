# ---------------------------------------------------------------------------
# Import do service Postgres ja existente (criado via API/CLI no bootstrap).
# Assim o Terraform gerencia o que ja esta no ar, sem recriar o banco.
# ---------------------------------------------------------------------------

import {
  to = railway_service.postgres
  id = var.postgres_service_id
}
