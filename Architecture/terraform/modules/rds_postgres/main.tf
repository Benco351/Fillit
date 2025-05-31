########################################
# Security Group for RDS Instance (RDS SG)
########################################
resource "aws_security_group" "rds_sg" {
  name        = "fillit-rds-sg"
  description = "Security group for RDS instance to accept connections from EB instances"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow PostgreSQL connections from EB instances"
    from_port       = 5432 // Use the correct port for your DB (usually 5432 for PostgreSQL)
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.eb_ec2_aws_security_group]
  }
  ingress {
    description = "Allow connections from the EC2 fillit rds bastion host"
    from_port   = 5432 
    to_port     = 5432
    protocol    = "tcp"
    security_groups = ["sg-002942f817e67bba4"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "fillit-rds-sg"
  }
}

resource "aws_db_subnet_group" "this" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids

  tags = {
    Name = var.subnet_group_name
  }
}

resource "aws_db_instance" "this" {
  identifier             = var.db_identifier
  engine                 = "postgres"
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  storage_type           = var.storage_type
  username               = var.username
  password               = var.password
  db_name                = var.db_name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.this.name
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = {
    Name = var.db_identifier
  }
}
