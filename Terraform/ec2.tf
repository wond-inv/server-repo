provider "aws" {
  access_key = "AKIA6D7TMCOCJ4LWH5ME"
  secret_key = "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"
  region     = "us-east-1"
}

resource "aws_instance" "WindowsServer2016" {
  ami           = "ami-06f6f33114d2db0b1"
  instance_type = "t2.micro"
  key_name = "terraform-key"
  security_groups = ["${aws_security_group.allow_rdp.name}"]
}

resource "aws_security_group" "allow_rdp" {
  name	= "allow_rdp"
  description = "Allow ssh traffic"

  ingress {
   from_port = 3389
   to_port = 3389
   protocol ="tcp"

   cidr_blocks = ["0.0.0.0/0"]
  }
}
