# Homework2Tf

## Configuration
Before building any resource on Terraform for this project it is necessary configure an Aws S3 backend creating an S3 bucket and DynamoDB table like it is show in the following [doc](https://www.terraform.io/language/settings/backends/s3).

Make sure that the region configured in the aws provider is the right one that you will use in your project

## Launch it
After setting up the backend for launching the infrastructure run the next commands:
1. `terraform init`.

2. `terraform apply` and type yes.
