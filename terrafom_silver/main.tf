provider "aws" {
    region = var.AWS_REGION
}

module "s3_buckets" {
    for_each    = var.lambdas
    source      = "./s3"
    bucket_name = "${each.value}-${var.environment}"
    environment = var.environment
}


module "lambdas" {
    for_each      = var.lambdas
    source        = "./lambda"
    function_name = each.key
    bucket_name   = module.s3_buckets[each.key].bucket_name
    environment   = var.environment
    package_path  = "${path.module}/lambda/lambda_code/${each.key}/package/lambda.zip"
    sqs_arn       = module.sqs_queues[each.key].arn
    lambda_layers = ["base"]
}

module "extra_s3_buckets" {
    for_each = toset(var.extra_buckets)
    source      = "./s3"
    bucket_name = "${each.key}-${var.environment}"
    environment = var.environment
}

module "sqs_queues" {
    source   = "./sqs"
    for_each = var.lambdas

    lambda_name = each.key
    environment = var.environment
}

module "glue_tables" {
    source      = "./glue"
    tables      = var.glue_tables
    data_bucket = "ingested-dev"
}

resource "aws_s3_bucket" "athena_results" {
    bucket        = "athena-query-results-ingested-${var.environment}"
    force_destroy = true

    tags = {
        Name        = "Athena Query Results"
        Environment = var.environment
    }
}

resource "aws_athena_workgroup" "this" {
    name = "athena-workgroup-${var.environment}"

    configuration {
        enforce_workgroup_configuration = true

        result_configuration {
            output_location = "s3://${aws_s3_bucket.athena_results.bucket}/results/"
        }
    }

    state = "ENABLED"

    tags = {
        Environment = var.environment
    }
}