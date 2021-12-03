terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.66.0"
    }
    /* random = { */
    /*   source  = "hashicorp/random" */
    /*   version = "~> 3.1.0" */
    /* } */
    /* archive = { */
    /*   source  = "hashicorp/archive" */
    /*   version = "~> 2.2.0" */
    /* } */
  }
}
provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.0"

  name = "marchanta-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["us-west-2a", "us-west-2b"]
  public_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_db_subnet_group" "marchanta" {
  name       = "marchanta"
  subnet_ids = module.vpc.public_subnets

  tags = {
    Name = "Marchanta"
  }
}

resource "aws_security_group" "rds" {
  name   = "marchanta_rds"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "marchanta_rds"
  }
}

resource "aws_db_parameter_group" "marchanta" {
  name   = "marchanta"
  family = "postgres13"
}

resource "random_password" "password" {
  length = 15
  special = true
}

resource "aws_db_instance" "marchanta" {
  identifier             = "marchanta"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  max_allocated_storage  = 10
  engine                 = "postgres"
  engine_version         = "13.1"
  username               = "postgres"
  password               = random_password.password.result
  db_subnet_group_name   = aws_db_subnet_group.marchanta.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.marchanta.name
  publicly_accessible    = true
  skip_final_snapshot    = true
  
}

resource "aws_kms_key" "default" {
  name = "rds_marchanta"
  description             = "RDS Key Management Service"
  deletion_window_in_days = 30

  tags = {
    Name = "marchanta"
  }
}

resourse "aws_secretsmanager_secret" "rds_marchanta_pass" {
  secret_id = aws_secretsmanager_secret.default.id
  secret_string = random_password.password.result
}

/* resource "random_pet" "lambda_bucket_name" { */
/*   prefix = "marchanta-lambdas" */
/*   length = 4 */
/* } */

/* resource "aws_s3_bucket" "lambda_bucket" { */
/*   bucket = random_pet.lambda_bucket_name.id */

/*   acl           = "private" */
/*   force_destroy = true */
/* } */
