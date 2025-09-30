#These is my resource Block for ASG
# These are my variables for ASG module
# here I am using template_file data source to read user_data script from file
data "template_file" "user_data_web" {
  template = file("${path.module}/user_data/web.sh.tpl")
  vars = {
    project = var.project
    name = var.name
  }
}

#these is my launch template for ASG
resource "aws_launch_template" "this" {
  name_prefix   = "${var.project}-${var.name}-lt-${var.owner}-"
  image_id      = var.ami
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  user_data = base64encode(data.template_file.user_data_web.rendered)

  vpc_security_group_ids = var.security_group_ids

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project}-${var.name}-${var.owner}"
    }
  }
}

# This is my Auto Scaling Group
#here I am using create_before_destroy lifecycle to avoid downtime during updates
resource "aws_autoscaling_group" "this" {
  name_prefix          = "${var.project}-${var.name}-asg-${var.owner}-"
  max_size             = var.max_size
  min_size             = var.min_size
  desired_capacity     = var.desired_capacity
  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
  vpc_zone_identifier = var.subnet_ids
  target_group_arns = var.target_group_arns
  tag {
    key                 = "Name"
    value               = "${var.project}-${var.name}-${var.owner}"
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
  }
}
