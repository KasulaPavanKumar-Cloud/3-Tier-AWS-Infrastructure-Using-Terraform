# These are my resource Block for IAM module
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

#here I am creating IAM role for EC2 with SSM and CloudWatch policies attached
resource "aws_iam_role" "ec2_ssm_role" {
  name = "${var.project}-ec2-ssm-role-${var.owner}"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
  tags = { Name = "${var.project}-ec2-ssm-role-${var.owner}" }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "cw" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project}-ec2-profile-${var.owner}"
  role = aws_iam_role.ec2_ssm_role.name
}

output "instance_profile_name" { value = aws_iam_instance_profile.ec2_profile.name }
output "instance_role_name" { value = aws_iam_role.ec2_ssm_role.name }
