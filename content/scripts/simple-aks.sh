#!/bin/bash 

# bash script to create a simple AKS cluster with azure cli
: ${CLUSTER_NAME:="myAKSCluster"}
: ${RESOURCE_GROUP:="myResourceGroup"}
: ${LOCATION:="australiaeast"}


group_exists=$(az group exists --name $RESOURCE_GROUP)
if [ "$group_exists" = true ]; then
    echo "Resource group already exists."
else
    # Create the resource group if it does not exist
    az group create --name myResourceGroup --location $LOCATION
fi

# Create an AKS Cluster 
# validate if aks exists
aks_exists=$(az aks show --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME)
if [ "$aks_exists" = true ]; then
		echo "AKS cluster already exists."
else
		# Create the AKS cluster if it does not exist
		az aks create \
    --resource-group $RESOURCE_GROUP \
    --name $CLUSTER_NAME \
    --location $LOCATION \
    --node-count 3 \
    --generate-ssh-keys
fi


# Parsing input arguments (if any)
export INPUT_ARGUMENTS="${@}"
set -u
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    '--cluster-name'|'-n')
      CLUSTER_NAME="$2"
      shift # past argument
      shift # past value
      ;;
    '--resource-group'|'-g')
      RESOURCE_GROUP="$2"
      shift # past argument
      shift # past value
      ;;
    '--location'|'-l')
			LOCATION="$2"
			shift # past argument
			shift # past value
			;;
    '--help'|-h)
      help
      exit 0
      shift # past argument
      shift # past value
      ;;
    *) exit 1
      ;;
  esac
done
