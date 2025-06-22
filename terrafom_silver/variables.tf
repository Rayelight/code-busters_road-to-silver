variable "AWS_ACCESS_KEY" {
  type      = string
  sensitive = true
}

variable "AWS_SECRET_KEY" {
  type      = string
  sensitive = true
}

variable "AWS_REGION" {
  type    = string
  default = "eu-west-3"
}
