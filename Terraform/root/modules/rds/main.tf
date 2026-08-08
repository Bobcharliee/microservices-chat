data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_db_instance" "ms_db" {
  allocated_storage     = 10
  db_name               = "ms_db"
  engine                = "mysql"
  engine_version        = "8.0"
  instance_class        = "db.t3.micro"
  username              = var.db_username
  password              = var.db_password
  availability_zone     = data.aws_availability_zones.available.names[0]
  parameter_group_name  = "default.mysql8.0"
  skip_final_snapshot   = true
  vpc_security_group_ids = var.db_security_group_ids
  db_subnet_group_name  = aws_db_subnet_group.ms_db_subnet_group.name
}

resource "aws_db_subnet_group" "ms_db_subnet_group" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}