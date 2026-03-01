resource "aws_security_group" "alb_sg" {
    vpc_id = var.vpc_id
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [var.internet_cidr]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [var.internet_cidr]
    }
}

resource "aws_security_group" "private_ec2_sg" {
    vpc_id = var.vpc_id
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [var.internet_cidr]
    }

    tags = {
        Name = " private app traffic"
    }
}

resource "aws_security_group" "vpc_endpoint_sg" {
    vpc_id = var.vpc_id
    tags = {
        Name = "vpc endpoint traffic"
    }
}

resource "aws_security_group" "rds_sg" {
    vpc_id = var.vpc_id
    tags = {
        Name = "private db traffic"
    }
}

resource "aws_security_group_rule" "alb_to_app" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    source_security_group_id = aws_security_group.alb_sg.id
    security_group_id = aws_security_group.private_ec2_sg.id
}

resource "aws_security_group_rule" "db_to_app" {
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    source_security_group_id = aws_security_group.private_ec2_sg.id
    security_group_id = aws_security_group.rds_sg.id
}

resource "aws_security_group_rule" "endpoint_to_app" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    source_security_group_id = aws_security_group.private_ec2_sg.id
    security_group_id = aws_security_group.vpc_endpoint_sg.id
}