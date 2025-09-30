#These is my resource Block for ALB
resource "aws_lb" "this" {
  name               = "${var.project}-alb-${var.owner}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_alb_id]
  enable_deletion_protection = false
  subnets            = var.public_subnet_ids
  tags = { Name = "${var.project}-alb-${var.owner}" }
}

# Target Group for web servers
resource "aws_lb_target_group" "web_tg" {
  name     = "${var.project}-web-tg-${var.owner}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path = "/"
    matcher = "200-399"
    interval = 30
  }
  tags = { Name = "${var.project}-web-tg-${var.owner}" }
}

# These are Listener for HTTP traffic
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

# Output for alb and target group
output "alb_dns_name" { value = aws_lb.this.dns_name }
output "web_tg_arn" { value = aws_lb_target_group.web_tg.arn }
