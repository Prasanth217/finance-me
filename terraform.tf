terraform{
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secert_key
}

variable "aws_access_key"{}
variable "aws_secert_key"{}


resource "aws_vpc" "prasanth_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "prasanth-vpc"
  }
}

resource "aws_internet_gateway" "prasanth_igw" {
  vpc_id = aws_vpc.prasanth_vpc.id
  tags = {
    Name = "prasanth-igw"
  }
}

resource "aws_route_table" "prasanth_route_table" {
  vpc_id = aws_vpc.prasanth_vpc.id
  tags = {
    Name = "prasanth-route-table"
  }
}

resource "aws_subnet" "prasanth_subnet" {
  vpc_id     = aws_vpc.prasanth_vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "prasanth-subnet"
  }
}

resource "aws_route" "prasanth_route" {
  route_table_id         = aws_route_table.prasanth_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.prasanth_igw.id
}

resource "aws_route_table_association" "prasanth_subnet_association" {
  subnet_id      = aws_subnet.prasanth_subnet.id
  route_table_id = aws_route_table.prasanth_route_table.id
}

resource "aws_security_group" "prasanth_security_group" {
  name        = "prasanth-security-group"
  description = "prasanth Security Group"
  vpc_id      = aws_vpc.prasanth_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "prasanth-security-group"
  }
}

resource "aws_instance" "Test_server" {
  ami           = "ami-053b0d53c279acc90"  # Ubuntu 20.04 LTS AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.prasanth_subnet.id

  tags = {
    Name = "Test_server"
  }

  }

  resource "aws_instance" "prod_server" {
  ami           = "ami-053b0d53c279acc90"  # Ubuntu 20.04 LTS AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.prasanth_subnet.id

  tags = {
    Name = "prod_server"
  }

  }
