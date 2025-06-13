provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "mains-vpc" }
}

resource "aws_subnet" "msubnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_internet_gateway" "migw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group" "jenkins_sgm" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkinsm" {
  ami           = "ami-080270a5eef82c973" # Amazon Linux 2 (check latest)
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.msubnet.id
  vpc_security_group_ids = [aws_security_group.jenkins_sgm.id]
  user_data     = file("jenkins-install.sh")
  tags = { Name = "jenkins-server" }
}