# Terraform Variable Type Constraints - Day 7 Summary

## Overview

This repository contains Day 7 exercises focusing on Terraform variable type constraints. The goal was to learn how different Terraform variable types (string, number, bool, list, set, map, tuple, object) can be used to control configuration, validation, and deployment logic in AWS resources.

Each task demonstrates a specific variable type and how it drives AWS resource configuration and validation.

---

## Tasks & What I Implemented

### Task 1 - `string` (environment, region, bucket_name)

**Variables**

* `environment` (string) - default: `dev`
* `region` (string) - default: `us-east-1`
* `bucket_name` (string) - default: `my-unique-bucket-12345-519`

**Objective**
Use string variables to set the AWS provider region, bucket names, and enforce a naming prefix convention.

**Action**

* Configured `provider "aws"` to use `var.config.region`.
* Created an S3 bucket using `local.fullBucketName = "${var.environment}-${var.bucket_name}"` for naming.
* Applied the `Name` tag to resources using the prefixed name.

---

### Task 2 - `number` (instance_count)

**Variable**

* `instance_count` (number) - default: `2`

**Objective**
Control how many EC2 instances are created using `count`.

**Action**

* Used `count = var.config.instance_count` on the EC2 resource to provision the specified number of instances.

---

### Task 3 - `bool` (monitoring_enabled, associate_public_ip)

**Variables**

* `monitoring_enabled` / `var.config.monitoring` (bool) - default: `true`
* `associate_public_ip` (bool) - default: `true`

**Objective**
Control binary flags on EC2 resources.

**Action**

* Enabled instance monitoring with `monitoring = var.config.monitoring`.
* Determined public IP assignment with `associate_public_ip_address = var.associate_public_ip`.

---

### Task 4 - `list(string)` (cidr_block)

**Variable**

* `cidr_block` (list(string)) - `["10.0.0.0/16", "192.168.0.0/16", "172.16.0.0/12"]`

**Objective**
Use a list for ordered network CIDR definitions.

**Action**

* Created a VPC using `var.cidr_block[0]`.
* Created two subnets using `var.cidr_block[1]` and `var.cidr_block[2]`.

---

### Task 5 - `list(string)` (allowed_vm_types)

**Variable**

* `allowed_vm_types` (list(string)) - `["t2.micro", "t2.small", "t3.micro", "t3.small"]`

**Objective**
Enforce allowed EC2 instance types.

**Action**

* Set `instance_type = var.allowed_vm_types[0]`.
* Added a `lifecycle.precondition` to ensure the instance type is in `var.allowed_vm_types`.

---

### Task 6 - `set(string)` (allowed_regions)

**Variable**

* `allowed_regions` (set(string)) - `["us-east-1","us-west-2","eu-west-1"]`

**Objective**
Validate that deployments only occur in permitted regions.

**Action**

* Added a `validation` block in the `region` variable to restrict deployments to allowed regions.

---

### Task 7 - `map(string)` (tags)

**Variable**

* `tags` (map(string)) - `{ Environment = "dev", Name = "dev-Instance", created_by = "terraform" }`

**Objective**
Propagate metadata and cost tags to resources.

**Action**

* Applied `tags = var.tags` on resources (VPC, EC2, S3).
* Exposed `tags["Name"]` in outputs to reference the resource display name.

---

### Task 8 - `tuple` (ingress_values)

**Variable**

* `ingress_values` (tuple([number, string, number])) - `[443, "tcp", 443]`

**Objective**
Force a strictly typed sequence for security group ingress values.

**Action**

* Created a security group ingress rule:

  * `from_port = var.ingress_values[0]`
  * `ip_protocol = var.ingress_values[1]`
  * `to_port = var.ingress_values[2]`

---

### Task 9 - `object` (config)

**Variable**

* `config` (object) - `{ region = "us-east-1", monitoring = true, instance_count = 1 }`

**Objective**
Group related configuration attributes.

**Action**

* Used `var.config.region` for provider configuration.
* Used `var.config.instance_count` for EC2 count.
* Used `var.config.monitoring` to toggle instance monitoring.

---

### Task 10 - Mixed Types (deployment_summary)

**Objective**
Create an aggregated output summarizing deployment.

**Action**

* Created output `deployment_summary` showing:

  * `environment` (string)
  * `instance_count` (number)
  * `name_tag` (from EC2 tags)

**Example**

```hcl
output "deployment_summary" {
  description = "Summary of the deployment"
  value = {
    environment    = var.environment
    instance_count = var.config.instance_count
    name_tag       = aws_instance.example[0].tags["Name"]
  }
}
```

---

## How to Run / Quick Commands

```bash
terraform init
terraform plan -var='instance_count=2' -var='environment=prod' -var='region=us-west-2'
terraform apply -var='instance_count=2' -auto-approve
```

---

## Notes

* Ensure CIDR sizes are valid for the resources you create.
* Use validation/preconditions to prevent misconfigurations (region restrictions, allowed instance types).
* Index carefully when using lists and tuples.
* Map and object variables help structure metadata and configuration.

---

## Summary

Day 7 exercises gave hands-on practice using Terraform's typed variables to:

* drive provider configuration,
* control counts and booleans,
* validate inputs using lists/sets,
* enforce allowed types and regions,
* and aggregate deployment metadata via outputs.

## Reference
- Terraform AWS Provider Documentation. Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- Terraform Variable Type Constraints Tutorial. Retrieved from https://www.youtube.com/watch?v=gu2oCJ9DQiQ&list=PLl4APkPHzsUXcfBSJDExYR-a4fQiZGmMp&index=8