#!/bin/bash

set -e  # Arrêter si erreur

TFVARS_FILE="terraform.tfvars"
LAMBDA_BUILD_SCRIPT="lambda/lambda_code/package_lambda.py"

echo "📦 Packaging Lambda function..."
#python3 "$LAMBDA_BUILD_SCRIPT"

echo "🚀 Initialisation de Terraform..."
terraform init

echo "🔍 Planification..."
terraform plan -var-file="$TFVARS_FILE" -out=tfplan

echo "✅ Application du plan..."
terraform apply tfplan

echo "🎉 Déploiement terminé avec succès !"
