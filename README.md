# terraform-ec2

![image](https://github.com/user-attachments/assets/87e3eb40-c112-471e-9a3c-6d661889b844)

# Terraform EC2 Deployment

## Overview

This repository contains Terraform configurations to deploy an **AWS EC2 instance** using Infrastructure as Code (IaC). The setup provisions an EC2 instance with user data scripts for automatic initialization.

## Prerequisites

Before using this Terraform configuration, ensure you have the following:

- **Terraform** installed ([Download Here](https://developer.hashicorp.com/terraform/downloads))
- **AWS CLI** installed and configured ([Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html))
- An **AWS IAM user** with permissions to create EC2 instances

## Installation and Setup

### 1. Clone the Repository

```sh
git clone https://github.com/omkarrajeking/terraform-ec2.git
cd terraform-ec2
```

### 2. Initialize Terraform

```sh
terraform init
```

This command downloads the necessary provider plugins.

### 3. Validate the Configuration

```sh
terraform validate
```

Ensures that the Terraform configuration is correct.

### 4. Plan the Deployment

```sh
terraform plan
```

Generates an execution plan showing the resources that will be created.

### 5. Apply the Configuration

```sh
terraform apply -auto-approve
```

This command deploys the EC2 instance on AWS.

### 6. Retrieve Outputs (If Defined)

```sh
terraform output
```

Displays important details like the EC2 public IP address.

### 7. Destroy the Infrastructure (If Needed)

```sh
terraform destroy -auto-approve
```

This removes all resources created by Terraform.

## Project Structure

```
terraform-ec2/
│── main.tf           # Defines EC2 instance and resources
│── variables.tf      # Defines input variables
│── provider.tf       # Configures AWS provider
│── userdata.sh       # Shell script for instance initialization
│── terraform.tfstate # Terraform state file (auto-generated)
│── .terraform/       # Terraform dependencies (auto-generated)
```


