provider "aws" {
  region = "eu-north-1"
}

variable "public_key_path" {
  default = "~/.ssh/id_rsa_terraform.pub"
}

# Obtener la VPC por defecto
data "aws_vpc" "default" {
  default = true
}

# Obtener una subred de la VPC por defecto (usamos la primera disponible)
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_subnet" "default" {
  id = data.aws_subnets.default.ids[0]
}

# Crear grupo de seguridad con acceso público a SSH, HTTP y puertos 8081-8085
resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and Apache custom ports"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Apache custom ports"
    from_port   = 8081
    to_port     = 8085
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Crear la clave SSH
resource "aws_key_pair" "deployer" {
  key_name   = "terraform-key"
  public_key = file(var.public_key_path)
}

# Crear instancias EC2
resource "aws_instance" "awsapache" {
  count         = 5
  ami           = "ami-0c1ac8a41498c1a9c"
  instance_type = "t3.micro"
  key_name      = aws_key_pair.deployer.key_name

  subnet_id              = data.aws_subnet.default.id
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]

  associate_public_ip_address = true

  tags = {
    Name = "web${count.index + 1}"
  }
}

# Mostrar IPs públicas
output "instance_ips" {
  value = aws_instance.awsapache[*].public_ip
}

