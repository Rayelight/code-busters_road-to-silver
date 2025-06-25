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
├── terraform/                       # Root Terraform folder
│   ├── main.tf                      # Entry point for infrastructure deployment
│   │                                # Custom Terraform modules
│   ├── s3/                             # Module for S3 bucket provisioning
│   ├── lambda/                         # Module for Lambda function deployment
│   │   ├── lambda_code/                   # Code packaging for Lambda functions
│   │   │   ├── <lambda_name>/                # Folder for each Lambda
│   │   │   │   ├── lambda_function/             # Folder containing the python code for the lmabda
│   │   │   │   │   ├── handler.py                   # Entry point for the Lambda
│   │   │   │   │   └── other_code.py                # (optional) Additional logic
│   │   │   │   └── package                   # Folder containing the packaged lambda code
│   │   │   │       └── lambda.zip                   # Packaged lambda code
│   │   │   └── package_lambda.py             # Script to package Lambda functions
│   │   └── lambda_layer/                  # Layer packaging for Lambda functions
│   │       ├── outputs/                      # Output folder for Zipped layers
│   │       │   └── <layer_name>.zip             # Zipped layers built by package_layer
│   │       ├── requirements/                 # Requirement folder where layers are defined
│   │       │   └── <layer_name>.txt             # Requirement text files that define layers
│   │       └── build_layer.py                # Script to package Lambda layers
│   ├── glue/                           # Module for AWS Glue configuration
│   ├── sqs/                            # Module for SQS queue setup
│   └── terrafom.sh                     # Bash script to automate setup and deployment
├── request_ingestion.py                # Python program to send messages to the sqs queue to trigger the lambda
└── requirements.txt                    # Project python requirements to run the python codes
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

Two demonstration videos are included in the repository to showcase setup and usage:
* [Final Demo](https://drive.google.com/file/d/1rIIckXCEVtiDnq2Gtg9cAS-QEY_rjsFD/view?usp=sharing)
* [Sound problem Demo](https://drive.google.com/file/d/1pzYa5yELhiTp-3AIGtcpEiHPz1iDMz7B/view?usp=sharing)

