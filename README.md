# Terraform Variable Type Constraints — Day 7 Summary

## Overview
This repository contains Day 7 exercises focusing on Terraform variable type constraints. The goal was to learn how different Terraform variable types (string, number, bool, list, set, map, tuple, object) can be used to control configuration, validation, and deployment logic in AWS resources.

Each task demonstrates a specific variable type and how it drives AWS resource configuration and validation.

---

## Tasks & What I Implemented

### Task 1 — `string` (environment, region)
**Variables**
- `environment` (string) — default: `dev`
- `region` (string) — default: `us-east-1`

**Objective**
Use string variables to set the AWS provider region and to enforce a naming prefix convention.

**Action**
- Configured `provider "aws"` to use the `region` variable.
- Created an S3 bucket using `environment` as the required prefix: `"{var.environment}-resource-name"`.

---

### Task 2 — `number` (instance_count)
**Variable**
- `instance_count` (number)

**Objective**
Control how many EC2 instances are created using `count`.

**Action**
- Used `count = var.instance_count` on the EC2 resource so Terraform provisions exactly the specified number.

---

### Task 3 — `bool` (monitoring_enabled, associate_public_ip)
**Variables**
- `monitoring_enabled` (bool) — default: `true`
- `associate_public_ip` (bool) — default: `true`

**Objective**
Control binary flags on resources.

**Action**
- Passed `monitoring = var.monitoring_enabled` (or equivalent provider/ec2 attribute) to enable/disable monitoring.
- Used `associate_public_ip_address = var.associate_public_ip` to determine public IP assignment.

---

### Task 4 — `list(string)` (cidr_block)
**Variable**
- `cidr_block` (list(string)) — `["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]`

**Objective**
Use a list for ordered network CIDR definitions.

**Action**
- Created a VPC using `var.cidr_block[0]` (10.0.0.0/8).
- Created two subnets using `var.cidr_block[1]` and `var.cidr_block[2]`.

**Note**
The first element is used for VPC CIDR; the next elements are used for subnets.

---

### Task 5 — `list(string)` (allowed_vm_types)
**Variable**
- `allowed_vm_types` (list(string)) — `["t2.micro","t2.small","t3.micro","t3.small"]`

**Objective**
Enforce allowed instance types.

**Action**
- Selected `instance_type = "t2.micro"`.
- Implemented a precondition/validation that ensures the chosen instance type exists in `var.allowed_vm_types`, failing the plan otherwise.

---

### Task 6 — `set(string)` (allowed_region)
**Variable**
- `allowed_region` (set(string)) — `["us-east-1","us-west-2","eu-west-1"]`

**Objective**
Validate that deployments only occur in permitted regions.

**Action**
- Used a `validation` block or expression with `contains(var.allowed_region, var.region)` to prevent invalid region choices.

---

### Task 7 — `map(string)` (tags)
**Variable**
- `tags` (map(string)) — `{ Environment = "dev", Name = "dev-Instance", created_by = "terraform" }`

**Objective**
Propagate metadata and cost tags to resources.

**Action**
- Applied `tags = var.tags` on resources (e.g., VPC).
- Added an output exposing `tags["Name"]` as the resource display name.

---

### Task 8 — `tuple` (ingress_values)
**Variable**
- `ingress_values` (tuple([number, string, number])) — `[443, "tcp", 443]`

**Objective**
Force a strict typed sequence for security group ingress values.

**Action**
- Created an AWS Security Group ingress rule using:
  - `from_port  = var.ingress_values[0]`
  - `protocol   = var.ingress_values[1]`
  - `to_port    = var.ingress_values[2]`

---

### Task 9 — `object` (config)
**Variable**
- `config` (object) — `{ region = "us-east-1", monitoring = true, instance_count = 1 }`

**Objective**
Group related configuration attributes.

**Action**
- Used `var.config.region` to set provider region.
- Used `var.config.instance_count` for the EC2 `count`.
- Used `var.config.monitoring` to toggle instance monitoring.

---

### Task 10 — Mixed Types (deployment_summary)
**Objective**
Create an aggregated output summarizing deployment.

**Action**
- Created output `deployment_summary` that displays:
  - `environment` (string)
  - `instance_count` (number)
  - `tags["Name"]` (map value)

**Example**
```hcl
output "deployment_summary" {
  description = "Summary of the deployment"
  value = {
    environment    = var.environment
    instance_count = var.config.instance_count
    name_tag = aws_instance.example[0].tags["Name"]
  }
}
```
---

## How to run / quick commands
1. `terraform init`
2. `terraform plan -var='instance_count=2' -var='environment=prod' -var='region=us-west-2'`
3. `terraform apply -var='instance_count=2' -auto-approve'`

---

## Notes & Gotchas
- Ensure CIDR sizes are valid for the resource you're creating (e.g., VPC requires a valid network with correct mask size).
- Validation/preconditions help prevent misconfiguration (region restrictions, allowed instance types).
- When using lists and tuples, index carefully to avoid out-of-range errors.
- Map and object variables are useful for metadata and structured config, respectively.

---

## Summary
This Day 7 exercise gave hands-on practice using Terraform's typed variables to:
- drive provider configuration,
- control counts and booleans,
- validate inputs with sets/lists,
- and aggregate deployment metadata using maps and outputs.

If you want, I can also:
- generate a complete `main.tf` example implementing all tasks,
- or create a ZIP with example `.tf` files alongside this README.
