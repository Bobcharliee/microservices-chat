# Security Group for Application load balancer
resource "aws_security_group" "load_balancer_sg" {
  name        = "${var.project}_load_balancer_sg"
  description = "Security group for application load balancer"
  vpc_id      = var.vpc_id

    ingress {
        from_port   = var.http_port
        to_port     = var.http_port
        protocol    = var.tcp_protocol
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = var.http_port_2
        to_port     = var.http_port_2
        protocol    = var.tcp_protocol
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = var.https_port
        to_port     = var.https_port
        protocol    = var.tcp_protocol
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    tags = {
        Name = "${var.project}_load_balancer_sg"
    }
}

# Security Group for Application servers
resource "aws_security_group" "app_server_sg" {
  name        = "${var.project}_app_server_sg"
  description = "Security group for application servers"
  vpc_id      = var.vpc_id
  ingress {
    description     = "Allow HTTP from Load Balancer"
    from_port       = var.http_port
    to_port         = var.http_port
    protocol        = var.tcp_protocol
    security_groups = [aws_security_group.load_balancer_sg.id]
  }

  ingress {
    description     = "Allow frontend app port 3000 from Load Balancer"
    from_port       = 3000
    to_port         = 3000
    protocol        = var.tcp_protocol
    security_groups = [aws_security_group.load_balancer_sg.id]
  }

  ingress {
    description     = "Allow SSH from Anywhere"
    from_port       = var.ssh_port
    to_port         = var.ssh_port
    protocol        = var.ssh_protocol
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    description     = "Allow HTTPS from Load Balancer"
    from_port       = var.https_port
    to_port         = var.https_port
    protocol        = var.tcp_protocol
    security_groups = [aws_security_group.load_balancer_sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "${var.project}_app_server_sg"
  }
}

# Security Group for Database server
resource "aws_security_group" "db_server_sg" {
  name        = "${var.project}_db_server_sg"
  description = "Security group for database server"
    vpc_id      = var.vpc_id
    ingress {
        description = "Allow MySQL from App server"
        from_port   = var.mysql_port
        to_port     = var.mysql_port
        protocol    = var.tcp_protocol
        security_groups = [aws_security_group.app_server_sg.id]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    tags = {
        Name = "${var.project}_db_server_sg"
    }
}