# Infrastructure

## Overview

![alt text](./docs/images/infrastructure.png)

This repository contains the infrastructure for static websites hosted on AWS.

Uses the following services:

- [AWS S3](https://aws.amazon.com/s3/): For storing the static website content.
- [AWS CloudFront](https://aws.amazon.com/cloudfront/): For serving the static website content.
- [AWS Route 53](https://aws.amazon.com/route53/): For managing the DNS records for the domain.
- [AWS Certificate Manager](https://aws.amazon.com/certificate-manager/): For managing the SSL certificate for the domain.

## Pre-requisites

### Existing domains

This module is designed to be used with already existing domains that are not managed by AWS.

### AWS Account

You will need to have an AWS account with the following permissions:

> **Note:** The following image shows the permissions granted with full access. Permission policies should be revised to match your needs.

- S3:Create, list, update and delete buckets
- Cloudfront: Create, invalidate and update distributions
- Route53: Create zones and manage DNS records
- ACM: Create and manage SSL certificates
  
![alt text](docs/images/aws-account-permissions.png)

> **Note:** The module assumes the existence of an existing domain and the corresponding DNS records. If not, you will need to create them before deploying the module.
>
## Usage

To deploy the infrastructure, run the following commands:

(use `plan` first to see what will be deployed)

### 1. Route 53 host zone

![alt text](docs/images/tf-1.png)

```sh
terraform apply -var='enable_cert_validation=false'
```

This will create the Route 53 host zone for the domain and output the name servers to be updated in the domain registrar.

Example:

```sh
name_servers=["NS1", "NS2", "NS3", "NS4"]
```

> **Replace the name servers in your domain registrar with the ones from the output.**

### 2. Certified Infrastructure

![alt text](docs/images/tf-2.png)

```sh
terraform apply 
```

This will create the rest of the resources for the website and create the SSL certificate.

### 3. Static Website Content

Upload the static website content to the S3 bucket making sure the file structure is correct with `index.html` at the root.

#### 3.1 Github actions CICD

To automate the deployment, you can use Github actions.
Here's a [workflow example](docs/github-action/main.yml)

#### Requirements

- Branch named `main`
- Code source in `website/` directory
- Workflow file named `main.yml`
- Repository secrets:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `AWS_REGION`
  - `CLOUDFRONT_DISTRIBUTION_ID`
  - `S3_BUCKET_NAME`

---

Author: [Karis Omotosho](https://github.com/shonifari)

Github repo: [https://github.com/shonifari/aws-static-web-hosting](https://github.com/shonifari/aws-static-web-hosting)
