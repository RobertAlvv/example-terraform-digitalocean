
resource "digitalocean_ssh_key" "web" {
  name = "ssh key"
  public_key =  file("C:\\Users\\alvar\\.ssh\\id_rsa.pub")
}

resource "digitalocean_droplet" "web" {
  image  = "docker-20-04"
  name   = "testing"
  region = "nyc"
  size   = "s-1vcpu-1gb" 
  private_networking = true
  ssh_keys = [
    digitalocean_ssh_key.web.id
  ]
  user_data = file("${path.module}/files/user-data.sh")
  connection {
    host = self.ipv4_address
    user = "root" 
    type = "ssh"
    private_key = file("C:\\Users\\alvar\\.ssh\\id_rsa")
    timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt install git",

      "git clone https://github.com/RobertAlvv/docker-compose-django-postgresql.git",
      "cd docker-compose-django-postgresql",
      "curl -L \"https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "chmod +x /usr/local/bin/docker-compose",
      "docker-compose --version",
      "docker-compose up -d --build",
      "docker-container ls",

      "sudo ufw allow 1339",
      "sudo ufw allow 5432",
      "sudo ufw allow 8000",
      "curl ifconfig.me"
    ]
  }
}

