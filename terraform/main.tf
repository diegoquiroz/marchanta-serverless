provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.0"

  name                 = "marchanta-vpc"
  cidr                 = "10.0.0.0/16"

  azs                  = ["us-east-1"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

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
  family = "postgres14"
}

resource "aws_db_instance" "marchanta" {
  identifier             = "marchanta"
  instance_class         = "db.t2.micro"
  allocated_storage      = 5
  max_allocated_storage  = 10
  engine                 = "postgres"
  engine_version         = "13.1"
  username               = "postgres"
  password               = "var.db_password"
  db_subnet_group_name   = aws_db_subnet_group.education.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.education.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}
