data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

#data "aws_vpc" "stage" {
  #filter {
    #name = "tag:Name"
    #values = ["stage-vpc"]
  #}
#}

resource "aws_security_group" "bastion" {
  name        = "Allow admin"
  description = "Allow ssh"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "ssh from admin"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
   
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "stage-bastion-sg"
    terraform = "true"
  }
}



resource "aws_instance" "bastion"{
  ami      = "ami-06489866022e12a14"
  instance_type = "t2.micro"
  #vpc_id = aws_vpc.vpc.id
  subnet_id = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.bastion.id]

  tags = {
    Name = "stage-bastion"
  }
}