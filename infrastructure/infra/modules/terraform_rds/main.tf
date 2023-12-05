resource "aws_db_subnet_group" "database" {
  name       = "database"
  subnet_ids = var.subnets

  tags = {
    Name = "database"
  }
}


resource "aws_db_instance" "database" {
  identifier             = "database"
  instance_class         = "db.t2.micro"
  allocated_storage      = 5
  engine                 = "mysql"
  username               = "root"
  password               = "example1234"
  db_subnet_group_name   = aws_db_subnet_group.database.name
  vpc_security_group_ids = var.sg
#   parameter_group_name   = aws_db_parameter_group.education.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}