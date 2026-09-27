
variable "keycloak_admin_password" {
  description = "Keycloak admin password"
  type        = string
  sensitive   = true
}

variable "keycloak_db_host" {
  description = "Keycloak PostgreSQL RDS endpoint"
  type        = string
}

variable "keycloak_db_user" {
  description = "Keycloak PostgreSQL username"
  type        = string
}

variable "keycloak_db_name" {
  description = "Keycloak PostgreSQL database"
  type        = string
  default     = "keycloak"
}

variable "keycloak_db_password" {
  description = "Keycloak PostgreSQL password"
  type        = string
  sensitive   = true
}
