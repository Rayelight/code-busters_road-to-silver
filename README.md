# Code Busters: Road to Silver

## Introduction

This project automates the ingestion of Binance data using its public API and provisions the necessary AWS infrastructure via Terraform. It provides a streamlined pipeline for deploying a fully functional data ingestion system on AWS, making use of services like Lambda, S3, and Secrets Manager.

## Table of Contents

* [Structure](#structure)
* [Installation](#installation)
* [Setup](#setup)
* [Usage](#usage)
* [Features](#features)
* [Dependencies](#dependencies)
* [Demo](#demo)

## Structure


```
.
├── terraform/                  # Root Terraform folder
│   ├── main.tf                 # Entry point for infrastructure deployment
│   └── modules/                # Custom Terraform modules
│       ├── s3/                 # Module for S3 bucket provisioning
│       ├── lambda/             # Module for Lambda function deployment
│       │   ├── lambda_code/    # Code packaging for Lambda functions
│       │   │   ├── <lambda_name>/       # Folder for each Lambda
│       │   │   │   ├── handler.py       # Entry point for the Lambda
│       │   │   │   └── other_code.py    # (optional) Additional logic
│       │   │   └── package_lambda.py    # Script to package Lambda functions
│       │   ├── lambda_layer/   # Layer packaging for Lambda functions
│       │   │   ├── <layer_name>.txt     # Dependencies list for the layer
│       │   │   └── package_layer.py     # Script to package Lambda layers
│       ├── glue/               # Module for AWS Glue configuration
│       └── sqs/                # Module for SQS queue setup
└── deploy.sh                  # Bash script to automate setup and deployment
```

Each Lambda function is defined by its own folder under `lambda_code/`, containing a `handler.py` file.  
Each Lambda layer is defined by a `.txt` file under `lambda_layer/`, listing the Python dependencies for packaging.


## Installation

Before running the project, ensure you have the following installed:

* [Terraform](https://www.terraform.io/downloads.html)
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

### Setup

1. **Store AWS credentials in AWS Secrets Manager**
   Use the provided Bash script to automatically store your AWS credentials securely.

2. **Create a `terraform.tfvars` file** with the following parameters:

   * Schema table definitions
   * Lambda function name
   * Destination S3 bucket name

## Usage

Simply execute the Bash script provided in the repository:

```bash
./deploy.sh
```

This will handle everything:

* Credential setup
* Infrastructure provisioning via Terraform
* Deployment of the ingestion pipeline

## Features

* Automated ingestion of Binance API data
* Fully managed AWS infrastructure with Terraform
* Secrets Manager integration for secure credential storage
* One-command deployment via Bash script

## Dependencies

All required Python packages are listed in `requirements.txt`:

* `boto3`
* `requests`

Install them using:

```bash
pip install -r requirements.txt
```

## Demo

Two demonstration videos are included in the repository to showcase setup and usage.

