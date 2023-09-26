variable "AWS_REGION" {
  type    = string
  default = "region"
}

variable "ENVIRONMENT" {
  type = string
  default = "staging"
}

variable "DOMAIN" {
  type = string
  default = "domain"
}

variable "SUBDOMAIN" {
  type = string
  default = "subdomain"
}

variable "ROUTE_NAME" {
  type = string
  default = "graphql"
}

variable "tags" {
  type = map(string)
  default = {
    SERVICE: "Service"
  }
}