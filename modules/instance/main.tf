resource "aws_instance" "demo-server" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = var.instance_type
  key_name      = "interview"
  //security_groups = [ "demo-sg" ]
  vpc_security_group_ids      = [aws_security_group.demo-sg.id]
  associate_public_ip_address = true
  subnet_id                   = var.subnet_id

  count = length(var.ec2_instance_name)
  tags = {
    Name = var.ec2_instance_name[count.index]
  }
}

resource "aws_security_group" "demo-sg" {
  name        = var.sg_name
  description = "SSH Access"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "sonar access"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "App port"
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ECR port"
    from_port   = 8096
    to_port     = 8096
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ssh-prot"

  }
}
