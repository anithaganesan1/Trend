provider "aws" {
  region = "ap-south-1"
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get subnets in the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
# Generate a random suffix to avoid SG name conflict
resource "random_id" "suffix" {
  byte_length = 2
}

# Security group for Jenkins and app
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg-${random_id.suffix.hex}"
  description = "Allow ports for Jenkins and app"
  vpc_id      = data.aws_vpc.default.id

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

# EC2 instance for Jenkins
resource "aws_instance" "jenkins" {
  ami                         = "ami-080270a5eef82c973" # Amazon Linux 2 in ap-south-1
  instance_type               = "t3.micro"              # Use supported instance type
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true
  user_data                   = file("jenkins-install.sh")

  tags = {
    Name = "Jenkins-Server"
  }
}

# Output Jenkins public IP
output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}
