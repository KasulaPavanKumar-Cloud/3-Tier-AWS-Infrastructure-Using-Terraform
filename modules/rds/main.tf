#here we create a subnet group for the RDS instance and then the RDS instance itself
resource "aws_db_subnet_group" "this" {
  name = "rds-${replace(lower(trimspace(var.project)), "/[^a-z0-9-]/", "-")}"
  subnet_ids = var.db_subnet_ids

  tags = {
  Name    = "rds-${replace(lower(trimspace(var.project)), "/[^a-z0-9-]/", "-")}-subnet-group"
  Owner   = lower(trimspace(var.owner))
  Project = lower(trimspace(var.project))
}
}

# here we Create the RDS instance
# Here we use the replace function to ensure that the identifier only contains valid characters
# We also use trimspace to remove any leading or trailing spaces from the project and owner variables
# and lower to convert them to lowercase
resource "aws_db_instance" "this" {
  identifier = "r-${replace(lower(trimspace(var.project)), "/[^a-z0-9-]/", "-")}-rds-${replace(lower(trimspace(var.owner)), "/[^a-z0-9-]/", "-")}"
  engine                 = var.engine
  instance_class         = var.instance_class
  username               = var.username
  password               = var.password
  allocated_storage      = var.allocated_storage
  db_subnet_group_name   = aws_db_subnet_group.this.id
  vpc_security_group_ids = [var.sg_db_id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = var.multi_az
  tags = {
    Name = "r-${replace(lower(trimspace(var.project)), "/[^a-z0-9-]/", "-")}-rds-${replace(lower(trimspace(var.owner)), "/[^a-z0-9-]/", "-")}"
  }
}
