terraform {
  required_version = ">= 1.5"

  required_providers {
    railway = {
      source  = "terraform-community-providers/railway"
      version = "~> 0.6"
    }
  }
}

# O token e lido da variavel de ambiente RAILWAY_TOKEN (nao versionar segredos).
# Alternativamente defina via -var="railway_token=..." ou terraform.tfvars (gitignored).
provider "railway" {
  token = var.railway_token != "" ? var.railway_token : null
}
