locals {
  # The two tiers, provisioned from one definition via for_each.
  servers = {
    nginx   = "web tier (NGINX)"
    php_fpm = "app tier (PHP-FPM)"
  }
  tags = {
    Project   = var.project_name
    ManagedBy = "terraform"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.project_name}-deployer"
  public_key = file(var.ssh_public_key_path)
  tags       = local.tags
}

resource "aws_security_group" "web" {
  name_prefix = "${var.project_name}-sg-"
  description = "HTTP from anywhere, SSH from allowed_ssh_cidr"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

resource "aws_instance" "server" {
  for_each = local.servers

  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.web.id]

  tags = merge(local.tags, {
    Name = "${var.project_name}-${each.key}"
    Role = each.value
  })
}
