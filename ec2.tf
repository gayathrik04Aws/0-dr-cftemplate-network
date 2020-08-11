#Creating Launch Configuration
resource "aws_launch_configuration" "sofe-dev" {
  name                        = "sofe-dev-test"
  image_id                    = lookup(var.ami_id, var.region)
  instance_type               = var.instance_type
  ebs_optimized               = true
  iam_instance_profile        = data.terraform_remote_state.security.outputs.sofe_role.name
  associate_public_ip_address = true
  security_groups             = [data.terraform_remote_state.networking.outputs.security_groups["schoolobjects"], data.terraform_remote_state.networking.outputs.security_groups["web"], data.terraform_remote_state.networking.outputs.security_groups["rdp"], data.terraform_remote_state.networking.outputs.security_groups["public-rdp"]]
  user_data                   = data.template_file.dev.rendered
}
resource "aws_iam_instance_profile" "ec2_profile" {
  name = data.terraform_remote_state.security.outputs.sofe_role.name
}
data "template_file" "dev" {
  template = "${file("init.txt")}"
  vars = {
    content_file = data.template_file.content.rendered
  }
}
data "template_file" "content" {
  template = "${file("poolconfiguration.xml")}"
}
