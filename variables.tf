variable "railway_token" {
  description = "Railway Account/Workspace API token. Preferir via env RAILWAY_TOKEN."
  type        = string
  default     = ""
  sensitive   = true
}

variable "project_id" {
  description = "Identificador do projeto Railway (fiap-fase3)."
  type        = string
  default     = "f32bf7af-1351-47c1-a7ea-e6b260445644"
}

variable "environment_id" {
  description = "Identificador do environment (production)."
  type        = string
  default     = "9d4f8472-1336-4027-9041-bcb0663225e1"
}

variable "postgres_service_id" {
  description = "Identificador do service Postgres gerenciado."
  type        = string
  default     = "3c816a90-f69d-4628-8812-eb3a35e8e014"
}

variable "postgres_application_port" {
  description = "Porta interna do Postgres (aplicacao)."
  type        = number
  default     = 5432
}

variable "postgres_proxy_domain" {
  description = "Dominio publico do TCP proxy do Railway (criado via CLI/API)."
  type        = string
  default     = "gondola.proxy.rlwy.net"
}

variable "postgres_proxy_port" {
  description = "Porta publica do TCP proxy do Railway."
  type        = number
  default     = 11177
}
