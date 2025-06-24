variable "lambda_name" {
    type        = string
    description = "Nom de la Lambda liée à cette queue"
}

variable "environment" {
    type        = string
    description = "Environnement (ex: dev, prod)"
}
