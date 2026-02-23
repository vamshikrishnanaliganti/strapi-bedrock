variable "aws_region" {
  default = "us-east-1"
}

variable "app_name" {
  default = "strapi-bedrock"
}

variable "ecr_repo_name" {
  default = "strapi-bedrock"
}

variable "ecs_cluster_name" {
  default = "strapi-bedrock-cluster"
}

variable "ecs_service_name" {
  default = "strapi-bedrock-service"
}

variable "container_port" {
  default = 1337
}

variable "cpu" {
  default = "512"
}

variable "memory" {
  default = "1024"
}

variable "db_name" {
  default = "strapidb"
}

variable "db_username" {
  default = "strapi"
}

variable "db_password" {
  default   = "Strapi1234"
  sensitive = true
}

variable "app_keys" {
  default   = "toBeModified1,toBeModified2"
  sensitive = true
}

variable "api_token_salt" {
  default   = "toBeModified"
  sensitive = true
}

variable "admin_jwt_secret" {
  default   = "toBeModified"
  sensitive = true
}

variable "jwt_secret" {
  default   = "toBeModified"
  sensitive = true
}
