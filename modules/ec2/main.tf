data "aws_ami" "amazon_linux" {
    most_recent = true
    owners = ["amazon"]
    
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

resource "aws_launch_template" "private_instance_template" {
    name = "private_instance_template"
    image_id = data.aws_ami.amazon_linux.id
    instance_type = var.instance_type
    iam_instance_profile {
      name = var.ec2_instance_profile
    }
    network_interfaces {
      security_groups = [var.private_ec2_sg]
    }
    user_data = filebase64("./modules/ec2/user-data.sh")
    tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "private_instance_template_app"
    }
  }
}

resource "aws_autoscaling_group" "ec2_asg" {
    name = "ec2_asg"
    max_size = 3
    min_size = 2
    vpc_zone_identifier = [var.private_subnet_az1, var.private_subnet_az2 ]
    target_group_arns = [var.alb_tgs]
    launch_template {
      id = aws_launch_template.private_instance_template.id
      version = "$Latest"
    }
}

resource "aws_eip" "eip" {
    domain = "vpc"
    tags = {
      name = "terraform_eip"
    }
}


