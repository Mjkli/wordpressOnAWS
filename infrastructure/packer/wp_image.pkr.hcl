packer {
  required_plugins {
    docker = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}


locals{
  time = formatdate("DDMMMYYhhmm",timestamp())
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "wp-image ${local.time}"
  instance_type = "t2.micro"
  region        = "us-west-1"
  source_ami_filter {
    filters = {
      #name                = "wp-image *"
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    #owners      = ["181066809772"]
    owners = ["099720109477"] # Ubuntu
  }
  ssh_username = "ubuntu"
}

build {
  name = "building-wordpress"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "file" {
    source = "../../wp-config"
    destination = "/tmp"
  }

  provisioner "shell"{
    inline = [
      "sleep 30",
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "sudo apt-get install memcached libmemcached-tools php-memcached zip nfs-common apache2 mysql-client ghostscript libapache2-mod-php mysql-server php php-bcmath php-curl php-imagick php-intl php-json php-mbstring php-mysql php-xml php-zip -y",
      "sudo mkdir /var/www/html/wordpress",
      "sudo chmod 775 /var/www/html/wordpress",
      "sudo mv /tmp/wp-config/wordpress.conf /etc/apache2/sites-available/wordpress.conf",
      "sudo mv /tmp/wp-config/wp-config.php /var/www/html"
      ]
  }
}