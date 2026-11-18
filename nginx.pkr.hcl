packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.8.4"
    }
  }
}

source "amazon-ebs" "webserver" {
  region        = "us-east-2"
  instance_type = "t3.micro"
  ami_name      = "golden-nginx-{{timestamp}}"

  source_ami_filter {
    filters = {
      name                = "al2023-ami-2023.*-x86_64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }

    owners      = ["amazon"]
    most_recent = true
  }

  ssh_username = "ec2-user"
}

build {
  sources = ["source.amazon-ebs.webserver"]

  provisioner "shell" {
    inline = [
      "sudo dnf install -y nginx",
      "sudo systemctl enable nginx"
    ]
  }
}
