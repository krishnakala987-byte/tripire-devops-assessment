# Tripire DevOps Assessment

## Overview

This repository contains my implementation of the Tripire DevOps assessment.

The objective of this project was not only to provision infrastructure and create a working database, but also to demonstrate how I approach infrastructure design, maintainability, automation, and production-oriented engineering practices.

The solution includes:

- Infrastructure as Code using Terraform
- Modular infrastructure design
- Separate Development and Production environments
- PostgreSQL database schema and seed data
- Query optimization with indexing
- Database backup and restore automation
- GitHub Actions CI workflow for Terraform validation

---

# Project Structure

```
tripire-devops-assessment
│
├── .github/
│   └── workflows/
│       └── terraform.yml
│
├── infra/
│   ├── environments/
│   │   ├── dev/
│   │   └── prod/
│   │
│   └── modules/
│       ├── network/
│       ├── security/
│       ├── alb/
│       ├── ecs/
│       └── rds/
│
├── database/
│   ├── migrations/
│   ├── seeds/
│   └── queries/
│
├── scripts/
│   ├── backup.sh
│   └── restore.sh
│
├── docker-compose.yml
└── README.md
```

---

# Architecture

```
                Internet
                    │
              Application Load Balancer
                    │
             ECS Application Service
                    │
          Private PostgreSQL Database
                    │
               Automated Backups
```

The infrastructure is organized using reusable Terraform modules instead of a single monolithic configuration. This makes the code easier to maintain, reuse, and extend.

---

# Infrastructure

The infrastructure is divided into reusable modules.

## Network Module

Creates

- VPC
- Public Subnets
- Private Subnets
- Internet Gateway
- Route Tables

Keeping networking isolated makes future expansion easier.

---

## Security Module

Creates dedicated security groups for

- ALB
- ECS
- RDS

This separates responsibilities and follows the principle of least privilege.

---

## ALB Module

Creates

- Application Load Balancer
- Target Group
- Listener

The ALB module is isolated because it is commonly reused across multiple services.

---

## ECS Module

Creates

- ECS Cluster
- ECS Service
- Task Definition

The application layer remains independent from networking and database resources.

---

## RDS Module

Creates

- PostgreSQL Instance
- DB Subnet Group
- Parameter configuration

Database configuration is isolated into its own module so future database upgrades can be managed independently.

---

# Environment Separation

Two environments are provided.

```
infra/environments/dev
infra/environments/prod
```

The environments share the same reusable modules while using different configuration values.

Development

- Smaller instance
- Lower storage
- Short backup retention
- Deletion protection disabled

Production

- Larger instance
- Higher storage
- Longer backup retention
- Deletion protection enabled

This approach minimizes code duplication while keeping environments independent.

---

# Terraform Design Decisions

## Modular Design

Instead of placing all resources inside one Terraform file, the infrastructure is split into reusable modules.

Benefits

- Easier maintenance
- Reusability
- Cleaner code
- Easier debugging
- Production-friendly structure

---

## Sensitive Variables

Database passwords are not hardcoded.

Terraform Sensitive Variables are used instead.

```
variable "db_password" {
    type = string
    sensitive = true
}
```

The value is supplied through environment-specific `terraform.tfvars`.

For this assessment I intentionally kept the solution simple.

In a production environment I would typically use AWS Secrets Manager together with IAM roles instead of storing passwords in tfvars.

---

## Backend

The assessment uses a local backend.

```
terraform {}
```

For a production deployment I would migrate the Terraform state to:

- Amazon S3
- DynamoDB state locking

to support team collaboration and state protection.

---

# Database

PostgreSQL is used as the relational database.

Docker Compose is provided to simplify local development.

```
docker compose up -d
```

---

# Database Schema

The project contains two tables.

## hotel_bookings

Stores booking information including

- Booking ID
- Organization ID
- Hotel ID
- City
- Check-in
- Check-out
- Amount
- Status

---

## booking_events

Stores booking lifecycle events.

Each event references a booking using a foreign key.

Example

- Booking Created
- Payment Completed
- Booking Cancelled

This separation follows a common event logging pattern.

---

# Seed Data

Two seed files are included.

```
001_seed_data.sql
```

Creates

- 120 hotel bookings

```
002_seed_booking_events.sql
```

Creates

- 80 booking events

The generated data allows realistic testing and query optimization.

---

# Query Optimization

An index is created on

```
(city, created_at, org_id, status)
```

The provided query demonstrates filtering by

- City
- Date Range

while grouping by

- Organization
- Status

`EXPLAIN ANALYZE` is included to verify query execution.

---

# Backup and Restore

Two automation scripts are provided.

## Backup

```
./scripts/backup.sh
```

Creates a timestamped PostgreSQL backup.

Example

```
backups/hoteldb_YYYYMMDD_HHMMSS.sql
```

---

## Restore

```
./scripts/restore.sh backups/filename.sql
```

The restore script recreates the schema before restoring the dump to avoid duplicate object conflicts.

---

# GitHub Actions

GitHub Actions automatically performs Terraform validation.

Workflow steps

- Terraform Format Check
- Terraform Init
- Terraform Validate
- Terraform Plan

The workflow runs for both

- Development
- Production

This helps catch formatting and infrastructure issues before deployment.

---

# Assumptions

To keep the implementation focused on the assessment, a few practical assumptions were made.

- Local Terraform backend
- Dockerized PostgreSQL
- Single AWS region
- Single RDS instance
- Basic production-ready networking

---

# Future Improvements

If this project were expanded into a production environment, I would add:

- Remote Terraform backend using S3 + DynamoDB
- AWS Secrets Manager
- Multi-AZ RDS deployment
- ECS Auto Scaling
- CloudWatch monitoring
- AWS WAF
- Route53
- ACM TLS certificates
- VPC Flow Logs
- Centralized logging
- Terraform Workspaces
- Terragrunt for multi-account management
- Automated database migrations during deployment
- Security scanning (Checkov, tfsec)
- Cost estimation using Infracost

---

# How to Run

Clone the repository

```
git clone <repository-url>
```

Start PostgreSQL

```
docker compose up -d
```

Run migrations

```
docker exec -i tripire-postgres psql -U postgres -d hoteldb < database/migrations/001_create_tables.sql
```

Run seed data

```
docker exec -i tripire-postgres psql -U postgres -d hoteldb < database/seeds/001_seed_data.sql

docker exec -i tripire-postgres psql -U postgres -d hoteldb < database/seeds/002_seed_booking_events.sql
```

Create indexes

```
docker exec -i tripire-postgres psql -U postgres -d hoteldb < database/queries/001_create_indexes.sql
```

Run optimization query

```
docker exec -i tripire-postgres psql -U postgres -d hoteldb < database/queries/002_query_optimization.sql
```

Run backup

```
./scripts/backup.sh
```

Restore backup

```
./scripts/restore.sh backups/<backup-file>.sql
```

Terraform

Development

```
cd infra/environments/dev

terraform init

terraform validate

terraform plan
```

Production

```
cd infra/environments/prod

terraform init

terraform validate

terraform plan
```

---

# Final Notes

While completing this assessment, I focused on writing infrastructure that is modular, readable, and easy to extend rather than optimizing only for the minimum working solution.

Where appropriate, I intentionally kept the implementation simple for the scope of the assessment while documenting the production-grade improvements I would introduce in a real-world environment.
