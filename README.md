# terraform-deploy-guestbook-eks
Terraform code to deploy guestbook application on EKS using terraform kubernetes provider.

## Prerequisites

- Terraform installed
- Existing EKS cluster named `student1-cluster` in `us-east-1` (or override via variables)
- AWS CLI configured using `aws configure` (or `AWS_PROFILE`) with permissions to:
	- Describe EKS cluster metadata
	- Request EKS authentication tokens
	- Manage Kubernetes resources on the cluster

## Configuration

This project now uses the AWS default credential chain, so no static keys are required in Terraform variables.

Default values are set in `variables.tf`:

- `aws_region = "us-east-1"`
- `eks_cluster_name = "student1-cluster"`

Optional override example:

```hcl
aws_region       = "us-east-1"
eks_cluster_name = "student1-cluster"
```

## Run

```bash
terraform init
terraform plan
terraform apply
```

## Guestbook Topology

The Redis tier uses inclusive `leader` and `follower` service names, and the manifests are aligned with the current upstream Kubernetes guestbook example.
