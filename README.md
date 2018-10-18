# AWS EKS Cluster Terraform

This repository contains the Terraform code as described in the
[Getting Started with AWS EKS](https://www.terraform.io/docs/providers/aws/guides/eks-getting-started.html).

I keep it here as a base starting point to build on.

## Usage

This should run out of the box with no modification providing you have the
following set up:

1. An AWS access token with permissions to:
   - Permissions to create EC2 resources (VPCs, subnets, instances, security
     groups, etc.)
   - Permissions to create EKS clusters
   - Permissions to create IAM roles
2. `AWS_ACCESS_KEY` and `AWS_SECRET_ACCESS_KEY` environment variables set
3. `kubectl` installed
4. [aws-iam-authenticator](https://github.com/kubernetes-sigs/aws-iam-authenticator)
   installed

### Deploying the Cluster

#### Step 1

```
terraform init
```

#### Step 2

```
terraform apply -var 'local-office=81.129.43.245/32' \
                -var "aws-access-key=$AWS_ACCESS_KEY" \
                -var "aws-secret-key=$AWS_SECRET_ACCESS_KEY" \
                -var "aws-region=us-west-2" \
                -var 'cluster-name=your-cluster-name'
```

#### Step 3

Add the `kubeconfig` Terraform output to your `~/.kube/config` file.

#### Step 4

Store `config-map-aws-auth` Terraform output to a file called
`config-map-aws-auth.yaml` and run:

```
kubectl apply -f config-map-aws-auth.yaml
```

#### Step 5

To test the deployment run:

```
kubectl version
```

And

```
kubectl get nodes
```
