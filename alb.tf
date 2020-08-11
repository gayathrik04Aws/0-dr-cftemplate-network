
resource "aws_lb" "sofe-dev-lb" {
  name               = "elb"
  internal           = false
  load_balancer_type = "application"
  #verify sg's http,https protocol
  security_groups    = [data.terraform_remote_state.networking.outputs.security_groups["schoolobjects"]]
  subnets            = data.terraform_remote_state.networking.outputs.public_subnets
  enable_deletion_protection = true
  access_logs {
  bucket  = "eduphoria-dev-elb-access-logs"
  prefix  = "dev-lb-logs"
  enabled = true
}
tags = {
    Environment = "dev"
  }
}

resource "aws_lb_target_group" "sofe-dev-tg" {
  name     = "sofe-dev-lb-tg"
  port     = 80
  protocol = "HTTP"
  target_type="instance"
  vpc_id   = module.vpc.vpc_id

  health_check {
  enabled = true
  healthy_threshold = 2
  path = "/infra_ready.aspx"
  interval= 30
  port =  443
  protocol = "HTTPS"
  timeout =  20
  unhealthy_threshold = 10
}
}

resource "aws_lb_target_group_attachment" "tg1" {
  target_group_arn = aws_lb_target_group.sofe-dev-tg.arn
  #target_id        =
  port             = 80
}
# alb listeners
resource "aws_lb_listener" "ssl" {
  load_balancer_arn = aws_lb.sofe-dev-lb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.SslCertificateArn
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group_attachment.tg1.arn
    }
}
resource "aws_lb_listener" "elbv2" {
  load_balancer_arn = aws_lb.sofe-dev-lb.arn
  port              = "80"
  protocol          = "HTTP"
  certificate_arn   = var.SslCertificateArn
  default_action {
    type = "redirect"
    redirect{
    # host =
    # path =
    # query =
    port= "443"
    protocol = "HTTPS"
    status_code =  "HTTP_302"
    }
    }
}
