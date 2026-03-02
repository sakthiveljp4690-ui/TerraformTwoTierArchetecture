output "alb_endpoint" {
    value = aws_alb.alb.dns_name
}

output "alb_tgs" {
    value = aws_lb_target_group.alb_tg.arn
}