# Code Busters: Road to Silver

## Introduction

This project automates the ingestion of Binance data using its public API and provisions the necessary AWS infrastructure via Terraform. It provides a streamlined pipeline for deploying a fully functional data ingestion system on AWS, making use of services like Lambda, S3, and Secrets Manager.

## Table of Contents

* [Installation](#installation)
* [Usage](#usage)
* [Features](#features)
* [Dependencies](#dependencies)
* [Demo](#demo)

## Installation

Before running the project, ensure you have the following installed:

* [Terraform](https://www.terraform.io/downloads.html)
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

### Setup Steps

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

