resource "aws_db_subnet_group" "private_db_subnet" {
    name = "private_db_group"
    subnet_ids = [var.private_subnet_az1, var.private_subnet_az2]
    tags = {
      Name = "private_db_group"
    }
}

resource "aws_db_instance" "rds_db" {
    instance_class = "db.t3.micro"
    engine = "mysql"
    engine_version = "8.0"
    db_name = "no_cost_db"
    allocated_storage = 10
    multi_az = false
    publicly_accessible = false
    vpc_security_group_ids = [var.rds_sg_id]
    db_subnet_group_name = aws_db_subnet_group.private_db_subnet.name
    iam_database_authentication_enabled = true
    apply_immediately = true
    skip_final_snapshot = true
    storage_type = "gp2" 
    username = var.db_username
    password = var.db_password
    tags = {
      name = "no_cost_rds"
    }
}