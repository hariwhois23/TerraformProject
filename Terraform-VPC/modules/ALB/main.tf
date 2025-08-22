#ALB

resource "aws_lb" "alb" {
  name               = "application-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_id]
  subnets            = var.subnets

  enable_deletion_protection = false #keep it false or you cant destroy this shit
  
}

#Listener
resource "aws_lb_listener" "Listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}


#target group 
resource "aws_lb_target_group" "tg" {
  name     = "albfortg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}


#target group attachment
resource "aws_lb_target_group_attachment" "tga" {
count = length(var.instances)
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.instances[count.index]
  port             = 80
}
