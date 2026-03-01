resource "aws_lb_target_group" "alb_tg" {
    name = "ec2-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = var.vpc_id
    health_check {
        path = "/"
        healthy_threshold = 2
        interval = 60
    }
}

resource "aws_lb_target_group_attachment" "tg_ec2_attachment" {
    target_group_arn = aws_lb_target_group.alb_tg.id
    target_id = var.instance_id
    port = 80
}

resource "aws_alb" "alb" {
    name = "nginx-hosted-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [ var.alb_sg ] 
    subnets = [ var.public_subnet, var.public_subnet_az2 ]
    tags = {
      name = "terroform-alb"
    }
}

resource "aws_alb_listener" "ec2_alb_listerners" {
    load_balancer_arn = aws_alb.alb.arn
    port = 80
    protocol = "HTTP"
    # ssl_policy is not configured because https is not used in this project (only unsecured http)
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.alb_tg.arn
    }
}