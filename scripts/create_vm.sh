#!/bin/bash

# Variables
INSTANCE_NAME="prefect-agent"
MACHINE_TYPE="e2-micro"
ZONE="europe-west6-a"
SERVICE_ACCOUNT="transit-tracking@transitflow-407821.iam.gserviceaccount.com"


# Create VM
gcloud compute instances create $INSTANCE_NAME \
  --image=ubuntu-2004-focal-v20230104 \
  --image-project=ubuntu-os-cloud \
  --machine-type=$MACHINE_TYPE \
  --zone=$ZONE \
  --service-account=$SERVICE_ACCOUNT

# Output VM information
echo "VM $INSTANCE_NAME created in zone $ZONE."
