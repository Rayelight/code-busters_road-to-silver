variable "bucket_name" {
    description = "Nom du bucket S3 de destination"
    type        = string
}

variable "function_name" {
    description = "Nom de la fonction Lambda"
    type        = string
}

variable "environment" {
    description = "Environnement (ex: dev, prod)"
    type        = string
}

variable "package_path" {
    description = "Path to the .zip package for the lambda"
    type        = string
}

variable "sqs_arn" {
    type        = string
    description = "ARN of the SQS queue connected to this Lambda"

}
