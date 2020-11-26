resource "aws_instance" "ec2" {
  # ami           = "ami-0389b2a3c4948b1a0" # eu-west-2 ON-DEMAND - ec2-user
  ami           = "ami-0fb673bc6ff8fc282" # eu-west-2 SPOT - ubuntu
  instance_type = "t2.nano"
  key_name = "w.aws.eu-west-2"

  tags = {
    Name = var.module_server_name
    Type = "Spot"
  }

  user_data = data.template_file.init.rendered

}

data "template_file" "init" {
  template = "${file("${path.module}/init.tpl")}"
}
