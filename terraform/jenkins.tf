resource "aws_instance" "jenkins" {
  ami           = "ami-0f5ee92e2d63afc18" # Amazon Linux
  instance_type = "t2.micro"
  key_name      = "nexus"

  tags = {
    Name = "Jenkins-Server"
  }
}