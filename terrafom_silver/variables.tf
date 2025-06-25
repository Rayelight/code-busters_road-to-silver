variable "AWS_REGION" {
    type    = string
    default = "eu-west-3"
}

variable "environment" {
    description = "The deployment environment (e.g. dev, prod)"
    type        = string
    default     = "dev"
}

variable "extra_buckets" {
    type = list(string)
    description = "Liste de buckets S3 simples (non liés aux lambdas)"
    default = []
}

variable "lambdas" {
    type = map(string)
    description = "Map des lambdas et des noms de buckets associés"
}

variable "glue_tables" {
    type = map(object({
        columns = list(object({
            name = string
            type = string
        }))
        partitions = list(object({
            name = string
            type = string
        }))
    }))
}