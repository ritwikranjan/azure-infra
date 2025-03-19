#!/bin/bash

# Variables
RESOURCE_GROUP_NAME=$1
CLUSTER_NAME=$2
LOCATION=$3

# Generate a random name if CLUSTER_NAME is not provided
if [ -z "$CLUSTER_NAME" ]; then
  GITHUB_USERNAME=$(git config user.name)
  RANDOM_STRING=$(openssl rand -hex 3)
  CLUSTER_NAME="${GITHUB_USERNAME}-${RANDOM_STRING}"
fi

# Create a resource group
echo "Creating resource group: $RESOURCE_GROUP_NAME"
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# Create an AKS cluster
echo "Creating AKS cluster: $CLUSTER_NAME"
az aks create --resource-group $RESOURCE_GROUP_NAME --name $CLUSTER_NAME --node-count 1 --enable-addons monitoring --generate-ssh-keys

# Get credentials for the AKS cluster
echo "Getting credentials for AKS cluster: $CLUSTER_NAME"
az aks get-credentials --resource-group $RESOURCE_GROUP_NAME --name $CLUSTER_NAME

echo "AKS cluster $CLUSTER_NAME created and credentials obtained."
