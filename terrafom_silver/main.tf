provider "aws" {
    region     = var.AWS_REGION
    access_key = var.AWS_ACCESS_KEY
    secret_key = var.AWS_SECRET_KEY
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
    function_name = "${each.key}-${var.environment}"
    bucket_name   = module.s3_buckets[each.key].bucket_name
    environment   = var.environment
    package_path  = "${path.module}/lambda/lambda_code/${each.key}/package/lambda.zip"
    sqs_arn       = module.sqs_queues[each.key].arn
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
