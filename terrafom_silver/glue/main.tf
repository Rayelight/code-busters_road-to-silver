resource "aws_glue_catalog_database" "binance" {
    name = "binance_data"
}

# Shared SerDe config for both tables
locals {
    serde = {
        input_format          = "org.apache.hadoop.mapred.TextInputFormat"
        output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
        serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
    }
}

resource "aws_glue_catalog_table" "tables" {
    for_each = var.tables

    name          = lower(each.key)
    database_name = aws_glue_catalog_database.binance.name
    table_type    = "EXTERNAL_TABLE"

    parameters = {
        "classification" = "csv"
    }

    storage_descriptor {
        location      = "s3://${var.data_bucket}/type=${each.key}/"
        input_format  = local.serde.input_format
        output_format = local.serde.output_format
        compressed    = false

        ser_de_info {
            name                  = "csv"
            serialization_library = local.serde.serialization_library

            parameters = {
                "field.delim"            = ","
                "skip.header.line.count" = "1"
            }
        }

        dynamic "columns" {
        for_each = each.value.columns
        content {
            name = columns.value.name
            type = columns.value.type
        }
    }
    }

    dynamic "partition_keys" {
        for_each = each.value.partitions
        content {
            name = partition_keys.value.name
            type = partition_keys.value.type
        }
    }
}


# Glue Crawler to auto-discover/refresh partitions
resource "aws_iam_role" "glue_crawler_role" {
    name = "glue-crawler-binance"

    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Action = "sts:AssumeRole",
                Effect = "Allow",
                Principal = {
                    Service = "glue.amazonaws.com"
                }
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "glue_s3" {
    role       = aws_iam_role.glue_crawler_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_glue_crawler" "binance_data" {
    for_each = var.tables

    name          = "binance-data-crawler-${each.key}"
    role          = aws_iam_role.glue_crawler_role.arn
    database_name = aws_glue_catalog_database.binance.name

    s3_target {
        path = "s3://${var.data_bucket}/type=${each.key}"
    }

    configuration = jsonencode({
        Version = 1.0,
        CrawlerOutput = {
            Tables = { AddOrUpdateBehavior = "MergeNewColumns" }
            Partitions = { AddOrUpdateBehavior = "InheritFromTable" }
        }
    })

    depends_on = [
        aws_iam_role_policy_attachment.glue_s3
    ]
}
