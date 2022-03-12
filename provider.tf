provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "hw2-bucket-tf"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state"
  }
}

module "my_vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
}

module "my_ec2" {
  source = "./modules/ec2"
  vpc_id = module.my_vpc.vpc_id
  instance_type = "t2.micro"
}
