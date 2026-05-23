# terraform/aws/variables.tf

variable "aws_region" {
  default = "us-east-1"
}

variable "environment" {
  default = "prod"
}

variable "mysql_password" {
  type      = string
  sensitive = true
}

variable "domain_name" {
  description = "Custom domain for the app (e.g. petcareclinic.com). Used to provision the ACM TLS certificate."
  type        = string
}
