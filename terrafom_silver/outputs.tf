output "lambdas_info" {
    description = "Map complète des infos Lambda (nom + ARN)"
    value       = {
        for k, mod in module.lambdas :
        k => {
            name = mod.lambda_name
            arn  = mod.lambda_arn
        }
    }
}

output "s3_buckets_info" {
    description = "Map complète des buckets avec nom et ARN"
    value       = {
        for k, mod in module.s3_buckets :
        k => {
            name = mod.bucket_name
            arn  = mod.bucket_arn
        }
    }
}

output "extra_s3_buckets_info" {
    value = {
        for name, mod in module.extra_s3_buckets :
        name => {
            name = mod.bucket_name
            arn  = mod.bucket_arn
        }
    }
}

output "sqs_arns" {
    value = {
        for k, mod in module.sqs_queues :
        k => mod.arn
    }
}