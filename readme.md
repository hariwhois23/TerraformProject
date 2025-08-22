# AWS Infrastructure with Terraform

A modular Terraform project that deploys a complete AWS infrastructure including VPC, Security Groups, EC2 instances, and Application Load Balancer with automated CI/CD pipeline.

##  Architecture Overview

This project creates a robust, scalable AWS infrastructure using a modular approach:

```
AWS Cloud Environment
    ╔══════════════════════════════════════════════════════════════════╗
    ║                            VPC Module                            ║
    ║  Creates: VPC + Subnets + Internet Gateway + Route Tables        ║
    ║                                                                  ║
    ║    ┌─────────────────────┐        ┌─────────────────────┐        ║
    ║    │   Public Subnet     │        │   PublicSubnet 2    │        ║
    ║    │   10.0.1.0/24       │        │   10.0.2.0/24       │        ║
    ║    │                     │        │                     │        ║
    ║    └─────────────────────┘        └─────────────────────┘        ║
    ╚══════════════════════════════════════════════════════════════════╝
                                    │
                                    │ (provides vpc_id, subnet_ids)
                                    ▼
    ╔══════════════════════════════════════════════════════════════════╗
    ║                      Security Groups Module                      ║
    ║  Creates: Security Groups with Ingress/Egress Rules              ║
    ║  Dependencies: vpc_id from VPC module                            ║
    ╚══════════════════════════════════════════════════════════════════╝
                                    │
                                    │ (provides sg_id)
                    ┌───────────────┼───────────────┐
                    │                               │
                    ▼                               ▼
    ┌──────────────────────────┐              ┌─────────────────────────┐
    │       EC2 Module         │              │       ALB Module        │
    │  Creates: EC2 Instances  │              │  Creates: Load Balancer │
    │                          │              │          Target Groups  │
    │  Dependencies:           │◄─────────────┤          Listeners      │
    │  • sg_id (from SG)       │ (instances)  │                         │
    │  • subnets (from VPC)    │              │  Dependencies:          │
    │                          │              │  • sg_id (from SG)      │
    │  ┌─────────┐ ┌─────────┐ │              │  • subnets (from VPC)   │
    │  │   EC2   │ │   EC2   │ │              │  • vpc_id (from VPC)    │
    │  │Instance1│ │Instance2│ │              │  • instances (from EC2) │
    │  └─────────┘ └─────────┘ │              └─────────────────────────┘
    └──────────────────────────┘

```

##  Project Structure

```
.
├── .github/
│   └── workflows/
│       └── deployment.yml and 
            readme.md              # CI/CD Pipeline
├── Terraform-VPC/
│   ├── main.tf                    # Root module configuration
│   ├── variables.tf               # Input variables
│   ├── outputs.tf                 # Output values
│   ├── terraform.tfvars           # Variable values
│   └── modules/
│       ├── VPC/
│       │   ├── main.tf            # VPC, subnets, IGW, route tables
│       │   ├── variables.tf
│       │   └── outputs.tf
│       ├── SG/
│       │   ├── main.tf            # Security group rules
│       │   ├── variables.tf
│       │   └── outputs.tf
│       ├── EC2/
│       │   ├── main.tf            # EC2 instances configuration
│       │   ├── variables.tf
│       │   └── outputs.tf
│       └── ALB/
│           ├── main.tf            # Application Load Balancer
│           ├── variables.tf
│           └── outputs.tf
└── README.md
```

##  Getting Started

### Prerequisites
- AWS CLI configured with appropriate permissions
- Terraform >= 1.0 installed locally
- GitHub repository with secrets configured

### Required AWS Permissions
Your AWS credentials need the following permissions:
- EC2 (VPC, instances, security groups)
- Elastic Load Balancing
- IAM (for instance profiles, if used)

### Local Development Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd <repository-name>
   ```

2. **Configure variables**
   ```bash
   cd Terraform-VPC
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

3. **Initialize and deploy**
   ```bash
   terraform init
   terraform validate
   terraform plan
   terraform apply
   ```

