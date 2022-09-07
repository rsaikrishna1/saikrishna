
resource "aws_security_group" "apache" {
  name        = "Allow apache"
  description = "Allow apache"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "ssh from admin"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups = [aws_security_group.bastion.id]
   
  }


  ingress {
    description      = " from enduser"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [aws_security_group.alb.id]
   
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "stage-apache-sg"
    terraform = "true"
  }
}



resource "aws_instance" "grafana"{
  ami      = "ami-06489866022e12a14"
  instance_type = "t2.micro"
  #vpc_id = aws_vpc.vpc.id
  subnet_id = aws_subnet.private[0].id
  vpc_security_group_ids = [aws_security_group.apache.id]

  tags = {
    Name = "stage-grafana"
  }
}