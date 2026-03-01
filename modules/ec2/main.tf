data "aws_ami" "amazon_linux" {
    most_recent = true
    owners = ["amazon"]
    
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

resource "aws_instance" "private_instance" {
    ami = data.aws_ami.amazon_linux.id
    instance_type = var.instance_type
    iam_instance_profile = var.ec2_instance_profile
    vpc_security_group_ids = [var.private_ec2_sg]
    subnet_id = var.private_subnet_az1
    associate_public_ip_address = false
    user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install nginx1
              sudo systemctl start nginx
              sudo systemctl enable nginx
              sudo yum install mysql -y
              sudo curl -O https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem
              EOF
    tags = {
        Name = "terraform-application-private"
    }
}

resource "aws_eip" "eip" {
    domain = "vpc"
    tags = {
      name = "terraform_eip"
    }
}


