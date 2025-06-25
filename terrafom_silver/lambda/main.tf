resource "aws_iam_role" "lambda_exec_role" {
    name = "${var.function_name}-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Action = "sts:AssumeRole",
                Effect = "Allow",
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            }
        ]
    })
}

resource "aws_iam_policy" "lambda_s3_access" {
    name = "${var.function_name}-s3-access"
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "s3:PutObject",
                    "s3:PutObjectAcl"
                ]
                Resource = "arn:aws:s3:::${var.bucket_name}/*"
            }
        ]
    })
}

resource "aws_iam_policy" "lambda_sqs_access" {
    name = "${var.function_name}-sqs-access"

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow",
                Action = [
                    "sqs:ReceiveMessage",
                    "sqs:DeleteMessage",
                    "sqs:GetQueueAttributes"
                ],
                Resource = var.sqs_arn
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "lambda_s3_access" {
    role       = aws_iam_role.lambda_exec_role.name
    policy_arn = aws_iam_policy.lambda_s3_access.arn
}


resource "aws_iam_policy_attachment" "lambda_policy" {
    name       = "${var.function_name}-policy"
    roles = [aws_iam_role.lambda_exec_role.name]
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_sqs_access" {
    role       = aws_iam_role.lambda_exec_role.name
    policy_arn = aws_iam_policy.lambda_sqs_access.arn
}

resource "aws_lambda_function" "this" {
    function_name = "${var.function_name}-${var.environment}"
    role          = aws_iam_role.lambda_exec_role.arn
    runtime       = "python3.11"
    handler       = "handler.lambda_handler"
    timeout       = 30

    filename = var.package_path
    source_code_hash = filebase64sha256(var.package_path)

    layers = [for k, v in aws_lambda_layer_version.layers: v.arn]
    publish = false

    environment {
        variables = {
            BUCKET_NAME = var.bucket_name
            ENVIRONMENT = var.environment
        }
    }

    depends_on = [
        aws_iam_policy_attachment.lambda_policy,
        aws_iam_role_policy_attachment.lambda_s3_access,
        aws_iam_role_policy_attachment.lambda_sqs_access
    ]
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
    event_source_arn = var.sqs_arn
    function_name    = aws_lambda_function.this.arn
    batch_size       = 1
}


resource "aws_lambda_layer_version" "layers" {
    for_each = toset(var.lambda_layers)
    filename   = "${path.module}/lambda_layer/output/${each.key}_layer.zip"
    layer_name = each.key
    compatible_runtimes = ["python3.11"]
}
