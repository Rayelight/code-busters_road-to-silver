resource "aws_sqs_queue" "this" {
    name = "${var.lambda_name}-sqs-${var.environment}"

    visibility_timeout_seconds = 30
}
